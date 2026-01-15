import 'package:uuid/uuid.dart';

/// A performance tracker for tracking campaign ROI.
class Tracker {
  final String id;
  final String userId;
  final String name;
  final DateTime startDate;
  final String currency;
  final double? revenueTarget;
  final int? engagementTarget;
  final double setupCost;
  final double growthCostMonthly;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> platforms;
  final List<String> goalTypes;

  // Notification settings
  final bool reminderEnabled;
  final String reminderFrequency; // 'none', 'daily', 'weekly'
  final String? reminderTime; // "HH:MM" format
  final int? reminderDayOfWeek; // 1-7 (Monday-Sunday)

  // Calculated fields (populated from entries)
  final double totalRevenue;
  final double totalSpend;
  final double totalProfit;
  final int entryCount;

  const Tracker({
    required this.id,
    required this.userId,
    required this.name,
    required this.startDate,
    this.currency = 'XOF',
    this.revenueTarget,
    this.engagementTarget,
    this.setupCost = 0,
    this.growthCostMonthly = 0,
    this.notes,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.platforms = const [],
    this.goalTypes = const [],
    this.reminderEnabled = false,
    this.reminderFrequency = 'none',
    this.reminderTime,
    this.reminderDayOfWeek,
    this.totalRevenue = 0,
    this.totalSpend = 0,
    this.totalProfit = 0,
    this.entryCount = 0,
  });

  /// Create a new tracker with generated ID.
  factory Tracker.create({
    required String userId,
    required String name,
    required DateTime startDate,
    String currency = 'XOF',
    double? revenueTarget,
    int? engagementTarget,
    double setupCost = 0,
    double growthCostMonthly = 0,
    String? notes,
    List<String> platforms = const [],
    List<String> goalTypes = const [],
    bool reminderEnabled = false,
    String reminderFrequency = 'none',
    String? reminderTime,
    int? reminderDayOfWeek,
  }) {
    final now = DateTime.now();
    return Tracker(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      startDate: startDate,
      currency: currency,
      revenueTarget: revenueTarget,
      engagementTarget: engagementTarget,
      setupCost: setupCost,
      growthCostMonthly: growthCostMonthly,
      notes: notes,
      platforms: platforms,
      goalTypes: goalTypes,
      reminderEnabled: reminderEnabled,
      reminderFrequency: reminderFrequency,
      reminderTime: reminderTime,
      reminderDayOfWeek: reminderDayOfWeek,
      createdAt: now,
      updatedAt: now,
    );
  }

  Tracker copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? startDate,
    String? currency,
    double? revenueTarget,
    int? engagementTarget,
    double? setupCost,
    double? growthCostMonthly,
    String? notes,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? platforms,
    List<String>? goalTypes,
    bool? reminderEnabled,
    String? reminderFrequency,
    String? reminderTime,
    int? reminderDayOfWeek,
    double? totalRevenue,
    double? totalSpend,
    double? totalProfit,
    int? entryCount,
  }) {
    return Tracker(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      currency: currency ?? this.currency,
      revenueTarget: revenueTarget ?? this.revenueTarget,
      engagementTarget: engagementTarget ?? this.engagementTarget,
      setupCost: setupCost ?? this.setupCost,
      growthCostMonthly: growthCostMonthly ?? this.growthCostMonthly,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      platforms: platforms ?? this.platforms,
      goalTypes: goalTypes ?? this.goalTypes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDayOfWeek: reminderDayOfWeek ?? this.reminderDayOfWeek,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalSpend: totalSpend ?? this.totalSpend,
      totalProfit: totalProfit ?? this.totalProfit,
      entryCount: entryCount ?? this.entryCount,
    );
  }

  /// Convert to map for database storage.
  /// Note: Supabase uses integer for money fields (no decimals for CFA).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'start_date': startDate.toIso8601String().split('T')[0],
      'currency': currency,
      'revenue_target': revenueTarget?.round(),
      'engagement_target': engagementTarget,
      'setup_cost': setupCost.round(),
      'growth_cost_monthly': growthCostMonthly.round(),
      'notes': notes,
      'is_archived': isArchived,
      'reminder_enabled': reminderEnabled,
      'reminder_frequency': reminderFrequency,
      'reminder_time': reminderTime,
      'reminder_day_of_week': reminderDayOfWeek,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from database map.
  factory Tracker.fromMap(Map<String, dynamic> map, {
    List<String> platforms = const [],
    List<String> goalTypes = const [],
    double totalRevenue = 0,
    double totalSpend = 0,
    int entryCount = 0,
  }) {
    return Tracker(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      currency: map['currency'] as String? ?? 'XOF',
      revenueTarget: (map['revenue_target'] as num?)?.toDouble(),
      engagementTarget: map['engagement_target'] as int?,
      setupCost: (map['setup_cost'] as num?)?.toDouble() ?? 0,
      growthCostMonthly: (map['growth_cost_monthly'] as num?)?.toDouble() ?? 0,
      notes: map['notes'] as String?,
      isArchived: map['is_archived'] as bool? ?? false,
      reminderEnabled: map['reminder_enabled'] as bool? ?? false,
      reminderFrequency: map['reminder_frequency'] as String? ?? 'none',
      reminderTime: map['reminder_time'] as String?,
      reminderDayOfWeek: map['reminder_day_of_week'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      platforms: platforms,
      goalTypes: goalTypes,
      totalRevenue: totalRevenue,
      totalSpend: totalSpend,
      totalProfit: totalRevenue - totalSpend,
      entryCount: entryCount,
    );
  }

  @override
  String toString() => 'Tracker(id: $id, name: $name, profit: $totalProfit)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tracker && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
