import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/supabase_config.dart';
import '../data/local/database.dart';
import '../data/local/daos/entry_dao.dart';
import 'connectivity_provider.dart';
import 'database_provider.dart';

/// Sync status for UI display.
enum SyncStatus {
  idle,
  syncing,
  error,
}

/// Sync state with pending count and status.
class SyncState {
  final int pendingCount;
  final SyncStatus status;
  final String? lastError;

  const SyncState({
    this.pendingCount = 0,
    this.status = SyncStatus.idle,
    this.lastError,
  });

  SyncState copyWith({
    int? pendingCount,
    SyncStatus? status,
    String? lastError,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
    );
  }

  bool get hasPending => pendingCount > 0;
}

/// Provider for sync state and operations.
final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

/// Provider for pending sync count (for UI indicators).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final syncDao = ref.watch(syncDaoProvider);
  return syncDao.watchPendingCount();
});

/// Notifier for managing sync operations.
class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;
  bool _isProcessing = false;

  SyncNotifier(this._ref) : super(const SyncState()) {
    _init();
  }

  void _init() {
    // Listen for connectivity changes
    _ref.listen<ConnectivityState>(connectivityProvider, (previous, next) {
      // When going from offline to online, trigger sync
      if (previous == ConnectivityState.offline &&
          next == ConnectivityState.online) {
        processPendingSync();
      }
    });

    // Load initial pending count
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final syncDao = _ref.read(syncDaoProvider);
    final count = await syncDao.getPendingCount();
    if (mounted) {
      state = state.copyWith(pendingCount: count);
    }
  }

  /// Process all pending sync items.
  Future<void> processPendingSync() async {
    if (_isProcessing) return;

    final isOnline = _ref.read(connectivityProvider) == ConnectivityState.online;
    if (!isOnline) return;

    _isProcessing = true;
    if (mounted) {
      state = state.copyWith(status: SyncStatus.syncing);
    }

    try {
      final syncDao = _ref.read(syncDaoProvider);
      final entryDao = _ref.read(entryDaoProvider);
      final items = await syncDao.getPendingItems();

      for (final item in items) {
        try {
          await _processItem(item, entryDao);
          await syncDao.removeFromQueue(item.id);
        } catch (e) {
          await syncDao.markRetry(item.id, e.toString());
        }
      }

      // Clean up failed items
      await syncDao.removeFailedItems();

      // Update pending count
      final remainingCount = await syncDao.getPendingCount();
      if (mounted) {
        state = state.copyWith(
          pendingCount: remainingCount,
          status: SyncStatus.idle,
          lastError: null,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: SyncStatus.error,
          lastError: e.toString(),
        );
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item, EntryDao entryDao) async {
    switch (item.targetTable) {
      case 'daily_entries':
        await _syncEntry(item, entryDao);
        break;
      case 'entry_platform_spends':
        await _syncSpend(item);
        break;
      default:
        // Unknown table, skip
        break;
    }
  }

  Future<void> _syncEntry(SyncQueueData item, EntryDao entryDao) async {
    switch (item.operation) {
      case 'insert':
        final entry = await entryDao.getEntryById(item.recordId);
        if (entry != null) {
          final spends = await entryDao.getSpends(entry.id);
          final spendsMap = <String, int>{};
          for (final spend in spends) {
            spendsMap[spend.platform] = spend.amount;
          }

          await SupabaseConfig.client.from('daily_entries').insert({
            'id': entry.id,
            'tracker_id': entry.trackerId,
            'entry_date': entry.entryDate.toIso8601String().split('T')[0],
            'total_revenue': entry.totalRevenue,
            'total_dms_leads': entry.totalDmsLeads,
            'notes': entry.notes,
            'created_at': entry.createdAt.toIso8601String(),
            'updated_at': entry.updatedAt.toIso8601String(),
          });

          // Sync platform spends
          if (spendsMap.isNotEmpty) {
            final spendsData = spendsMap.entries
                .map((e) => {
                      'id': '${entry.id}_${e.key}',
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          // Update local sync status
          await entryDao.updateSyncStatus(entry.id, 'synced');
        }
        break;

      case 'update':
        final entry = await entryDao.getEntryById(item.recordId);
        if (entry != null) {
          final spends = await entryDao.getSpends(entry.id);
          final spendsMap = <String, int>{};
          for (final spend in spends) {
            spendsMap[spend.platform] = spend.amount;
          }

          await SupabaseConfig.client
              .from('daily_entries')
              .update({
                'entry_date': entry.entryDate.toIso8601String().split('T')[0],
                'total_revenue': entry.totalRevenue,
                'total_dms_leads': entry.totalDmsLeads,
                'notes': entry.notes,
                'updated_at': entry.updatedAt.toIso8601String(),
              })
              .eq('id', entry.id);

          // Delete and re-insert spends
          await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', entry.id);
          if (spendsMap.isNotEmpty) {
            final spendsData = spendsMap.entries
                .map((e) => {
                      'id': '${entry.id}_${e.key}',
                      'entry_id': entry.id,
                      'platform': e.key,
                      'amount': e.value,
                    })
                .toList();
            await SupabaseConfig.client.from('entry_platform_spends').insert(spendsData);
          }

          // Update local sync status
          await entryDao.updateSyncStatus(entry.id, 'synced');
        }
        break;

      case 'delete':
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('entry_id', item.recordId);
        await SupabaseConfig.client.from('daily_entries').delete().eq('id', item.recordId);
        break;
    }
  }

  Future<void> _syncSpend(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;

    switch (item.operation) {
      case 'insert':
      case 'update':
        await SupabaseConfig.client.from('entry_platform_spends').upsert(payload);
        break;
      case 'delete':
        await SupabaseConfig.client.from('entry_platform_spends').delete().eq('id', item.recordId);
        break;
    }
  }
}
