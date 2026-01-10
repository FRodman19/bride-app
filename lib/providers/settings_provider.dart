import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/supabase_config.dart';

/// App settings state
class AppSettings {
  final String language;
  final String currencyCode;
  final ThemeMode themeMode;

  // Notification settings
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool weeklySummaryEnabled;

  const AppSettings({
    this.language = 'English',
    this.currencyCode = 'XOF',
    this.themeMode = ThemeMode.system,
    this.dailyReminderEnabled = true,
    this.dailyReminderHour = 20, // 8 PM default
    this.dailyReminderMinute = 0,
    this.weeklySummaryEnabled = true,
  });

  /// Get the current locale based on language setting
  Locale get locale => Locale(AppLanguages.getLocaleCode(language));

  /// Get the daily reminder time as TimeOfDay
  TimeOfDay get dailyReminderTime =>
      TimeOfDay(hour: dailyReminderHour, minute: dailyReminderMinute);

  AppSettings copyWith({
    String? language,
    String? currencyCode,
    ThemeMode? themeMode,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? weeklySummaryEnabled,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currencyCode: currencyCode ?? this.currencyCode,
      themeMode: themeMode ?? this.themeMode,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
    );
  }
}

/// Provider for app settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

/// Notifier for managing app settings
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  static const String _languageKey = 'app_language';
  static const String _currencyKey = 'app_currency';
  static const String _themeKey = 'app_theme';
  static const String _dailyReminderKey = 'daily_reminder_enabled';
  static const String _dailyReminderHourKey = 'daily_reminder_hour';
  static const String _dailyReminderMinuteKey = 'daily_reminder_minute';
  static const String _weeklySummaryKey = 'weekly_summary_enabled';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final language = prefs.getString(_languageKey) ?? 'English';
    final currencyCode = prefs.getString(_currencyKey) ?? 'XOF';
    final themeString = prefs.getString(_themeKey) ?? 'system';

    final themeMode = switch (themeString) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    // Load notification settings with validation (default 8 PM)
    final dailyReminderEnabled = prefs.getBool(_dailyReminderKey) ?? true;
    final dailyReminderHour = (prefs.getInt(_dailyReminderHourKey) ?? 20).clamp(0, 23);
    final dailyReminderMinute = (prefs.getInt(_dailyReminderMinuteKey) ?? 0).clamp(0, 59);
    final weeklySummaryEnabled = prefs.getBool(_weeklySummaryKey) ?? true;

    state = AppSettings(
      language: language,
      currencyCode: currencyCode,
      themeMode: themeMode,
      dailyReminderEnabled: dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute,
      weeklySummaryEnabled: weeklySummaryEnabled,
    );
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    state = state.copyWith(language: language);
  }

  Future<void> setCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
    state = state.copyWith(currencyCode: currencyCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeKey, themeString);
    state = state.copyWith(themeMode: mode);
  }

  /// Set daily reminder enabled/disabled.
  Future<void> setDailyReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyReminderKey, enabled);
    state = state.copyWith(dailyReminderEnabled: enabled);
    await _syncToSupabase();
  }

  /// Set daily reminder time.
  Future<void> setDailyReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyReminderHourKey, time.hour);
    await prefs.setInt(_dailyReminderMinuteKey, time.minute);
    state = state.copyWith(
      dailyReminderHour: time.hour,
      dailyReminderMinute: time.minute,
    );
    await _syncToSupabase();
  }

  /// Set weekly summary enabled/disabled.
  Future<void> setWeeklySummaryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_weeklySummaryKey, enabled);
    state = state.copyWith(weeklySummaryEnabled: enabled);
    await _syncToSupabase();
  }

  /// Sync notification settings to Supabase user_preferences table.
  /// This enables the server-side cron job to send FCM notifications.
  Future<void> _syncToSupabase() async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      debugPrint('SettingsNotifier: Not syncing - user not logged in');
      return;
    }

    try {
      // Get device timezone
      String timezone;
      try {
        timezone = await FlutterTimezone.getLocalTimezone();
      } catch (e) {
        timezone = 'UTC';
      }

      // Format reminder time as HH:MM:SS for Supabase time column
      final reminderTime =
          '${state.dailyReminderHour.toString().padLeft(2, '0')}:${state.dailyReminderMinute.toString().padLeft(2, '0')}:00';

      await SupabaseConfig.client.from('user_preferences').upsert(
        {
          'user_id': user.id,
          'reminder_enabled': state.dailyReminderEnabled,
          'reminder_time': reminderTime,
          'timezone': timezone,
        },
        onConflict: 'user_id',
      );

      debugPrint('SettingsNotifier: Synced to Supabase (reminder=$reminderTime, tz=$timezone)');
    } catch (e) {
      debugPrint('SettingsNotifier: Failed to sync to Supabase: $e');
    }
  }

  /// Sync settings to Supabase when user logs in.
  /// Call this after successful authentication.
  Future<void> syncOnLogin() async {
    await _syncToSupabase();
  }
}

/// Available languages
class AppLanguages {
  static const List<String> all = ['English', 'French'];

  static String getLocaleCode(String language) {
    return switch (language) {
      'French' => 'fr',
      _ => 'en',
    };
  }

  static String getFromLocaleCode(String code) {
    return switch (code) {
      'fr' => 'French',
      _ => 'English',
    };
  }
}
