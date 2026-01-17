import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/config/supabase_config.dart';
import '../core/config/app_config.dart';

/// Auth state for the app.
sealed class AuthState {
  const AuthState();
}

/// Initial loading state - checking if user is logged in
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Result of an auth operation.
class AuthResult {
  final bool success;
  final String? error;
  final bool requiresEmailConfirmation;
  final bool isNewUser;

  const AuthResult({
    required this.success,
    this.error,
    this.requiresEmailConfirmation = false,
    this.isNewUser = false,
  });

  factory AuthResult.success({bool isNewUser = false}) => AuthResult(
    success: true,
    isNewUser: isNewUser,
  );

  factory AuthResult.error(String message) => AuthResult(
    success: false,
    error: message,
  );

  factory AuthResult.emailConfirmationRequired() => const AuthResult(
    success: false,
    requiresEmailConfirmation: true,
    error: 'Please check your email to confirm your account',
  );
}

/// Provider for authentication state.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// Simple provider to get current user (nullable).
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return switch (authState) {
    AuthAuthenticated(:final user) => user,
    _ => null,
  };
});

/// Provider to check if user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

/// Notifier for auth state changes.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthLoading()) {
    _init();
  }

  StreamSubscription<AuthState>? _subscription;

  void _init() {
    // Check current session
    final session = SupabaseConfig.currentSession;
    if (session != null) {
      state = AuthAuthenticated(session.user);
    } else {
      state = const AuthUnauthenticated();
    }

    // Listen for auth changes
    _subscription = SupabaseConfig.authStateChanges.map((authState) {
      final session = authState.session;
      if (session != null) {
        return AuthAuthenticated(session.user);
      } else {
        return const AuthUnauthenticated();
      }
    }).listen((newState) {
      state = newState;
    });
  }

  /// Sign up with email and password.
  /// Returns AuthResult indicating success/failure.
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.auth.signUp(
        email: email,
        password: password,
      );

      // Check if we have a valid session (user is immediately authenticated)
      if (response.session != null && response.user != null) {
        state = AuthAuthenticated(response.user!);
        return AuthResult.success();
      }

      // User created but email confirmation required
      if (response.user != null && response.session == null) {
        // Don't change state - user needs to confirm email first
        return AuthResult.emailConfirmationRequired();
      }

      return AuthResult.error('Sign up failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Sign in with email and password.
  /// Returns AuthResult indicating success/failure.
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Must have both session and user for successful login
      if (response.session != null && response.user != null) {
        state = AuthAuthenticated(response.user!);
        return AuthResult.success();
      }

      return AuthResult.error('Sign in failed. Please try again.');
    } on AuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Sign in with Google OAuth using native Android flow.
  /// Shows native Google account picker with app branding.
  /// Automatically creates account if user doesn't exist (silent registration).
  /// Always prompts user to select account (allows switching accounts).
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Check if Google OAuth is configured
      if (!AppConfig.hasGoogleOAuthConfig) {
        return AuthResult.error(
          'Google Sign-In is not configured. Please add client IDs to .env file.',
        );
      }

      // Initialize Google Sign-In with web client ID
      final googleSignIn = GoogleSignIn(
        serverClientId: AppConfig.googleClientIdWeb,
        scopes: ['email', 'profile'],
      );

      // Sign out first to force account picker to show every time
      // This allows users to switch between different Google accounts
      await googleSignIn.signOut();

      // Trigger native Google account picker
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return AuthResult.error('Google sign-in was cancelled');
      }

      // Get authentication tokens
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return AuthResult.error('Failed to get Google ID token');
      }

      // Check if this is a new user by checking Supabase
      final existingSession = SupabaseConfig.currentSession;
      final wasSignedIn = existingSession != null;

      // Sign in to Supabase with Google tokens
      final response = await SupabaseConfig.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        // Check if user was just created (new user)
        // Parse createdAt string to DateTime
        final createdAt = DateTime.parse(response.user!.createdAt);
        final isNewUser = !wasSignedIn &&
                         createdAt.isAfter(
                           DateTime.now().subtract(const Duration(seconds: 10)),
                         );

        // Success - auth state will update automatically
        return AuthResult.success(isNewUser: isNewUser);
      }

      return AuthResult.error('Failed to sign in with Google');
    } on AuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.error('Failed to sign in with Google: $e');
    }
  }

  /// Sign out the current user.
  Future<AuthResult> signOut() async {
    try {
      await SupabaseConfig.auth.signOut();
      state = const AuthUnauthenticated();
      return AuthResult.success();
    } catch (e) {
      return AuthResult.error('Failed to sign out: $e');
    }
  }

  /// Send password reset email.
  Future<AuthResult> resetPassword(String email) async {
    try {
      await SupabaseConfig.auth.resetPasswordForEmail(email);
      return AuthResult.success();
    } on AuthException catch (e) {
      return AuthResult.error(_mapAuthError(e.message));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred: $e');
    }
  }

  /// Map Supabase auth errors to user-friendly messages.
  String _mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (message.contains('User already registered')) {
      return 'An account with this email already exists';
    }
    if (message.contains('Email not confirmed')) {
      return 'Please confirm your email address';
    }
    if (message.contains('Password should be at least')) {
      return 'Password must be at least 6 characters';
    }
    if (message.contains('Unable to validate email')) {
      return 'Please enter a valid email address';
    }
    return message;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
