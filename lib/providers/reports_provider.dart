import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'entry_provider.dart';
import '../domain/models/tracker.dart';

/// Time period for reports filtering.
enum ReportPeriod {
  daily,
  weekly,
  monthly,
}

/// Weekly breakdown of revenue and spend.
class WeeklyBreakdown {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int revenue;
  final int spend;
  final int profit;

  const WeeklyBreakdown({
    required this.weekStart,
    required this.weekEnd,
    required this.revenue,
    required this.spend,
    required this.profit,
  });

  String get weekLabel {
    final format = DateFormat('MMM d');
    return '${format.format(weekStart)}-${format.format(weekEnd)}';
  }
}

/// Day performance data for worst/best days.
class DayPerformance {
  final DateTime date;
  final int revenue;
  final int spend;
  final int profit;

  const DayPerformance({
    required this.date,
    required this.revenue,
    required this.spend,
    required this.profit,
  });

  bool get isProfitable => profit >= 0;
}

/// Cumulative profit data point.
class CumulativeProfitPoint {
  final DateTime date;
  final int cumulativeProfit;

  const CumulativeProfitPoint({
    required this.date,
    required this.cumulativeProfit,
  });
}

/// Complete reports data for a tracker.
class ReportsData {
  final ReportPeriod period;
  final DateTime periodStart;
  final DateTime periodEnd;

  // Total Profit/Loss
  final int totalRevenue;
  final int totalSpend;
  final int setupCost;
  final int netProfit;

  // Weekly breakdown
  final List<WeeklyBreakdown> weeklyBreakdown;

  // Worst performing days
  final List<DayPerformance> worstDays;

  // Best performing days
  final List<DayPerformance> bestDays;

  // Burn rate
  final int avgDailySpend;
  final int avgWeeklySpend;
  final int avgMonthlySpend;
  final int projectedYearlySpend;
  final double roi; // Percentage

  // Cumulative profit trend
  final List<CumulativeProfitPoint> cumulativeProfitTrend;
  final DateTime? breakEvenDate;
  final int? breakEvenDays;

  // Entry count
  final int entryCount;

  const ReportsData({
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.totalRevenue,
    required this.totalSpend,
    required this.setupCost,
    required this.netProfit,
    required this.weeklyBreakdown,
    required this.worstDays,
    required this.bestDays,
    required this.avgDailySpend,
    required this.avgWeeklySpend,
    required this.avgMonthlySpend,
    required this.projectedYearlySpend,
    required this.roi,
    required this.cumulativeProfitTrend,
    this.breakEvenDate,
    this.breakEvenDays,
    required this.entryCount,
  });

  bool get isProfitable => netProfit >= 0;
  bool get hasData => entryCount > 0;

  /// Empty report when no data
  factory ReportsData.empty(ReportPeriod period) {
    final now = DateTime.now();
    return ReportsData(
      period: period,
      periodStart: now,
      periodEnd: now,
      totalRevenue: 0,
      totalSpend: 0,
      setupCost: 0,
      netProfit: 0,
      weeklyBreakdown: const [],
      worstDays: const [],
      bestDays: const [],
      avgDailySpend: 0,
      avgWeeklySpend: 0,
      avgMonthlySpend: 0,
      projectedYearlySpend: 0,
      roi: 0,
      cumulativeProfitTrend: const [],
      breakEvenDate: null,
      breakEvenDays: null,
      entryCount: 0,
    );
  }
}

/// Provider for reports data for a specific tracker and period.
final reportsProvider = Provider.family<ReportsData, ({String trackerId, Tracker tracker, ReportPeriod period})>((ref, params) {
  final entriesState = ref.watch(entriesProvider(params.trackerId));

  if (entriesState is! EntriesLoaded) {
    return ReportsData.empty(params.period);
  }

  final allEntries = entriesState.entries;
  if (allEntries.isEmpty) {
    return ReportsData.empty(params.period);
  }

  // Get period range
  final now = DateTime.now();
  final (periodStart, periodEnd) = _getPeriodRange(params.period, now);

  // Filter entries for the period
  final entries = allEntries.where((e) {
    final entryDate = DateTime(e.entryDate.year, e.entryDate.month, e.entryDate.day);
    return !entryDate.isBefore(periodStart) && !entryDate.isAfter(periodEnd);
  }).toList();

  if (entries.isEmpty) {
    return ReportsData.empty(params.period);
  }

  // Sort entries by date
  entries.sort((a, b) => a.entryDate.compareTo(b.entryDate));

  // Calculate totals
  final totalRevenue = entries.fold<int>(0, (sum, e) => sum + e.totalRevenue);
  final totalSpend = entries.fold<int>(0, (sum, e) => sum + e.totalSpend);
  final setupCost = params.tracker.setupCost.round();
  final netProfit = totalRevenue - totalSpend - setupCost;

  // Weekly breakdown
  final weeklyBreakdown = _calculateWeeklyBreakdown(entries, periodStart, periodEnd);

  // Get day performances
  final dayPerformances = entries.map((e) => DayPerformance(
    date: e.entryDate,
    revenue: e.totalRevenue,
    spend: e.totalSpend,
    profit: e.profit,
  )).toList();

  // Sort by profit ascending (worst first)
  final worstDays = List<DayPerformance>.from(dayPerformances)
    ..sort((a, b) => a.profit.compareTo(b.profit));

  // Sort by profit descending (best first)
  final bestDays = List<DayPerformance>.from(dayPerformances)
    ..sort((a, b) => b.profit.compareTo(a.profit));

  // Burn rate calculations
  final totalDays = entries.length;
  final avgDailySpend = totalDays > 0 ? (totalSpend / totalDays).round() : 0;
  final avgWeeklySpend = avgDailySpend * 7;
  final avgMonthlySpend = (avgDailySpend * 30.44).round(); // Average days in month
  final projectedYearlySpend = avgDailySpend * 365;

  // ROI calculation: ((revenue - spend) / spend) * 100
  // Handle division by zero
  final roi = totalSpend > 0 ? ((totalRevenue - totalSpend) / totalSpend) * 100 : 0.0;

  // Cumulative profit trend
  final (cumulativeProfitTrend, breakEvenDate, breakEvenDays) =
      _calculateCumulativeProfitTrend(entries, setupCost, params.tracker.startDate);

  return ReportsData(
    period: params.period,
    periodStart: periodStart,
    periodEnd: periodEnd,
    totalRevenue: totalRevenue,
    totalSpend: totalSpend,
    setupCost: setupCost,
    netProfit: netProfit,
    weeklyBreakdown: weeklyBreakdown,
    worstDays: worstDays.take(3).toList(),
    bestDays: bestDays.take(3).toList(),
    avgDailySpend: avgDailySpend,
    avgWeeklySpend: avgWeeklySpend,
    avgMonthlySpend: avgMonthlySpend,
    projectedYearlySpend: projectedYearlySpend,
    roi: roi,
    cumulativeProfitTrend: cumulativeProfitTrend,
    breakEvenDate: breakEvenDate,
    breakEvenDays: breakEvenDays,
    entryCount: entries.length,
  );
});

/// Get the date range for a period.
(DateTime, DateTime) _getPeriodRange(ReportPeriod period, DateTime now) {
  switch (period) {
    case ReportPeriod.daily:
      // Today only
      final today = DateTime(now.year, now.month, now.day);
      return (today, today);

    case ReportPeriod.weekly:
      // Monday to Sunday of current week
      final weekday = now.weekday;
      final monday = DateTime(now.year, now.month, now.day - (weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      return (monday, sunday);

    case ReportPeriod.monthly:
      // First to last day of current month
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);
      return (firstDay, lastDay);
  }
}

/// Calculate weekly breakdown for entries in the period.
List<WeeklyBreakdown> _calculateWeeklyBreakdown(
  List<Entry> entries,
  DateTime periodStart,
  DateTime periodEnd,
) {
  if (entries.isEmpty) return [];

  final weeklyData = <String, ({int revenue, int spend, DateTime start, DateTime end})>{};

  for (final entry in entries) {
    // Get the Monday of the week for this entry
    final weekday = entry.entryDate.weekday;
    final monday = DateTime(
      entry.entryDate.year,
      entry.entryDate.month,
      entry.entryDate.day - (weekday - 1),
    );
    final sunday = monday.add(const Duration(days: 6));

    final weekKey = DateFormat('yyyy-MM-dd').format(monday);

    final existing = weeklyData[weekKey];
    if (existing != null) {
      weeklyData[weekKey] = (
        revenue: existing.revenue + entry.totalRevenue,
        spend: existing.spend + entry.totalSpend,
        start: monday,
        end: sunday,
      );
    } else {
      weeklyData[weekKey] = (
        revenue: entry.totalRevenue,
        spend: entry.totalSpend,
        start: monday,
        end: sunday,
      );
    }
  }

  // Convert to list and sort by date
  final weeks = weeklyData.entries.map((e) => WeeklyBreakdown(
    weekStart: e.value.start,
    weekEnd: e.value.end,
    revenue: e.value.revenue,
    spend: e.value.spend,
    profit: e.value.revenue - e.value.spend,
  )).toList();

  weeks.sort((a, b) => a.weekStart.compareTo(b.weekStart));

  return weeks;
}

/// Calculate cumulative profit trend and break-even point.
(List<CumulativeProfitPoint>, DateTime?, int?) _calculateCumulativeProfitTrend(
  List<Entry> entries,
  int setupCost,
  DateTime trackerStartDate,
) {
  if (entries.isEmpty) return ([], null, null);

  final trend = <CumulativeProfitPoint>[];
  int cumulativeProfit = -setupCost; // Start with setup cost as negative
  DateTime? breakEvenDate;
  int? breakEvenDays;

  // Add initial point with setup cost
  trend.add(CumulativeProfitPoint(
    date: trackerStartDate,
    cumulativeProfit: -setupCost,
  ));

  // Sort entries by date
  final sortedEntries = List<Entry>.from(entries)
    ..sort((a, b) => a.entryDate.compareTo(b.entryDate));

  for (final entry in sortedEntries) {
    final previousCumulative = cumulativeProfit;
    cumulativeProfit += entry.profit;

    trend.add(CumulativeProfitPoint(
      date: entry.entryDate,
      cumulativeProfit: cumulativeProfit,
    ));

    // Check for break-even point
    if (breakEvenDate == null && previousCumulative < 0 && cumulativeProfit >= 0) {
      breakEvenDate = entry.entryDate;
      breakEvenDays = entry.entryDate.difference(trackerStartDate).inDays;
    }
  }

  return (trend, breakEvenDate, breakEvenDays);
}

/// Provider for selected report period.
final selectedReportPeriodProvider = StateProvider<ReportPeriod>((ref) {
  return ReportPeriod.monthly;
});
