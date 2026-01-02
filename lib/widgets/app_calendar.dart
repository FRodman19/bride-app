import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// CALENDAR DATE PICKER - Custom styled calendar
/// Flat design, no shadow, 16px radius
class AppCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? selectedColor;
  final Color? todayColor;

  const AppCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.selectedColor,
    this.todayColor,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _displayedMonth =
        DateTime(_selectedDate?.year ?? DateTime.now().year, _selectedDate?.month ?? DateTime.now().month);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateSelected?.call(date);
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    final days = <DateTime>[];

    // Add empty slots for days before the first day of month
    final firstWeekday = firstDayOfMonth.weekday;
    for (int i = 1; i < firstWeekday; i++) {
      days.add(DateTime(month.year, month.month, -(firstWeekday - i - 1)));
    }

    // Add all days in the month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final selectedCol = widget.selectedColor ?? AppColors.teal500;
    final todayCol = widget.todayColor ??
        (isDark ? AppColors.neutral600 : AppColors.neutral300);
    final today = DateTime.now();
    final days = _getDaysInMonth(_displayedMonth);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral900 : AppColors.white,
        borderRadius: BorderRadius.circular(16), // 16px radius
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral300,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month/Year header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              Text(
                '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                style: TextStyles.titleMedium(brightness),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyles.labelSmall(brightness).copyWith(
                            color: AppColors.secondaryTextColor(brightness),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, today);
              final isCurrentMonth = date.month == _displayedMonth.month;
              final isDisabled = (widget.firstDate != null &&
                      date.isBefore(widget.firstDate!)) ||
                  (widget.lastDate != null && date.isAfter(widget.lastDate!));

              return GestureDetector(
                onTap: isDisabled || !isCurrentMonth
                    ? null
                    : () => _selectDate(date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedCol
                        : isToday
                            ? todayCol
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyles.bodyMedium(brightness).copyWith(
                        color: isSelected
                            ? AppColors.black
                            : !isCurrentMonth
                                ? AppColors.secondaryTextColor(brightness)
                                    .withValues(alpha: 0.3)
                                : isDisabled
                                    ? AppColors.secondaryTextColor(brightness)
                                        .withValues(alpha: 0.5)
                                    : AppColors.primaryTextColor(brightness),
                        fontWeight:
                            isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

/// DATE PICKER FIELD - Input field with calendar popup
/// Flat design, no shadow, 16px radius
class AppDatePickerField extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDatePickerField({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  Future<void> _showDatePicker() async {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.teal500,
              onPrimary: AppColors.black,
              surface: isDark ? AppColors.neutral900 : AppColors.white,
              onSurface: isDark ? AppColors.white : AppColors.black,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.teal500,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      widget.onDateSelected?.call(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;
    final borderColor =
        isDark ? AppColors.neutral600 : AppColors.neutral400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.labelMedium(brightness),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : (widget.hint ?? 'Select date'),
                  style: TextStyles.bodyMedium(brightness).copyWith(
                    color: _selectedDate != null
                        ? AppColors.primaryTextColor(brightness)
                        : AppColors.secondaryTextColor(brightness),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// DATE RANGE PICKER FIELD - Input field for selecting date ranges
/// Flat design, no shadow, 16px radius
class AppDateRangePickerField extends StatefulWidget {
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDateRangePickerField({
    super.key,
    this.selectedRange,
    this.onRangeSelected,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<AppDateRangePickerField> createState() =>
      _AppDateRangePickerFieldState();
}

class _AppDateRangePickerFieldState extends State<AppDateRangePickerField> {
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.selectedRange;
  }

  Future<void> _showRangePicker() async {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      initialDateRange: _selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.teal500,
              onPrimary: AppColors.black,
              surface: isDark ? AppColors.neutral900 : AppColors.white,
              onSurface: isDark ? AppColors.white : AppColors.black,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.teal500,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedRange) {
      setState(() => _selectedRange = picked);
      widget.onRangeSelected?.call(picked);
    }
  }

  String _formatRange(DateTimeRange range) {
    return '${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral900 : AppColors.white;
    final borderColor =
        isDark ? AppColors.neutral600 : AppColors.neutral400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.labelMedium(brightness),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: _showRangePicker,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedRange != null
                        ? _formatRange(_selectedRange!)
                        : (widget.hint ?? 'Select date range'),
                    style: TextStyles.bodyMedium(brightness).copyWith(
                      color: _selectedRange != null
                          ? AppColors.primaryTextColor(brightness)
                          : AppColors.secondaryTextColor(brightness),
                    ),
                  ),
                ),
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
