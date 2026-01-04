import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/config/supabase_config.dart';
import '../data/local/database.dart';
import 'connectivity_provider.dart';
import 'database_provider.dart';

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
      'entry_date': entryDate.toIso8601String(),
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

/// Notifier for managing entries with offline-first support.
class EntriesNotifier extends StateNotifier<EntriesState> {
  final Ref _ref;
  final String trackerId;

  EntriesNotifier(this._ref, this.trackerId) : super(const EntriesLoading()) {
    loadEntries();
  }

  bool get _isOnline => _ref.read(connectivityProvider) == ConnectivityState.online;

  /// Load all entries for this tracker.
  Future<void> loadEntries() async {
    if (mounted) state = const EntriesLoading();

    try {
      final entryDao = _ref.read(entryDaoProvider);

      // Load from local database
      final localEntries = await entryDao.getEntriesForTracker(trackerId);

      // Convert to domain entries with spends
      final domainEntries = <Entry>[];
      for (final entry in localEntries) {
        final spends = await entryDao.getSpends(entry.id);
        final spendsMap = <String, int>{};
        for (final spend in spends) {
          spendsMap[spend.platform] = spend.amount;
        }

        domainEntries.add(Entry(
          id: entry.id,
          trackerId: entry.trackerId,
          entryDate: entry.entryDate,
          totalRevenue: entry.totalRevenue,
          totalDmsLeads: entry.totalDmsLeads,
          notes: entry.notes,
          createdAt: entry.createdAt,
          updatedAt: entry.updatedAt,
          platformSpends: spendsMap,
        ));
      }

      if (mounted) {
        state = EntriesLoaded(domainEntries, trackerId: trackerId);
      }
    } catch (e) {
      if (mounted) state = EntriesError('Failed to load entries: $e');
    }
  }

  /// Create a new entry.
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

    try {
      final entryDao = _ref.read(entryDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      // Check for duplicate entry on same date
      final existing = await entryDao.getEntryForDate(trackerId, entryDate);
      if (existing != null) {
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

      // Save to local database
      final entryCompanion = DailyEntriesCompanion.insert(
        id: entry.id,
        trackerId: entry.trackerId,
        entryDate: entry.entryDate,
        totalRevenue: entry.totalRevenue,
        totalDmsLeads: Value(entry.totalDmsLeads),
        notes: Value(entry.notes),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await entryDao.insertEntry(entryCompanion);
      await entryDao.setSpends(entry.id, platformSpends);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client.from('daily_entries').insert(entry.toMap());

          // Insert platform spends
          if (platformSpends.isNotEmpty) {
            final spendsData = platformSpends.entries
                .map((e) => {
                      'id': '${entry.id}_${e.key}',
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          await entryDao.markAsSynced(entry.id);
        } catch (e) {
          // Queue for later sync
          await syncDao.addToQueue(
            targetTable: 'daily_entries',
            recordId: entry.id,
            operation: 'insert',
            payload: jsonEncode(entry.toMap()),
          );
        }
      } else {
        // Offline - queue for later
        await syncDao.addToQueue(
          targetTable: 'daily_entries',
          recordId: entry.id,
          operation: 'insert',
          payload: jsonEncode(entry.toMap()),
        );
      }

      await loadEntries();
      return EntryResult.success(entry);
    } catch (e) {
      return EntryResult.error('Failed to create entry: $e');
    }
  }

  /// Update an existing entry.
  Future<EntryResult> updateEntry(Entry entry) async {
    try {
      final entryDao = _ref.read(entryDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      final updatedEntry = entry.copyWith(updatedAt: DateTime.now());

      // Update local
      final entryCompanion = DailyEntriesCompanion(
        id: Value(updatedEntry.id),
        trackerId: Value(updatedEntry.trackerId),
        entryDate: Value(updatedEntry.entryDate),
        totalRevenue: Value(updatedEntry.totalRevenue),
        totalDmsLeads: Value(updatedEntry.totalDmsLeads),
        notes: Value(updatedEntry.notes),
        createdAt: Value(updatedEntry.createdAt),
        updatedAt: Value(updatedEntry.updatedAt),
        syncStatus: Value(_isOnline ? 'synced' : 'pending'),
      );

      await entryDao.updateEntry(entryCompanion);
      await entryDao.setSpends(updatedEntry.id, updatedEntry.platformSpends);

      // Sync to remote if online
      if (_isOnline) {
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
                      'id': '${entry.id}_${e.key}',
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          await entryDao.markAsSynced(entry.id);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'daily_entries',
            recordId: entry.id,
            operation: 'update',
            payload: jsonEncode(updatedEntry.toMap()),
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'daily_entries',
          recordId: entry.id,
          operation: 'update',
          payload: jsonEncode(updatedEntry.toMap()),
        );
      }

      await loadEntries();
      return EntryResult.success(updatedEntry);
    } catch (e) {
      return EntryResult.error('Failed to update entry: $e');
    }
  }

  /// Delete an entry.
  Future<EntryResult> deleteEntry(String entryId) async {
    try {
      final entryDao = _ref.read(entryDaoProvider);
      final syncDao = _ref.read(syncDaoProvider);

      // Delete locally (cascades to spends)
      await entryDao.deleteEntry(entryId);

      // Sync to remote if online
      if (_isOnline) {
        try {
          await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', entryId);
          await SupabaseConfig.client.from('daily_entries').delete().eq('id', entryId);
        } catch (e) {
          await syncDao.addToQueue(
            targetTable: 'daily_entries',
            recordId: entryId,
            operation: 'delete',
            payload: '{}',
          );
        }
      } else {
        await syncDao.addToQueue(
          targetTable: 'daily_entries',
          recordId: entryId,
          operation: 'delete',
          payload: '{}',
        );
      }

      await syncDao.clearForRecord(entryId);
      await loadEntries();
      return EntryResult.success(null);
    } catch (e) {
      return EntryResult.error('Failed to delete entry: $e');
    }
  }

  /// Check if an entry exists for a given date.
  Future<bool> hasEntryForDate(DateTime date) async {
    final entryDao = _ref.read(entryDaoProvider);
    final existing = await entryDao.getEntryForDate(trackerId, date);
    return existing != null;
  }

  /// Get entry for a specific date (if exists).
  Future<Entry?> getEntryForDate(DateTime date) async {
    final entryDao = _ref.read(entryDaoProvider);
    final entry = await entryDao.getEntryForDate(trackerId, date);
    if (entry == null) return null;

    final spends = await entryDao.getSpends(entry.id);
    final spendsMap = <String, int>{};
    for (final spend in spends) {
      spendsMap[spend.platform] = spend.amount;
    }

    return Entry(
      id: entry.id,
      trackerId: entry.trackerId,
      entryDate: entry.entryDate,
      totalRevenue: entry.totalRevenue,
      totalDmsLeads: entry.totalDmsLeads,
      notes: entry.notes,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      platformSpends: spendsMap,
    );
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
