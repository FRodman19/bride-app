import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/auth_provider.dart' as app_auth;

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message silently
}

/// Provider for the notification service that auto-initializes with auth.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();

  // Initialize first, then set up auth listener to avoid race condition
  service.initialize().then((_) {
    // Check if user is already logged in
    final currentAuth = ref.read(app_auth.authProvider);
    if (currentAuth is app_auth.AuthAuthenticated) {
      service.onUserLoggedIn();
    }

    // Watch for future auth state changes
    ref.listen<app_auth.AuthState>(app_auth.authProvider, (previous, next) {
      if (next is app_auth.AuthAuthenticated &&
          previous is! app_auth.AuthAuthenticated) {
        // User just logged in - save token
        service.onUserLoggedIn();
      } else if (next is app_auth.AuthUnauthenticated &&
          previous is app_auth.AuthAuthenticated) {
        // User just logged out - remove token
        service.onUserLoggedOut();
      }
    });
  });

  // Clean up on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// Service for handling push notifications.
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Store subscriptions for cleanup
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _backgroundTapSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  /// Check if service is initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the notification service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request permission
      await _requestPermission();

      // Initialize local notifications for foreground
      await _initializeLocalNotifications();

      // Set up foreground message handler (store subscription)
      _foregroundSubscription =
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background (store subscription)
      _backgroundTapSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Listen for token refresh (store subscription)
      _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) {
        _saveTokenToDatabase(token: token);
      });

      _isInitialized = true;
      debugPrint('NotificationService: Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('NotificationService: Failed to initialize: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Clean up resources.
  void dispose() {
    _foregroundSubscription?.cancel();
    _backgroundTapSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    debugPrint('NotificationService: Disposed');
  }

  /// Request notification permissions.
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'NotificationService: Permission status: ${settings.authorizationStatus}');
  }

  /// Initialize local notifications for foreground display.
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
        _handleLocalNotificationTap(response);
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle foreground messages.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    debugPrint(
        'NotificationService: Received foreground message: ${notification.title}');

    // Show local notification when app is in foreground
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['tracker_id'],
    );
  }

  /// Handle notification tap when app is in background/terminated.
  void _handleNotificationTap(RemoteMessage message) {
    // Navigate to relevant screen based on data
    final trackerId = message.data['tracker_id'];
    debugPrint('NotificationService: Notification tapped, trackerId: $trackerId');
    if (trackerId != null) {
      // Navigation will be handled by the app
      // You can use a stream or callback here
    }
  }

  /// Handle local notification tap.
  void _handleLocalNotificationTap(NotificationResponse response) {
    final trackerId = response.payload;
    debugPrint(
        'NotificationService: Local notification tapped, trackerId: $trackerId');
    if (trackerId != null) {
      // Navigate to tracker
    }
  }

  /// Save FCM token to Supabase.
  Future<void> _saveTokenToDatabase({String? token}) async {
    try {
      final fcmToken = token ?? await _messaging.getToken();

      // Validate token before saving
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('NotificationService: Invalid FCM token, skipping save');
        return;
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('NotificationService: No user logged in, skipping token save');
        return;
      }

      // Upsert device token
      await Supabase.instance.client.from('user_devices').upsert(
        {
          'user_id': user.id,
          'fcm_token': fcmToken,
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id,fcm_token',
      );

      debugPrint('NotificationService: FCM token saved for user ${user.id}');
    } catch (e, stackTrace) {
      // Log error for debugging while keeping notifications optional
      debugPrint('NotificationService: Failed to save FCM token: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Remove FCM token from database (call on logout).
  Future<void> removeTokenFromDatabase() async {
    try {
      final fcmToken = await _messaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      await Supabase.instance.client
          .from('user_devices')
          .delete()
          .eq('user_id', user.id)
          .eq('fcm_token', fcmToken);

      debugPrint('NotificationService: FCM token removed for user ${user.id}');
    } catch (e, stackTrace) {
      debugPrint('NotificationService: Failed to remove FCM token: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Get current FCM token.
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to a topic (for broadcast notifications).
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('NotificationService: Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('NotificationService: Unsubscribed from topic: $topic');
  }

  /// Called when user logs in - save FCM token.
  Future<void> onUserLoggedIn() async {
    if (!_isInitialized) {
      debugPrint(
          'NotificationService: Not initialized, skipping token save on login');
      return;
    }
    await _saveTokenToDatabase();
  }

  /// Called when user logs out - remove FCM token.
  Future<void> onUserLoggedOut() async {
    if (!_isInitialized) {
      debugPrint(
          'NotificationService: Not initialized, skipping token removal on logout');
      return;
    }
    await removeTokenFromDatabase();
  }
}
