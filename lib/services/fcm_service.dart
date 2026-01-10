import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/supabase_config.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCMService: Background message received: ${message.messageId}');
  // Don't need to show notification here - FCM handles it automatically
  // when app is in background/terminated
}

/// Provider for FCM service
final fcmServiceProvider = Provider<FCMService>((ref) {
  final service = FCMService();

  // Initialize and register token when auth state changes
  ref.listen<AuthState>(authProvider, (previous, next) async {
    if (next is AuthAuthenticated) {
      // User logged in - initialize FCM and register token
      await service.initialize();
      await service.registerToken(next.user.id);
      // Also sync settings to Supabase
      await ref.read(settingsProvider.notifier).syncOnLogin();
    } else if (previous is AuthAuthenticated && next is AuthUnauthenticated) {
      // User logged out - remove token from database
      await service.unregisterToken(previous.user.id);
    }
  });

  // Initial check if already authenticated
  final authState = ref.read(authProvider);
  if (authState is AuthAuthenticated) {
    service.initialize().then((_) async {
      await service.registerToken(authState.user.id);
      // Also sync settings to Supabase
      await ref.read(settingsProvider.notifier).syncOnLogin();
    });
  }

  return service;
});

/// FCM Service for handling push notifications via Firebase Cloud Messaging.
///
/// This service:
/// - Initializes Firebase Messaging
/// - Requests notification permission
/// - Gets and refreshes FCM tokens
/// - Saves tokens to Supabase user_devices table
/// - Handles foreground messages
class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  String? _currentToken;

  /// Callback for handling notification taps (set by app)
  static void Function(RemoteMessage)? onNotificationTap;

  bool get isInitialized => _isInitialized;
  String? get currentToken => _currentToken;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission (iOS and Android 13+)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('FCMService: Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('FCMService: Notification permission denied');
        return;
      }

      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up notification tap handler (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCMService: Token refreshed');
        _currentToken = newToken;
        // Token will be re-registered on next auth state change or manually
      });

      _isInitialized = true;
      debugPrint('FCMService: Initialized successfully');
    } catch (e) {
      debugPrint('FCMService: Failed to initialize: $e');
    }
  }

  /// Get the current FCM token
  Future<String?> getToken() async {
    try {
      _currentToken = await _messaging.getToken();
      debugPrint('FCMService: Got token: ${_currentToken?.substring(0, 20)}...');
      return _currentToken;
    } catch (e) {
      debugPrint('FCMService: Failed to get token: $e');
      return null;
    }
  }

  /// Register FCM token with Supabase for the given user
  Future<void> registerToken(String userId) async {
    try {
      final token = await getToken();
      if (token == null) {
        debugPrint('FCMService: No token to register');
        return;
      }

      final deviceType = Platform.isAndroid ? 'android' : 'ios';

      // Upsert the device token (update if exists, insert if not)
      await SupabaseConfig.client.from('user_devices').upsert(
        {
          'user_id': userId,
          'fcm_token': token,
          'device_type': deviceType,
        },
        onConflict: 'user_id,fcm_token',
      );

      debugPrint('FCMService: Token registered for user $userId');
    } catch (e) {
      debugPrint('FCMService: Failed to register token: $e');
    }
  }

  /// Remove FCM token from Supabase when user logs out
  Future<void> unregisterToken(String userId) async {
    try {
      if (_currentToken == null) return;

      await SupabaseConfig.client
          .from('user_devices')
          .delete()
          .eq('user_id', userId)
          .eq('fcm_token', _currentToken!);

      debugPrint('FCMService: Token unregistered for user $userId');
    } catch (e) {
      debugPrint('FCMService: Failed to unregister token: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCMService: Foreground message: ${message.notification?.title}');

    // For foreground messages, we could show a local notification
    // or an in-app toast. For now, just log it.
    // The notification is NOT automatically shown when app is in foreground.
  }

  /// Handle notification tap (when app was in background)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('FCMService: Notification tapped: ${message.data}');

    if (onNotificationTap != null) {
      onNotificationTap!(message);
    }
  }
}
