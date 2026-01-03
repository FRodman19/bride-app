import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_config.dart';

/// Supabase initialization and configuration.
///
/// Handles:
/// - Supabase client initialization
/// - Auth session management (built-in token refresh)
/// - Quick access to auth and database clients
class SupabaseConfig {
  SupabaseConfig._();

  static bool _initialized = false;

  /// Initialize Supabase with credentials from AppConfig.
  /// Must be called after AppConfig.init() and before using any Supabase features.
  static Future<void> init() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        // Session will auto-refresh when needed
        authFlowType: AuthFlowType.pkce,
      ),
    );

    _initialized = true;
  }

  /// Get the Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Get the auth client for authentication operations.
  static GoTrueClient get auth => client.auth;

  /// Get the current user, or null if not logged in.
  static User? get currentUser => auth.currentUser;

  /// Get the current session, or null if not logged in.
  static Session? get currentSession => auth.currentSession;

  /// Check if user is currently logged in.
  static bool get isLoggedIn => currentUser != null;

  /// Stream of auth state changes.
  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;
}
