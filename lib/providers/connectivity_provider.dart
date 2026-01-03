import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state for the app.
enum ConnectivityState {
  /// Connected to the internet
  online,

  /// No internet connection
  offline,

  /// Checking connectivity status
  checking,
}

/// Provider for monitoring network connectivity.
///
/// Usage:
/// ```dart
/// final isOnline = ref.watch(connectivityProvider) == ConnectivityState.online;
/// ```
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityState>(
  (ref) => ConnectivityNotifier(),
);

/// Simple boolean provider for checking if online.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider) == ConnectivityState.online;
});

/// Notifier for connectivity state changes.
class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  ConnectivityNotifier() : super(ConnectivityState.checking) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void _init() {
    // Check initial connectivity
    _checkConnectivity();

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateState(results);
  }

  void _updateState(List<ConnectivityResult> results) {
    // If any connection type is available (not none), we're online
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    state = hasConnection ? ConnectivityState.online : ConnectivityState.offline;
  }

  /// Force a connectivity check
  Future<void> refresh() async {
    state = ConnectivityState.checking;
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider for getting the connectivity stream.
///
/// Useful for reacting to connectivity changes.
final connectivityStreamProvider = StreamProvider<ConnectivityState>((ref) {
  final connectivity = Connectivity();

  return connectivity.onConnectivityChanged.map((results) {
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    return hasConnection ? ConnectivityState.online : ConnectivityState.offline;
  });
});
