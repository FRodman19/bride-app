import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables.
///
/// Uses flutter_dotenv to load values from .env file.
/// NEVER hardcode sensitive values - always use environment variables.
class AppConfig {
  AppConfig._();

  static bool _initialized = false;

  /// Initialize the configuration by loading .env file.
  /// Must be called before accessing any config values.
  static Future<void> init() async {
    if (_initialized) return;
    await dotenv.load(fileName: '.env');
    _initialized = true;
  }

  /// Supabase project URL
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env file');
    }
    return url;
  }

  /// Supabase anonymous/public key
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env file');
    }
    return key;
  }

  /// OpenRouter API key (for AI features - Phase 8)
  static String get openRouterApiKey {
    return dotenv.env['OPENROUTER_API_KEY'] ?? '';
  }

  /// Check if OpenRouter is configured
  static bool get hasOpenRouterConfig {
    final key = dotenv.env['OPENROUTER_API_KEY'];
    return key != null && key.isNotEmpty && !key.startsWith('your-');
  }

  /// Check if Supabase is configured (not using placeholder values)
  static bool get hasSupabaseConfig {
    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    return url != null &&
           key != null &&
           !url.contains('your-project') &&
           !key.startsWith('your-');
  }
}
