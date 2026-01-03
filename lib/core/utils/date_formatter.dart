import 'package:intl/intl.dart';

/// Formats dates according to the app's standards.
///
/// Key rules from IMPLEMENTATION_PLAN.md:
/// - Format: DD/MM/YYYY (West African standard)
/// - Timezone: WAT (West Africa Time, UTC+1)
/// - "This Week": Monday to Sunday (calendar week)
/// - No future dates allowed for entries
class DateFormatter {
  DateFormatter._();

  /// Standard date format: DD/MM/YYYY
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  /// Short date format: DD/MM
  static final DateFormat _shortFormat = DateFormat('dd/MM');

  /// Month and year: MMMM yyyy
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'fr');

  /// Day name: EEEE
  static final DateFormat _dayNameFormat = DateFormat('EEEE', 'fr');

  /// Format date as DD/MM/YYYY
  static String format(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date as DD/MM
  static String formatShort(DateTime date) {
    return _shortFormat.format(date);
  }

  /// Format as month and year (e.g., "Janvier 2024")
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Format as day name (e.g., "Lundi")
  static String formatDayName(DateTime date) {
    return _dayNameFormat.format(date);
  }

  /// Get relative date description (e.g., "Today", "Yesterday", "Monday")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Hier';
    } else if (difference < 7) {
      return formatDayName(date);
    } else {
      return format(date);
    }
  }

  /// Parse date from DD/MM/YYYY string
  static DateTime? parse(String input) {
    try {
      return _dateFormat.parse(input);
    } catch (_) {
      return null;
    }
  }

  /// Get start of current week (Monday)
  static DateTime getWeekStart([DateTime? date]) {
    final d = date ?? DateTime.now();
    final weekday = d.weekday; // 1 = Monday, 7 = Sunday
    return DateTime(d.year, d.month, d.day - (weekday - 1));
  }

  /// Get end of current week (Sunday)
  static DateTime getWeekEnd([DateTime? date]) {
    final start = getWeekStart(date);
    return start.add(const Duration(days: 6));
  }

  /// Get start of current month
  static DateTime getMonthStart([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month, 1);
  }

  /// Get end of current month
  static DateTime getMonthEnd([DateTime? date]) {
    final d = date ?? DateTime.now();
    return DateTime(d.year, d.month + 1, 0); // Day 0 of next month = last day of current
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is in the future (not allowed for entries)
  static bool isFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.isAfter(today);
  }

  /// Check if date is within current week
  static bool isThisWeek(DateTime date) {
    final start = getWeekStart();
    final end = getWeekEnd();
    final dateOnly = DateTime(date.year, date.month, date.day);
    return !dateOnly.isBefore(start) && !dateOnly.isAfter(end);
  }

  /// Check if date is within current month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Validate date for entry (must be today or past)
  static String? validateEntryDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }

    if (isFuture(date)) {
      return 'Future dates are not allowed';
    }

    return null;
  }

  /// Get date range label for filter pills
  static String getDateRangeLabel(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return format(start);
    }

    if (start.year == end.year) {
      return '${formatShort(start)} - ${formatShort(end)}';
    }

    return '${format(start)} - ${format(end)}';
  }

  /// Normalize date to start of day (midnight)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Normalize date to end of day (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
