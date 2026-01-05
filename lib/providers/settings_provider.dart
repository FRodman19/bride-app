import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings state
class AppSettings {
  final String language;
  final String currencyCode;
  final ThemeMode themeMode;

  const AppSettings({
    this.language = 'English',
    this.currencyCode = 'XOF',
    this.themeMode = ThemeMode.system,
  });

  /// Get the current locale based on language setting
  Locale get locale => Locale(AppLanguages.getLocaleCode(language));

  AppSettings copyWith({
    String? language,
    String? currencyCode,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currencyCode: currencyCode ?? this.currencyCode,
      themeMode: themeMode ?? this.themeMode,
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

    state = AppSettings(
      language: language,
      currencyCode: currencyCode,
      themeMode: themeMode,
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
