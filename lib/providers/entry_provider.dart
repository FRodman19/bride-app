import 'dart:convert';
import 'package:crypto/crypto.dart';
// import 'package:drift/drift.dart' hide Column; // Removed - no longer using local caching
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/config/supabase_config.dart';
// import '../data/local/database.dart'; // Removed - no longer using local caching
import 'connectivity_provider.dart';
// import 'database_provider.dart'; // Removed - no longer using local caching

/// Generate a deterministic UUID from entry_id and platform.
/// This ensures the same spend always gets the same ID.
String _generateSpendId(String entryId, String platform) {
  final bytes = utf8.encode('$entryId:$platform');
  final hash = md5.convert(bytes);
  // Format as UUID (8-4-4-4-12)
  final hex = hash.toString();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
}

/// Domain model for a daily entry with calculated profit.
class Entry {
  final String id;
  final String trackerId;
  final DateTime entryDate;
  final int totalRevenue;
  final int totalDmsLeads;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, int> platformSpends;

  Entry({
    required this.id,
    required this.trackerId,
    required this.entryDate,
    required this.totalRevenue,
    this.totalDmsLeads = 0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.platformSpends = const {},
  });

  /// Calculate total spend from all platforms
  int get totalSpend => platformSpends.values.fold(0, (a, b) => a + b);

  /// Calculate profit (revenue - total spend)
  int get profit => totalRevenue - totalSpend;

  /// Check if this entry is profitable
  bool get isProfitable => profit >= 0;

  /// Create a new entry with generated ID
  factory Entry.create({
    required String trackerId,
    required DateTime entryDate,
    required int totalRevenue,
    int totalDmsLeads = 0,
    String? notes,
    Map<String, int> platformSpends = const {},
  }) {
    final now = DateTime.now();
    return Entry(
      id: const Uuid().v4(),
      trackerId: trackerId,
      entryDate: entryDate,
      totalRevenue: totalRevenue,
      totalDmsLeads: totalDmsLeads,
      notes: notes,
      createdAt: now,
      updatedAt: now,
      platformSpends: platformSpends,
    );
  }

  /// Create a copy with updated fields
  Entry copyWith({
    DateTime? entryDate,
    int? totalRevenue,
    int? totalDmsLeads,
    String? notes,
    Map<String, int>? platformSpends,
    DateTime? updatedAt,
  }) {
    return Entry(
      id: id,
      trackerId: trackerId,
      entryDate: entryDate ?? this.entryDate,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalDmsLeads: totalDmsLeads ?? this.totalDmsLeads,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      platformSpends: platformSpends ?? this.platformSpends,
    );
  }

  /// Convert to map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracker_id': trackerId,
      'entry_date': entryDate.toIso8601String().split('T')[0], // Date only
      'total_revenue': totalRevenue,
      'total_dms_leads': totalDmsLeads,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// State for entries list for a specific tracker.
sealed class EntriesState {
  const EntriesState();
}

class EntriesLoading extends EntriesState {
  const EntriesLoading();
}

class EntriesLoaded extends EntriesState {
  final List<Entry> entries;
  final String trackerId;

  const EntriesLoaded(this.entries, {required this.trackerId});

  /// Get entries for the current week
  List<Entry> get thisWeekEntries {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return entries.where((e) => e.entryDate.isAfter(start) || _isSameDay(e.entryDate, start)).toList();
  }

  /// Get entries for the current month
  List<Entry> get thisMonthEntries {
    final now = DateTime.now();
    return entries.where((e) => e.entryDate.year == now.year && e.entryDate.month == now.month).toList();
  }

  /// Calculate total revenue
  int get totalRevenue => entries.fold(0, (sum, e) => sum + e.totalRevenue);

  /// Calculate total spend
  int get totalSpend => entries.fold(0, (sum, e) => sum + e.totalSpend);

  /// Calculate total profit
  int get totalProfit => totalRevenue - totalSpend;

  /// Calculate total DMs/Leads
  int get totalDmsLeads => entries.fold(0, (sum, e) => sum + e.totalDmsLeads);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class EntriesError extends EntriesState {
  final String message;
  const EntriesError(this.message);
}

/// Provider for entries of a specific tracker.
final entriesProvider = StateNotifierProvider.family<EntriesNotifier, EntriesState, String>((ref, trackerId) {
  return EntriesNotifier(ref, trackerId);
});

/// Convenience provider to get a single entry by ID.
final entryByIdProvider = Provider.family<Entry?, ({String trackerId, String entryId})>((ref, params) {
  final state = ref.watch(entriesProvider(params.trackerId));
  if (state is EntriesLoaded) {
    try {
      return state.entries.firstWhere((e) => e.id == params.entryId);
    } catch (_) {
      return null;
    }
  }
  return null;
});

/// Notifier for managing entries with online-first approach.
///
/// ONLINE-FIRST ARCHITECTURE:
/// 1. Check if online → if not, return friendly error
/// 2. Write to Supabase FIRST
/// 3. If Supabase fails → return friendly error (DO NOT save locally)
/// 4. If Supabase succeeds → cache locally
/// 5. No sync queue, no syncStatus checking
class EntriesNotifier extends StateNotifier<EntriesState> {
  final Ref _ref;
  final String trackerId;

  EntriesNotifier(this._ref, this.trackerId) : super(const EntriesLoading()) {
    loadEntries();
  }

  bool get _isOnline => _ref.read(connectivityProvider) == ConnectivityState.online;

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyError(dynamic error, String action) {
    final errorStr = error.toString().toLowerCase();

    // Network/connectivity errors
    if (errorStr.contains('network') ||
        errorStr.contains('socket') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout')) {
      return "We couldn't $action your entry. Please check your internet connection and try again.";
    }

    // Supabase/server errors
    if (errorStr.contains('postgrest') ||
        errorStr.contains('supabase') ||
        errorStr.contains('server')) {
      return "We're having trouble connecting to our servers. Please try again in a moment.";
    }

    // Authentication errors
    if (errorStr.contains('auth') ||
        errorStr.contains('token') ||
        errorStr.contains('unauthorized')) {
      return "Your session has expired. Please sign in again.";
    }

    // Generic fallback
    return "We couldn't $action your entry. Please try again.";
  }

  /// Load all entries for this tracker ONLY from Supabase.
  /// ONLINE-FIRST: Never loads from local cache.
  Future<void> loadEntries() async {
    if (mounted) state = const EntriesLoading();

    try {
      // Check if online
      if (!_isOnline) {
        if (mounted) {
          state = const EntriesError(
            "You're offline. Please check your internet connection and try again."
          );
        }
        return;
      }

      // Load ONLY from Supabase
      final response = await SupabaseConfig.client
          .from('daily_entries')
          .select('''
            *,
            entry_platform_spends(id, platform, amount)
          ''')
          .eq('tracker_id', trackerId)
          .order('entry_date', ascending: false);

      // Convert to domain entries
      final domainEntries = <Entry>[];
      for (final data in (response as List)) {
        // Extract platform spends
        final spendsData = data['entry_platform_spends'] as List?;
        final spendsMap = <String, int>{};
        if (spendsData != null) {
          for (final spend in spendsData) {
            spendsMap[spend['platform'] as String] = spend['amount'] as int;
          }
        }

        domainEntries.add(Entry(
          id: data['id'] as String,
          trackerId: data['tracker_id'] as String,
          entryDate: DateTime.parse(data['entry_date'] as String),
          totalRevenue: data['total_revenue'] as int,
          totalDmsLeads: data['total_dms_leads'] as int? ?? 0,
          notes: data['notes'] as String?,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: DateTime.parse(data['updated_at'] as String),
          platformSpends: spendsMap,
        ));
      }

      if (mounted) {
        state = EntriesLoaded(domainEntries, trackerId: trackerId);
      }
    } catch (e) {
      if (mounted) state = EntriesError(_getUserFriendlyError(e, 'load'));
    }
  }

  /// Create a new entry (ONLINE-FIRST).
  Future<EntryResult> createEntry({
    required DateTime entryDate,
    required int totalRevenue,
    int totalDmsLeads = 0,
    String? notes,
    Map<String, int> platformSpends = const {},
  }) async {
    // Validate: no future dates
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final entryStart = DateTime(entryDate.year, entryDate.month, entryDate.day);

    if (entryStart.isAfter(todayStart)) {
      return EntryResult.error('Cannot log entries for future dates');
    }

    // 1. Check if online
    if (!_isOnline) {
      return EntryResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      // Check for duplicate entry on same date (from Supabase, not local cache)
      final existingResponse = await SupabaseConfig.client
          .from('daily_entries')
          .select('id')
          .eq('tracker_id', trackerId)
          .eq('entry_date', entryStart.toIso8601String().split('T')[0])
          .maybeSingle();

      if (existingResponse != null) {
        return EntryResult.error('An entry already exists for this date. Please edit the existing entry instead.');
      }

      // Create the entry
      final entry = Entry.create(
        trackerId: trackerId,
        entryDate: entryStart,
        totalRevenue: totalRevenue,
        totalDmsLeads: totalDmsLeads,
        notes: notes,
        platformSpends: platformSpends,
      );

      // 2. Write to Supabase FIRST
      try {
        await SupabaseConfig.client.from('daily_entries').insert(entry.toMap());

        // Insert platform spends
        if (platformSpends.isNotEmpty) {
          final spendsData = platformSpends.entries
              .map((e) => {
                    'id': _generateSpendId(entry.id, e.key),
                    'entry_id': entry.id,
                    'platform': e.key,
                    'amount': e.value,
                  })
              .toList();
          await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
        }
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return EntryResult.error(_getUserFriendlyError(e, 'save'));
      }

      // NO local caching - Supabase is the source of truth

      await loadEntries();
      return EntryResult.success(entry);
    } catch (e) {
      return EntryResult.error(_getUserFriendlyError(e, 'save'));
    }
  }

  /// Update an existing entry (ONLINE-FIRST).
  Future<EntryResult> updateEntry(Entry entry) async {
    // 1. Check if online
    if (!_isOnline) {
      return EntryResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      final updatedEntry = entry.copyWith(updatedAt: DateTime.now());

      // 2. Write to Supabase FIRST
      try {
        await SupabaseConfig.client
            .from('daily_entries')
            .update(updatedEntry.toMap())
            .eq('id', entry.id);

        // Delete and re-insert spends
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', entry.id);

        if (updatedEntry.platformSpends.isNotEmpty) {
          final spendsData = updatedEntry.platformSpends.entries
              .map((e) => {
                    'id': _generateSpendId(entry.id, e.key),
                    'entry_id': entry.id,
                    'platform': e.key,
                    'amount': e.value,
                  })
              .toList();
          await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
        }
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT save locally)
        return EntryResult.error(_getUserFriendlyError(e, 'update'));
      }

      // NO local caching - Supabase is the source of truth

      await loadEntries();
      return EntryResult.success(updatedEntry);
    } catch (e) {
      return EntryResult.error(_getUserFriendlyError(e, 'update'));
    }
  }

  /// Delete an entry (ONLINE-FIRST).
  Future<EntryResult> deleteEntry(String entryId) async {
    // 1. Check if online
    if (!_isOnline) {
      return EntryResult.error(
        "You're offline. Please check your internet connection and try again."
      );
    }

    try {
      // 2. Delete from Supabase FIRST
      try {
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', entryId);
        await SupabaseConfig.client.from('daily_entries').delete().eq('id', entryId);
      } catch (e) {
        // 3. If Supabase fails, return friendly error (DO NOT delete locally)
        return EntryResult.error(_getUserFriendlyError(e, 'delete'));
      }

      // NO local caching - Supabase is the source of truth

      await loadEntries();
      return EntryResult.success(null);
    } catch (e) {
      return EntryResult.error(_getUserFriendlyError(e, 'delete'));
    }
  }
}

/// Result of an entry operation.
class EntryResult {
  final bool success;
  final Entry? entry;
  final String? error;

  const EntryResult({
    required this.success,
    this.entry,
    this.error,
  });

  factory EntryResult.success(Entry? entry) => EntryResult(
        success: true,
        entry: entry,
      );

  factory EntryResult.error(String message) => EntryResult(
        success: false,
        error: message,
      );
}
