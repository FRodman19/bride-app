import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages notification IDs for tracker reminders.
///
/// Ensures collision-free notification IDs by using sequential allocation
/// with persistence across app restarts.
///
/// ID Range: 1000-9999 (9000 available IDs, enough for max 20 trackers × 2 notifications each)
/// System IDs: 0-999 (reserved for global notifications like daily reminders)
class NotificationIdManager {
  static const String _storageKey = 'notification_id_mappings';
  static const int _startRange = 1000;
  static const int _endRange = 9999;

  static final Map<String, int> _trackerToIdMap = {};
  static final Set<int> _usedIds = {};  // O(1) lookup instead of O(n)
  static int _nextAvailableId = _startRange;
  static bool _isInitialized = false;
  static SharedPreferences? _prefs;

  // Simple mutex using Completer for thread safety
  static Completer<void> _lock = Completer<void>()..complete();

  /// Initialize the manager and load existing mappings from storage.
  /// MUST be called before any other methods.
  static Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadMappings();
    _isInitialized = true;

    debugPrint('NotificationIdManager initialized with ${_trackerToIdMap.length} existing mappings');
  }

  /// Get or assign a notification ID for a tracker.
  ///
  /// Returns the same ID if tracker already has one assigned.
  /// Throws [NotificationIdPoolExhaustedException] if pool is full.
  static Future<int> getOrAssignId(String trackerId) async {
    _ensureInitialized();

    // Wait for any pending operation (thread safety)
    await _lock.future;

    // Create new lock for this operation
    final currentLock = Completer<void>();
    _lock = currentLock;  // Atomically replace lock

    try {
      // Return existing ID if already assigned
      if (_trackerToIdMap.containsKey(trackerId)) {
        return _trackerToIdMap[trackerId]!;
      }

      // Find next available ID using O(1) Set lookup
      while (_nextAvailableId <= _endRange) {
        if (!_usedIds.contains(_nextAvailableId)) {
          final id = _nextAvailableId;
          _trackerToIdMap[trackerId] = id;
          _usedIds.add(id);
          _nextAvailableId++;

          // CRITICAL: Await save to prevent data loss
          await _saveMappings();

          debugPrint('Assigned notification ID $id to tracker $trackerId');
          return id;
        }
        _nextAvailableId++;
      }

      throw NotificationIdPoolExhaustedException(
        'Notification ID pool exhausted (max 9000 trackers supported)',
      );
    } finally {
      currentLock.complete(); // Release lock
    }
  }

  /// Get the notification ID for a tracker without assigning a new one.
  ///
  /// Returns null if tracker has no ID assigned yet.
  static int? getId(String trackerId) {
    _ensureInitialized();
    return _trackerToIdMap[trackerId];
  }

  /// Release the notification ID when tracker is deleted.
  ///
  /// The ID can be reused by other trackers after this call.
  static Future<void> releaseId(String trackerId) async {
    _ensureInitialized();

    // Wait for any pending operation (thread safety)
    await _lock.future;

    // Create new lock for this operation
    final currentLock = Completer<void>();
    _lock = currentLock;  // Atomically replace lock

    try {
      if (_trackerToIdMap.containsKey(trackerId)) {
        final id = _trackerToIdMap[trackerId]!;
        _trackerToIdMap.remove(trackerId);
        _usedIds.remove(id);

        // Reset next available ID if this was the lowest available
        if (id < _nextAvailableId) {
          _nextAvailableId = id;
        }

        await _saveMappings();
        debugPrint('Released notification ID $id from tracker $trackerId');
      }
    } finally {
      currentLock.complete(); // Release lock
    }
  }

  /// Get all assigned IDs (for debugging/testing).
  static List<int> getAllAssignedIds() {
    _ensureInitialized();
    return _trackerToIdMap.values.toList()..sort();
  }

  /// Clear all mappings (use with caution - for testing only).
  @visibleForTesting
  static Future<void> clearAll() async {
    _ensureInitialized();

    _trackerToIdMap.clear();
    _usedIds.clear();
    _nextAvailableId = _startRange;

    await _saveMappings();
  }

  static Future<void> _loadMappings() async {
    final stored = _prefs?.getString(_storageKey);
    if (stored != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(stored);
        _trackerToIdMap.clear();
        _usedIds.clear();

        // Load tracker -> ID mappings
        decoded.forEach((trackerId, id) {
          final idInt = id as int;
          _trackerToIdMap[trackerId] = idInt;
          _usedIds.add(idInt);
        });

        // Find highest ID to set next available (with overflow protection)
        if (_usedIds.isNotEmpty) {
          final maxId = _usedIds.reduce(max);
          _nextAvailableId = (maxId + 1).clamp(_startRange, _endRange);
        }

        debugPrint('Loaded ${_trackerToIdMap.length} notification ID mappings');
      } catch (e) {
        debugPrint('Failed to load notification ID mappings: $e');
        // Reset on error
        _trackerToIdMap.clear();
        _usedIds.clear();
        _nextAvailableId = _startRange;
      }
    }
  }

  static Future<void> _saveMappings() async {
    if (_prefs == null) return;

    try {
      final encoded = jsonEncode(_trackerToIdMap);
      await _prefs!.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Failed to save notification ID mappings: $e');
      rethrow; // Re-throw to propagate errors
    }
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'NotificationIdManager not initialized. Call initialize() first.',
      );
    }
  }
}

/// Exception thrown when notification ID pool is exhausted.
class NotificationIdPoolExhaustedException implements Exception {
  final String message;
  const NotificationIdPoolExhaustedException(this.message);

  @override
  String toString() => 'NotificationIdPoolExhaustedException: $message';
}
