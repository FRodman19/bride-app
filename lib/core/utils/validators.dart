import 'currency_formatter.dart';
import 'date_formatter.dart';

/// Validation utilities for form inputs.
///
/// Key rules from IMPLEMENTATION_PLAN.md:
/// - Tracker name: min 3, max 50 characters
/// - Amounts: non-negative, max 100,000,000 FCFA
/// - Dates: no future dates for entries
/// - One entry per day per tracker
class Validators {
  Validators._();

  /// Validate tracker name
  static String? trackerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a tracker name';
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters';
    }

    if (trimmed.length > 50) {
      return 'Name cannot exceed 50 characters';
    }

    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password (Supabase default: min 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate revenue/spend amount
  static String? amount(String? value, {String currencyCode = 'XOF'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }

    final parsed = CurrencyFormatter.parse(value, currencyCode: currencyCode);
    return CurrencyFormatter.validate(parsed, currencyCode: currencyCode);
  }

  /// Validate entry date
  static String? entryDate(DateTime? value) {
    return DateFormatter.validateEntryDate(value);
  }

  /// Validate URL (optional field)
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URLs are optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/([\w\-]+\.)+[\w\-]+(\/[\w\-\.~:\/?#\[\]@!$&\(\)*+,;=%]*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate notes (optional, max length)
  static String? notes(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Notes are optional
    }

    if (value.length > maxLength) {
      return 'Notes cannot exceed $maxLength characters';
    }

    return null;
  }

  /// Validate post title
  static String? postTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }

    if (value.trim().length > 100) {
      return 'Title cannot exceed 100 characters';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate integer input
  static String? integer(String? value, {int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a number';
    }

    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid number';
    }

    if (min != null && parsed < min) {
      return 'Value must be at least $min';
    }

    if (max != null && parsed > max) {
      return 'Value cannot exceed $max';
    }

    return null;
  }
}
