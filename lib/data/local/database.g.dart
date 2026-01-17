// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TrackersTable extends Trackers with TableInfo<$TrackersTable, Tracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XOF'),
  );
  static const VerificationMeta _revenueTargetMeta = const VerificationMeta(
    'revenueTarget',
  );
  @override
  late final GeneratedColumn<int> revenueTarget = GeneratedColumn<int>(
    'revenue_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engagementTargetMeta = const VerificationMeta(
    'engagementTarget',
  );
  @override
  late final GeneratedColumn<int> engagementTarget = GeneratedColumn<int>(
    'engagement_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setupCostMeta = const VerificationMeta(
    'setupCost',
  );
  @override
  late final GeneratedColumn<int> setupCost = GeneratedColumn<int>(
    'setup_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _growthCostMonthlyMeta = const VerificationMeta(
    'growthCostMonthly',
  );
  @override
  late final GeneratedColumn<int> growthCostMonthly = GeneratedColumn<int>(
    'growth_cost_monthly',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderFrequencyMeta = const VerificationMeta(
    'reminderFrequency',
  );
  @override
  late final GeneratedColumn<String> reminderFrequency =
      GeneratedColumn<String>(
        'reminder_frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('none'),
      );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderDayOfWeekMeta = const VerificationMeta(
    'reminderDayOfWeek',
  );
  @override
  late final GeneratedColumn<int> reminderDayOfWeek = GeneratedColumn<int>(
    'reminder_day_of_week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    startDate,
    currency,
    revenueTarget,
    engagementTarget,
    setupCost,
    growthCostMonthly,
    notes,
    isArchived,
    createdAt,
    updatedAt,
    syncStatus,
    reminderEnabled,
    reminderFrequency,
    reminderTime,
    reminderDayOfWeek,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trackers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tracker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('revenue_target')) {
      context.handle(
        _revenueTargetMeta,
        revenueTarget.isAcceptableOrUnknown(
          data['revenue_target']!,
          _revenueTargetMeta,
        ),
      );
    }
    if (data.containsKey('engagement_target')) {
      context.handle(
        _engagementTargetMeta,
        engagementTarget.isAcceptableOrUnknown(
          data['engagement_target']!,
          _engagementTargetMeta,
        ),
      );
    }
    if (data.containsKey('setup_cost')) {
      context.handle(
        _setupCostMeta,
        setupCost.isAcceptableOrUnknown(data['setup_cost']!, _setupCostMeta),
      );
    }
    if (data.containsKey('growth_cost_monthly')) {
      context.handle(
        _growthCostMonthlyMeta,
        growthCostMonthly.isAcceptableOrUnknown(
          data['growth_cost_monthly']!,
          _growthCostMonthlyMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_frequency')) {
      context.handle(
        _reminderFrequencyMeta,
        reminderFrequency.isAcceptableOrUnknown(
          data['reminder_frequency']!,
          _reminderFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('reminder_day_of_week')) {
      context.handle(
        _reminderDayOfWeekMeta,
        reminderDayOfWeek.isAcceptableOrUnknown(
          data['reminder_day_of_week']!,
          _reminderDayOfWeekMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tracker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      revenueTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revenue_target'],
      ),
      engagementTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engagement_target'],
      ),
      setupCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setup_cost'],
      )!,
      growthCostMonthly: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}growth_cost_monthly'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_frequency'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      ),
      reminderDayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_day_of_week'],
      ),
    );
  }

  @override
  $TrackersTable createAlias(String alias) {
    return $TrackersTable(attachedDatabase, alias);
  }
}

class Tracker extends DataClass implements Insertable<Tracker> {
  /// UUID primary key (works offline, syncs properly)
  final String id;

  /// User ID from Supabase Auth
  final String userId;

  /// Tracker name (min 3, max 50 characters)
  final String name;

  /// Campaign start date
  final DateTime startDate;

  /// Currency code (default: XOF for Franc CFA)
  final String currency;

  /// Revenue target (optional)
  final int? revenueTarget;

  /// Engagement target - DMs/Leads (optional)
  final int? engagementTarget;

  /// Initial setup cost
  final int setupCost;

  /// Monthly growth/maintenance cost
  final int growthCostMonthly;

  /// Optional notes
  final String? notes;

  /// Whether tracker is archived (read-only mode)
  final bool isArchived;

  /// Created timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;

  /// Whether reminder notifications are enabled
  final bool reminderEnabled;

  /// Reminder frequency: 'none', 'daily', 'weekly'
  final String reminderFrequency;

  /// Reminder time in HH:MM format (e.g., "09:00")
  final String? reminderTime;

  /// Day of week for weekly reminders (1=Monday, 7=Sunday)
  final int? reminderDayOfWeek;
  const Tracker({
    required this.id,
    required this.userId,
    required this.name,
    required this.startDate,
    required this.currency,
    this.revenueTarget,
    this.engagementTarget,
    required this.setupCost,
    required this.growthCostMonthly,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.reminderEnabled,
    required this.reminderFrequency,
    this.reminderTime,
    this.reminderDayOfWeek,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || revenueTarget != null) {
      map['revenue_target'] = Variable<int>(revenueTarget);
    }
    if (!nullToAbsent || engagementTarget != null) {
      map['engagement_target'] = Variable<int>(engagementTarget);
    }
    map['setup_cost'] = Variable<int>(setupCost);
    map['growth_cost_monthly'] = Variable<int>(growthCostMonthly);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_frequency'] = Variable<String>(reminderFrequency);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    if (!nullToAbsent || reminderDayOfWeek != null) {
      map['reminder_day_of_week'] = Variable<int>(reminderDayOfWeek);
    }
    return map;
  }

  TrackersCompanion toCompanion(bool nullToAbsent) {
    return TrackersCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      startDate: Value(startDate),
      currency: Value(currency),
      revenueTarget: revenueTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(revenueTarget),
      engagementTarget: engagementTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(engagementTarget),
      setupCost: Value(setupCost),
      growthCostMonthly: Value(growthCostMonthly),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      reminderEnabled: Value(reminderEnabled),
      reminderFrequency: Value(reminderFrequency),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      reminderDayOfWeek: reminderDayOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDayOfWeek),
    );
  }

  factory Tracker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tracker(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      currency: serializer.fromJson<String>(json['currency']),
      revenueTarget: serializer.fromJson<int?>(json['revenueTarget']),
      engagementTarget: serializer.fromJson<int?>(json['engagementTarget']),
      setupCost: serializer.fromJson<int>(json['setupCost']),
      growthCostMonthly: serializer.fromJson<int>(json['growthCostMonthly']),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderFrequency: serializer.fromJson<String>(json['reminderFrequency']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      reminderDayOfWeek: serializer.fromJson<int?>(json['reminderDayOfWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'currency': serializer.toJson<String>(currency),
      'revenueTarget': serializer.toJson<int?>(revenueTarget),
      'engagementTarget': serializer.toJson<int?>(engagementTarget),
      'setupCost': serializer.toJson<int>(setupCost),
      'growthCostMonthly': serializer.toJson<int>(growthCostMonthly),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderFrequency': serializer.toJson<String>(reminderFrequency),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'reminderDayOfWeek': serializer.toJson<int?>(reminderDayOfWeek),
    };
  }

  Tracker copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? startDate,
    String? currency,
    Value<int?> revenueTarget = const Value.absent(),
    Value<int?> engagementTarget = const Value.absent(),
    int? setupCost,
    int? growthCostMonthly,
    Value<String?> notes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    bool? reminderEnabled,
    String? reminderFrequency,
    Value<String?> reminderTime = const Value.absent(),
    Value<int?> reminderDayOfWeek = const Value.absent(),
  }) => Tracker(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    currency: currency ?? this.currency,
    revenueTarget: revenueTarget.present
        ? revenueTarget.value
        : this.revenueTarget,
    engagementTarget: engagementTarget.present
        ? engagementTarget.value
        : this.engagementTarget,
    setupCost: setupCost ?? this.setupCost,
    growthCostMonthly: growthCostMonthly ?? this.growthCostMonthly,
    notes: notes.present ? notes.value : this.notes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderFrequency: reminderFrequency ?? this.reminderFrequency,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    reminderDayOfWeek: reminderDayOfWeek.present
        ? reminderDayOfWeek.value
        : this.reminderDayOfWeek,
  );
  Tracker copyWithCompanion(TrackersCompanion data) {
    return Tracker(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      revenueTarget: data.revenueTarget.present
          ? data.revenueTarget.value
          : this.revenueTarget,
      engagementTarget: data.engagementTarget.present
          ? data.engagementTarget.value
          : this.engagementTarget,
      setupCost: data.setupCost.present ? data.setupCost.value : this.setupCost,
      growthCostMonthly: data.growthCostMonthly.present
          ? data.growthCostMonthly.value
          : this.growthCostMonthly,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderFrequency: data.reminderFrequency.present
          ? data.reminderFrequency.value
          : this.reminderFrequency,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderDayOfWeek: data.reminderDayOfWeek.present
          ? data.reminderDayOfWeek.value
          : this.reminderDayOfWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tracker(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('currency: $currency, ')
          ..write('revenueTarget: $revenueTarget, ')
          ..write('engagementTarget: $engagementTarget, ')
          ..write('setupCost: $setupCost, ')
          ..write('growthCostMonthly: $growthCostMonthly, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderFrequency: $reminderFrequency, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderDayOfWeek: $reminderDayOfWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    startDate,
    currency,
    revenueTarget,
    engagementTarget,
    setupCost,
    growthCostMonthly,
    notes,
    isArchived,
    createdAt,
    updatedAt,
    syncStatus,
    reminderEnabled,
    reminderFrequency,
    reminderTime,
    reminderDayOfWeek,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tracker &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.currency == this.currency &&
          other.revenueTarget == this.revenueTarget &&
          other.engagementTarget == this.engagementTarget &&
          other.setupCost == this.setupCost &&
          other.growthCostMonthly == this.growthCostMonthly &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderFrequency == this.reminderFrequency &&
          other.reminderTime == this.reminderTime &&
          other.reminderDayOfWeek == this.reminderDayOfWeek);
}

class TrackersCompanion extends UpdateCompanion<Tracker> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<String> currency;
  final Value<int?> revenueTarget;
  final Value<int?> engagementTarget;
  final Value<int> setupCost;
  final Value<int> growthCostMonthly;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<bool> reminderEnabled;
  final Value<String> reminderFrequency;
  final Value<String?> reminderTime;
  final Value<int?> reminderDayOfWeek;
  final Value<int> rowid;
  const TrackersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.revenueTarget = const Value.absent(),
    this.engagementTarget = const Value.absent(),
    this.setupCost = const Value.absent(),
    this.growthCostMonthly = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderFrequency = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderDayOfWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackersCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required DateTime startDate,
    this.currency = const Value.absent(),
    this.revenueTarget = const Value.absent(),
    this.engagementTarget = const Value.absent(),
    this.setupCost = const Value.absent(),
    this.growthCostMonthly = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderFrequency = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderDayOfWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       startDate = Value(startDate);
  static Insertable<Tracker> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<String>? currency,
    Expression<int>? revenueTarget,
    Expression<int>? engagementTarget,
    Expression<int>? setupCost,
    Expression<int>? growthCostMonthly,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderFrequency,
    Expression<String>? reminderTime,
    Expression<int>? reminderDayOfWeek,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (currency != null) 'currency': currency,
      if (revenueTarget != null) 'revenue_target': revenueTarget,
      if (engagementTarget != null) 'engagement_target': engagementTarget,
      if (setupCost != null) 'setup_cost': setupCost,
      if (growthCostMonthly != null) 'growth_cost_monthly': growthCostMonthly,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderFrequency != null) 'reminder_frequency': reminderFrequency,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderDayOfWeek != null) 'reminder_day_of_week': reminderDayOfWeek,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackersCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<String>? currency,
    Value<int?>? revenueTarget,
    Value<int?>? engagementTarget,
    Value<int>? setupCost,
    Value<int>? growthCostMonthly,
    Value<String?>? notes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<bool>? reminderEnabled,
    Value<String>? reminderFrequency,
    Value<String?>? reminderTime,
    Value<int?>? reminderDayOfWeek,
    Value<int>? rowid,
  }) {
    return TrackersCompanion(
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
      syncStatus: syncStatus ?? this.syncStatus,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderFrequency: reminderFrequency ?? this.reminderFrequency,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDayOfWeek: reminderDayOfWeek ?? this.reminderDayOfWeek,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (revenueTarget.present) {
      map['revenue_target'] = Variable<int>(revenueTarget.value);
    }
    if (engagementTarget.present) {
      map['engagement_target'] = Variable<int>(engagementTarget.value);
    }
    if (setupCost.present) {
      map['setup_cost'] = Variable<int>(setupCost.value);
    }
    if (growthCostMonthly.present) {
      map['growth_cost_monthly'] = Variable<int>(growthCostMonthly.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderFrequency.present) {
      map['reminder_frequency'] = Variable<String>(reminderFrequency.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (reminderDayOfWeek.present) {
      map['reminder_day_of_week'] = Variable<int>(reminderDayOfWeek.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('currency: $currency, ')
          ..write('revenueTarget: $revenueTarget, ')
          ..write('engagementTarget: $engagementTarget, ')
          ..write('setupCost: $setupCost, ')
          ..write('growthCostMonthly: $growthCostMonthly, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderFrequency: $reminderFrequency, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderDayOfWeek: $reminderDayOfWeek, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyEntriesTable extends DailyEntries
    with TableInfo<$DailyEntriesTable, DailyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRevenueMeta = const VerificationMeta(
    'totalRevenue',
  );
  @override
  late final GeneratedColumn<int> totalRevenue = GeneratedColumn<int>(
    'total_revenue',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDmsLeadsMeta = const VerificationMeta(
    'totalDmsLeads',
  );
  @override
  late final GeneratedColumn<int> totalDmsLeads = GeneratedColumn<int>(
    'total_dms_leads',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackerId,
    entryDate,
    totalRevenue,
    totalDmsLeads,
    notes,
    createdAt,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('total_revenue')) {
      context.handle(
        _totalRevenueMeta,
        totalRevenue.isAcceptableOrUnknown(
          data['total_revenue']!,
          _totalRevenueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRevenueMeta);
    }
    if (data.containsKey('total_dms_leads')) {
      context.handle(
        _totalDmsLeadsMeta,
        totalDmsLeads.isAcceptableOrUnknown(
          data['total_dms_leads']!,
          _totalDmsLeadsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      totalRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_revenue'],
      )!,
      totalDmsLeads: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_dms_leads'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $DailyEntriesTable createAlias(String alias) {
    return $DailyEntriesTable(attachedDatabase, alias);
  }
}

class DailyEntry extends DataClass implements Insertable<DailyEntry> {
  /// UUID primary key
  final String id;

  /// Foreign key to trackers
  final String trackerId;

  /// Entry date (one per day per tracker)
  final DateTime entryDate;

  /// Total revenue for the day (stored as integer for CFA - no decimals)
  final int totalRevenue;

  /// Total DMs/Leads received
  final int totalDmsLeads;

  /// Optional notes for the day
  final String? notes;

  /// Created timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;
  const DailyEntry({
    required this.id,
    required this.trackerId,
    required this.entryDate,
    required this.totalRevenue,
    required this.totalDmsLeads,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['total_revenue'] = Variable<int>(totalRevenue);
    map['total_dms_leads'] = Variable<int>(totalDmsLeads);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  DailyEntriesCompanion toCompanion(bool nullToAbsent) {
    return DailyEntriesCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      entryDate: Value(entryDate),
      totalRevenue: Value(totalRevenue),
      totalDmsLeads: Value(totalDmsLeads),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory DailyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyEntry(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      totalRevenue: serializer.fromJson<int>(json['totalRevenue']),
      totalDmsLeads: serializer.fromJson<int>(json['totalDmsLeads']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'totalRevenue': serializer.toJson<int>(totalRevenue),
      'totalDmsLeads': serializer.toJson<int>(totalDmsLeads),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  DailyEntry copyWith({
    String? id,
    String? trackerId,
    DateTime? entryDate,
    int? totalRevenue,
    int? totalDmsLeads,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) => DailyEntry(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    entryDate: entryDate ?? this.entryDate,
    totalRevenue: totalRevenue ?? this.totalRevenue,
    totalDmsLeads: totalDmsLeads ?? this.totalDmsLeads,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  DailyEntry copyWithCompanion(DailyEntriesCompanion data) {
    return DailyEntry(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      totalRevenue: data.totalRevenue.present
          ? data.totalRevenue.value
          : this.totalRevenue,
      totalDmsLeads: data.totalDmsLeads.present
          ? data.totalDmsLeads.value
          : this.totalDmsLeads,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntry(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('entryDate: $entryDate, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalDmsLeads: $totalDmsLeads, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trackerId,
    entryDate,
    totalRevenue,
    totalDmsLeads,
    notes,
    createdAt,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntry &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.entryDate == this.entryDate &&
          other.totalRevenue == this.totalRevenue &&
          other.totalDmsLeads == this.totalDmsLeads &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class DailyEntriesCompanion extends UpdateCompanion<DailyEntry> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<DateTime> entryDate;
  final Value<int> totalRevenue;
  final Value<int> totalDmsLeads;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const DailyEntriesCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.totalRevenue = const Value.absent(),
    this.totalDmsLeads = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyEntriesCompanion.insert({
    required String id,
    required String trackerId,
    required DateTime entryDate,
    required int totalRevenue,
    this.totalDmsLeads = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       entryDate = Value(entryDate),
       totalRevenue = Value(totalRevenue);
  static Insertable<DailyEntry> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<DateTime>? entryDate,
    Expression<int>? totalRevenue,
    Expression<int>? totalDmsLeads,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (entryDate != null) 'entry_date': entryDate,
      if (totalRevenue != null) 'total_revenue': totalRevenue,
      if (totalDmsLeads != null) 'total_dms_leads': totalDmsLeads,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<DateTime>? entryDate,
    Value<int>? totalRevenue,
    Value<int>? totalDmsLeads,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return DailyEntriesCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      entryDate: entryDate ?? this.entryDate,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalDmsLeads: totalDmsLeads ?? this.totalDmsLeads,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (totalRevenue.present) {
      map['total_revenue'] = Variable<int>(totalRevenue.value);
    }
    if (totalDmsLeads.present) {
      map['total_dms_leads'] = Variable<int>(totalDmsLeads.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('entryDate: $entryDate, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalDmsLeads: $totalDmsLeads, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntryPlatformSpendsTable extends EntryPlatformSpends
    with TableInfo<$EntryPlatformSpendsTable, EntryPlatformSpend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryPlatformSpendsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryId,
    platform,
    amount,
    createdAt,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_platform_spends';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryPlatformSpend> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryPlatformSpend map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryPlatformSpend(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $EntryPlatformSpendsTable createAlias(String alias) {
    return $EntryPlatformSpendsTable(attachedDatabase, alias);
  }
}

class EntryPlatformSpend extends DataClass
    implements Insertable<EntryPlatformSpend> {
  /// UUID primary key
  final String id;

  /// Foreign key to daily_entries
  final String entryId;

  /// Platform identifier (e.g., 'facebook', 'tiktok')
  final String platform;

  /// Amount spent on this platform (stored as integer for CFA)
  final int amount;

  /// Created timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;
  const EntryPlatformSpend({
    required this.id,
    required this.entryId,
    required this.platform,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['platform'] = Variable<String>(platform);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  EntryPlatformSpendsCompanion toCompanion(bool nullToAbsent) {
    return EntryPlatformSpendsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      platform: Value(platform),
      amount: Value(amount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory EntryPlatformSpend.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryPlatformSpend(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      platform: serializer.fromJson<String>(json['platform']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'platform': serializer.toJson<String>(platform),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  EntryPlatformSpend copyWith({
    String? id,
    String? entryId,
    String? platform,
    int? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) => EntryPlatformSpend(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    platform: platform ?? this.platform,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  EntryPlatformSpend copyWithCompanion(EntryPlatformSpendsCompanion data) {
    return EntryPlatformSpend(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      platform: data.platform.present ? data.platform.value : this.platform,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryPlatformSpend(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('platform: $platform, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryId,
    platform,
    amount,
    createdAt,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryPlatformSpend &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.platform == this.platform &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class EntryPlatformSpendsCompanion extends UpdateCompanion<EntryPlatformSpend> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<String> platform;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const EntryPlatformSpendsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.platform = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryPlatformSpendsCompanion.insert({
    required String id,
    required String entryId,
    required String platform,
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       platform = Value(platform);
  static Insertable<EntryPlatformSpend> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<String>? platform,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (platform != null) 'platform': platform,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryPlatformSpendsCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<String>? platform,
    Value<int>? amount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return EntryPlatformSpendsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      platform: platform ?? this.platform,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryPlatformSpendsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('platform: $platform, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackerPlatformsTable extends TrackerPlatforms
    with TableInfo<$TrackerPlatformsTable, TrackerPlatform> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackerPlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackerId,
    platform,
    displayOrder,
    createdAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracker_platforms';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackerPlatform> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackerPlatform map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackerPlatform(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TrackerPlatformsTable createAlias(String alias) {
    return $TrackerPlatformsTable(attachedDatabase, alias);
  }
}

class TrackerPlatform extends DataClass implements Insertable<TrackerPlatform> {
  /// UUID primary key
  final String id;

  /// Foreign key to trackers
  final String trackerId;

  /// Platform identifier (e.g., 'facebook', 'tiktok')
  final String platform;

  /// Display order for UI
  final int displayOrder;

  /// Created timestamp
  final DateTime createdAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;
  const TrackerPlatform({
    required this.id,
    required this.trackerId,
    required this.platform,
    required this.displayOrder,
    required this.createdAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['platform'] = Variable<String>(platform);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TrackerPlatformsCompanion toCompanion(bool nullToAbsent) {
    return TrackerPlatformsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      platform: Value(platform),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory TrackerPlatform.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackerPlatform(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      platform: serializer.fromJson<String>(json['platform']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'platform': serializer.toJson<String>(platform),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TrackerPlatform copyWith({
    String? id,
    String? trackerId,
    String? platform,
    int? displayOrder,
    DateTime? createdAt,
    String? syncStatus,
  }) => TrackerPlatform(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    platform: platform ?? this.platform,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  TrackerPlatform copyWithCompanion(TrackerPlatformsCompanion data) {
    return TrackerPlatform(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      platform: data.platform.present ? data.platform.value : this.platform,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackerPlatform(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('platform: $platform, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackerId, platform, displayOrder, createdAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerPlatform &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.platform == this.platform &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus);
}

class TrackerPlatformsCompanion extends UpdateCompanion<TrackerPlatform> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String> platform;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TrackerPlatformsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.platform = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackerPlatformsCompanion.insert({
    required String id,
    required String trackerId,
    required String platform,
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       platform = Value(platform);
  static Insertable<TrackerPlatform> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? platform,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (platform != null) 'platform': platform,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackerPlatformsCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<String>? platform,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return TrackerPlatformsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      platform: platform ?? this.platform,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackerPlatformsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('platform: $platform, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostsTable extends Posts with TableInfo<$PostsTable, Post> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedDateMeta = const VerificationMeta(
    'publishedDate',
  );
  @override
  late final GeneratedColumn<DateTime> publishedDate =
      GeneratedColumn<DateTime>(
        'published_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackerId,
    title,
    platform,
    url,
    publishedDate,
    notes,
    createdAt,
    updatedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Post> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('published_date')) {
      context.handle(
        _publishedDateMeta,
        publishedDate.isAcceptableOrUnknown(
          data['published_date']!,
          _publishedDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Post map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Post(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      publishedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }
}

class Post extends DataClass implements Insertable<Post> {
  /// UUID primary key
  final String id;

  /// Foreign key to trackers
  final String trackerId;

  /// Post title
  final String title;

  /// Platform where post was published
  final String platform;

  /// Optional URL to the post
  final String? url;

  /// Date post was published
  final DateTime? publishedDate;

  /// Optional notes
  final String? notes;

  /// Created timestamp
  final DateTime createdAt;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;
  const Post({
    required this.id,
    required this.trackerId,
    required this.title,
    required this.platform,
    this.url,
    this.publishedDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['title'] = Variable<String>(title);
    map['platform'] = Variable<String>(platform);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || publishedDate != null) {
      map['published_date'] = Variable<DateTime>(publishedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      title: Value(title),
      platform: Value(platform),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      publishedDate: publishedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Post.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Post(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      title: serializer.fromJson<String>(json['title']),
      platform: serializer.fromJson<String>(json['platform']),
      url: serializer.fromJson<String?>(json['url']),
      publishedDate: serializer.fromJson<DateTime?>(json['publishedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'title': serializer.toJson<String>(title),
      'platform': serializer.toJson<String>(platform),
      'url': serializer.toJson<String?>(url),
      'publishedDate': serializer.toJson<DateTime?>(publishedDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Post copyWith({
    String? id,
    String? trackerId,
    String? title,
    String? platform,
    Value<String?> url = const Value.absent(),
    Value<DateTime?> publishedDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) => Post(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    title: title ?? this.title,
    platform: platform ?? this.platform,
    url: url.present ? url.value : this.url,
    publishedDate: publishedDate.present
        ? publishedDate.value
        : this.publishedDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Post copyWithCompanion(PostsCompanion data) {
    return Post(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      title: data.title.present ? data.title.value : this.title,
      platform: data.platform.present ? data.platform.value : this.platform,
      url: data.url.present ? data.url.value : this.url,
      publishedDate: data.publishedDate.present
          ? data.publishedDate.value
          : this.publishedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Post(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('title: $title, ')
          ..write('platform: $platform, ')
          ..write('url: $url, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trackerId,
    title,
    platform,
    url,
    publishedDate,
    notes,
    createdAt,
    updatedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.title == this.title &&
          other.platform == this.platform &&
          other.url == this.url &&
          other.publishedDate == this.publishedDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class PostsCompanion extends UpdateCompanion<Post> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String> title;
  final Value<String> platform;
  final Value<String?> url;
  final Value<DateTime?> publishedDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.title = const Value.absent(),
    this.platform = const Value.absent(),
    this.url = const Value.absent(),
    this.publishedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostsCompanion.insert({
    required String id,
    required String trackerId,
    required String title,
    required String platform,
    this.url = const Value.absent(),
    this.publishedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       title = Value(title),
       platform = Value(platform);
  static Insertable<Post> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? title,
    Expression<String>? platform,
    Expression<String>? url,
    Expression<DateTime>? publishedDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (title != null) 'title': title,
      if (platform != null) 'platform': platform,
      if (url != null) 'url': url,
      if (publishedDate != null) 'published_date': publishedDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostsCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<String>? title,
    Value<String>? platform,
    Value<String?>? url,
    Value<DateTime?>? publishedDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return PostsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      publishedDate: publishedDate ?? this.publishedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (publishedDate.present) {
      map['published_date'] = Variable<DateTime>(publishedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('title: $title, ')
          ..write('platform: $platform, ')
          ..write('url: $url, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackerGoalsTable extends TrackerGoals
    with TableInfo<$TrackerGoalsTable, TrackerGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackerGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackerId,
    goalType,
    createdAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracker_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackerGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackerGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackerGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TrackerGoalsTable createAlias(String alias) {
    return $TrackerGoalsTable(attachedDatabase, alias);
  }
}

class TrackerGoal extends DataClass implements Insertable<TrackerGoal> {
  /// UUID primary key
  final String id;

  /// Foreign key to trackers
  final String trackerId;

  /// Goal type identifier (e.g., 'product_launch', 'lead_generation')
  final String goalType;

  /// Created timestamp
  final DateTime createdAt;

  /// Sync status: 'synced', 'pending', 'error'
  final String syncStatus;
  const TrackerGoal({
    required this.id,
    required this.trackerId,
    required this.goalType,
    required this.createdAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['goal_type'] = Variable<String>(goalType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TrackerGoalsCompanion toCompanion(bool nullToAbsent) {
    return TrackerGoalsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      goalType: Value(goalType),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory TrackerGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackerGoal(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      goalType: serializer.fromJson<String>(json['goalType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'goalType': serializer.toJson<String>(goalType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TrackerGoal copyWith({
    String? id,
    String? trackerId,
    String? goalType,
    DateTime? createdAt,
    String? syncStatus,
  }) => TrackerGoal(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    goalType: goalType ?? this.goalType,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  TrackerGoal copyWithCompanion(TrackerGoalsCompanion data) {
    return TrackerGoal(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackerGoal(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackerId, goalType, createdAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerGoal &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.goalType == this.goalType &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus);
}

class TrackerGoalsCompanion extends UpdateCompanion<TrackerGoal> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String> goalType;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TrackerGoalsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.goalType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackerGoalsCompanion.insert({
    required String id,
    required String trackerId,
    required String goalType,
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       goalType = Value(goalType);
  static Insertable<TrackerGoal> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? goalType,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (goalType != null) 'goal_type': goalType,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackerGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<String>? goalType,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return TrackerGoalsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackerGoalsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('goalType: $goalType, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrackersTable trackers = $TrackersTable(this);
  late final $DailyEntriesTable dailyEntries = $DailyEntriesTable(this);
  late final $EntryPlatformSpendsTable entryPlatformSpends =
      $EntryPlatformSpendsTable(this);
  late final $TrackerPlatformsTable trackerPlatforms = $TrackerPlatformsTable(
    this,
  );
  late final $PostsTable posts = $PostsTable(this);
  late final $TrackerGoalsTable trackerGoals = $TrackerGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trackers,
    dailyEntries,
    entryPlatformSpends,
    trackerPlatforms,
    posts,
    trackerGoals,
  ];
}

typedef $$TrackersTableCreateCompanionBuilder =
    TrackersCompanion Function({
      required String id,
      required String userId,
      required String name,
      required DateTime startDate,
      Value<String> currency,
      Value<int?> revenueTarget,
      Value<int?> engagementTarget,
      Value<int> setupCost,
      Value<int> growthCostMonthly,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<bool> reminderEnabled,
      Value<String> reminderFrequency,
      Value<String?> reminderTime,
      Value<int?> reminderDayOfWeek,
      Value<int> rowid,
    });
typedef $$TrackersTableUpdateCompanionBuilder =
    TrackersCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<DateTime> startDate,
      Value<String> currency,
      Value<int?> revenueTarget,
      Value<int?> engagementTarget,
      Value<int> setupCost,
      Value<int> growthCostMonthly,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<bool> reminderEnabled,
      Value<String> reminderFrequency,
      Value<String?> reminderTime,
      Value<int?> reminderDayOfWeek,
      Value<int> rowid,
    });

class $$TrackersTableFilterComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revenueTarget => $composableBuilder(
    column: $table.revenueTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engagementTarget => $composableBuilder(
    column: $table.engagementTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setupCost => $composableBuilder(
    column: $table.setupCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get growthCostMonthly => $composableBuilder(
    column: $table.growthCostMonthly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderFrequency => $composableBuilder(
    column: $table.reminderFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDayOfWeek => $composableBuilder(
    column: $table.reminderDayOfWeek,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revenueTarget => $composableBuilder(
    column: $table.revenueTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engagementTarget => $composableBuilder(
    column: $table.engagementTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setupCost => $composableBuilder(
    column: $table.setupCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get growthCostMonthly => $composableBuilder(
    column: $table.growthCostMonthly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderFrequency => $composableBuilder(
    column: $table.reminderFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDayOfWeek => $composableBuilder(
    column: $table.reminderDayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get revenueTarget => $composableBuilder(
    column: $table.revenueTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get engagementTarget => $composableBuilder(
    column: $table.engagementTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setupCost =>
      $composableBuilder(column: $table.setupCost, builder: (column) => column);

  GeneratedColumn<int> get growthCostMonthly => $composableBuilder(
    column: $table.growthCostMonthly,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderFrequency => $composableBuilder(
    column: $table.reminderFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderDayOfWeek => $composableBuilder(
    column: $table.reminderDayOfWeek,
    builder: (column) => column,
  );
}

class $$TrackersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackersTable,
          Tracker,
          $$TrackersTableFilterComposer,
          $$TrackersTableOrderingComposer,
          $$TrackersTableAnnotationComposer,
          $$TrackersTableCreateCompanionBuilder,
          $$TrackersTableUpdateCompanionBuilder,
          (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
          Tracker,
          PrefetchHooks Function()
        > {
  $$TrackersTableTableManager(_$AppDatabase db, $TrackersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> revenueTarget = const Value.absent(),
                Value<int?> engagementTarget = const Value.absent(),
                Value<int> setupCost = const Value.absent(),
                Value<int> growthCostMonthly = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String> reminderFrequency = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<int?> reminderDayOfWeek = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion(
                id: id,
                userId: userId,
                name: name,
                startDate: startDate,
                currency: currency,
                revenueTarget: revenueTarget,
                engagementTarget: engagementTarget,
                setupCost: setupCost,
                growthCostMonthly: growthCostMonthly,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                reminderEnabled: reminderEnabled,
                reminderFrequency: reminderFrequency,
                reminderTime: reminderTime,
                reminderDayOfWeek: reminderDayOfWeek,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required DateTime startDate,
                Value<String> currency = const Value.absent(),
                Value<int?> revenueTarget = const Value.absent(),
                Value<int?> engagementTarget = const Value.absent(),
                Value<int> setupCost = const Value.absent(),
                Value<int> growthCostMonthly = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String> reminderFrequency = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<int?> reminderDayOfWeek = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                startDate: startDate,
                currency: currency,
                revenueTarget: revenueTarget,
                engagementTarget: engagementTarget,
                setupCost: setupCost,
                growthCostMonthly: growthCostMonthly,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                reminderEnabled: reminderEnabled,
                reminderFrequency: reminderFrequency,
                reminderTime: reminderTime,
                reminderDayOfWeek: reminderDayOfWeek,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackersTable,
      Tracker,
      $$TrackersTableFilterComposer,
      $$TrackersTableOrderingComposer,
      $$TrackersTableAnnotationComposer,
      $$TrackersTableCreateCompanionBuilder,
      $$TrackersTableUpdateCompanionBuilder,
      (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
      Tracker,
      PrefetchHooks Function()
    >;
typedef $$DailyEntriesTableCreateCompanionBuilder =
    DailyEntriesCompanion Function({
      required String id,
      required String trackerId,
      required DateTime entryDate,
      required int totalRevenue,
      Value<int> totalDmsLeads,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$DailyEntriesTableUpdateCompanionBuilder =
    DailyEntriesCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<DateTime> entryDate,
      Value<int> totalRevenue,
      Value<int> totalDmsLeads,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$DailyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDmsLeads => $composableBuilder(
    column: $table.totalDmsLeads,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDmsLeads => $composableBuilder(
    column: $table.totalDmsLeads,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<int> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDmsLeads => $composableBuilder(
    column: $table.totalDmsLeads,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$DailyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyEntriesTable,
          DailyEntry,
          $$DailyEntriesTableFilterComposer,
          $$DailyEntriesTableOrderingComposer,
          $$DailyEntriesTableAnnotationComposer,
          $$DailyEntriesTableCreateCompanionBuilder,
          $$DailyEntriesTableUpdateCompanionBuilder,
          (
            DailyEntry,
            BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntry>,
          ),
          DailyEntry,
          PrefetchHooks Function()
        > {
  $$DailyEntriesTableTableManager(_$AppDatabase db, $DailyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<int> totalRevenue = const Value.absent(),
                Value<int> totalDmsLeads = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion(
                id: id,
                trackerId: trackerId,
                entryDate: entryDate,
                totalRevenue: totalRevenue,
                totalDmsLeads: totalDmsLeads,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required DateTime entryDate,
                required int totalRevenue,
                Value<int> totalDmsLeads = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion.insert(
                id: id,
                trackerId: trackerId,
                entryDate: entryDate,
                totalRevenue: totalRevenue,
                totalDmsLeads: totalDmsLeads,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyEntriesTable,
      DailyEntry,
      $$DailyEntriesTableFilterComposer,
      $$DailyEntriesTableOrderingComposer,
      $$DailyEntriesTableAnnotationComposer,
      $$DailyEntriesTableCreateCompanionBuilder,
      $$DailyEntriesTableUpdateCompanionBuilder,
      (
        DailyEntry,
        BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntry>,
      ),
      DailyEntry,
      PrefetchHooks Function()
    >;
typedef $$EntryPlatformSpendsTableCreateCompanionBuilder =
    EntryPlatformSpendsCompanion Function({
      required String id,
      required String entryId,
      required String platform,
      Value<int> amount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$EntryPlatformSpendsTableUpdateCompanionBuilder =
    EntryPlatformSpendsCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<String> platform,
      Value<int> amount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$EntryPlatformSpendsTableFilterComposer
    extends Composer<_$AppDatabase, $EntryPlatformSpendsTable> {
  $$EntryPlatformSpendsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntryPlatformSpendsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntryPlatformSpendsTable> {
  $$EntryPlatformSpendsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntryPlatformSpendsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntryPlatformSpendsTable> {
  $$EntryPlatformSpendsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$EntryPlatformSpendsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntryPlatformSpendsTable,
          EntryPlatformSpend,
          $$EntryPlatformSpendsTableFilterComposer,
          $$EntryPlatformSpendsTableOrderingComposer,
          $$EntryPlatformSpendsTableAnnotationComposer,
          $$EntryPlatformSpendsTableCreateCompanionBuilder,
          $$EntryPlatformSpendsTableUpdateCompanionBuilder,
          (
            EntryPlatformSpend,
            BaseReferences<
              _$AppDatabase,
              $EntryPlatformSpendsTable,
              EntryPlatformSpend
            >,
          ),
          EntryPlatformSpend,
          PrefetchHooks Function()
        > {
  $$EntryPlatformSpendsTableTableManager(
    _$AppDatabase db,
    $EntryPlatformSpendsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryPlatformSpendsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryPlatformSpendsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EntryPlatformSpendsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryPlatformSpendsCompanion(
                id: id,
                entryId: entryId,
                platform: platform,
                amount: amount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entryId,
                required String platform,
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryPlatformSpendsCompanion.insert(
                id: id,
                entryId: entryId,
                platform: platform,
                amount: amount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntryPlatformSpendsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntryPlatformSpendsTable,
      EntryPlatformSpend,
      $$EntryPlatformSpendsTableFilterComposer,
      $$EntryPlatformSpendsTableOrderingComposer,
      $$EntryPlatformSpendsTableAnnotationComposer,
      $$EntryPlatformSpendsTableCreateCompanionBuilder,
      $$EntryPlatformSpendsTableUpdateCompanionBuilder,
      (
        EntryPlatformSpend,
        BaseReferences<
          _$AppDatabase,
          $EntryPlatformSpendsTable,
          EntryPlatformSpend
        >,
      ),
      EntryPlatformSpend,
      PrefetchHooks Function()
    >;
typedef $$TrackerPlatformsTableCreateCompanionBuilder =
    TrackerPlatformsCompanion Function({
      required String id,
      required String trackerId,
      required String platform,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$TrackerPlatformsTableUpdateCompanionBuilder =
    TrackerPlatformsCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<String> platform,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$TrackerPlatformsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackerPlatformsTable> {
  $$TrackerPlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackerPlatformsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackerPlatformsTable> {
  $$TrackerPlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackerPlatformsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackerPlatformsTable> {
  $$TrackerPlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TrackerPlatformsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackerPlatformsTable,
          TrackerPlatform,
          $$TrackerPlatformsTableFilterComposer,
          $$TrackerPlatformsTableOrderingComposer,
          $$TrackerPlatformsTableAnnotationComposer,
          $$TrackerPlatformsTableCreateCompanionBuilder,
          $$TrackerPlatformsTableUpdateCompanionBuilder,
          (
            TrackerPlatform,
            BaseReferences<
              _$AppDatabase,
              $TrackerPlatformsTable,
              TrackerPlatform
            >,
          ),
          TrackerPlatform,
          PrefetchHooks Function()
        > {
  $$TrackerPlatformsTableTableManager(
    _$AppDatabase db,
    $TrackerPlatformsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackerPlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackerPlatformsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackerPlatformsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerPlatformsCompanion(
                id: id,
                trackerId: trackerId,
                platform: platform,
                displayOrder: displayOrder,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required String platform,
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerPlatformsCompanion.insert(
                id: id,
                trackerId: trackerId,
                platform: platform,
                displayOrder: displayOrder,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackerPlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackerPlatformsTable,
      TrackerPlatform,
      $$TrackerPlatformsTableFilterComposer,
      $$TrackerPlatformsTableOrderingComposer,
      $$TrackerPlatformsTableAnnotationComposer,
      $$TrackerPlatformsTableCreateCompanionBuilder,
      $$TrackerPlatformsTableUpdateCompanionBuilder,
      (
        TrackerPlatform,
        BaseReferences<_$AppDatabase, $TrackerPlatformsTable, TrackerPlatform>,
      ),
      TrackerPlatform,
      PrefetchHooks Function()
    >;
typedef $$PostsTableCreateCompanionBuilder =
    PostsCompanion Function({
      required String id,
      required String trackerId,
      required String title,
      required String platform,
      Value<String?> url,
      Value<DateTime?> publishedDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$PostsTableUpdateCompanionBuilder =
    PostsCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<String> title,
      Value<String> platform,
      Value<String?> url,
      Value<DateTime?> publishedDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$PostsTableFilterComposer extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PostsTableOrderingComposer
    extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$PostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostsTable,
          Post,
          $$PostsTableFilterComposer,
          $$PostsTableOrderingComposer,
          $$PostsTableAnnotationComposer,
          $$PostsTableCreateCompanionBuilder,
          $$PostsTableUpdateCompanionBuilder,
          (Post, BaseReferences<_$AppDatabase, $PostsTable, Post>),
          Post,
          PrefetchHooks Function()
        > {
  $$PostsTableTableManager(_$AppDatabase db, $PostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<DateTime?> publishedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion(
                id: id,
                trackerId: trackerId,
                title: title,
                platform: platform,
                url: url,
                publishedDate: publishedDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required String title,
                required String platform,
                Value<String?> url = const Value.absent(),
                Value<DateTime?> publishedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion.insert(
                id: id,
                trackerId: trackerId,
                title: title,
                platform: platform,
                url: url,
                publishedDate: publishedDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostsTable,
      Post,
      $$PostsTableFilterComposer,
      $$PostsTableOrderingComposer,
      $$PostsTableAnnotationComposer,
      $$PostsTableCreateCompanionBuilder,
      $$PostsTableUpdateCompanionBuilder,
      (Post, BaseReferences<_$AppDatabase, $PostsTable, Post>),
      Post,
      PrefetchHooks Function()
    >;
typedef $$TrackerGoalsTableCreateCompanionBuilder =
    TrackerGoalsCompanion Function({
      required String id,
      required String trackerId,
      required String goalType,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$TrackerGoalsTableUpdateCompanionBuilder =
    TrackerGoalsCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<String> goalType,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$TrackerGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackerGoalsTable> {
  $$TrackerGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackerGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackerGoalsTable> {
  $$TrackerGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackerGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackerGoalsTable> {
  $$TrackerGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TrackerGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackerGoalsTable,
          TrackerGoal,
          $$TrackerGoalsTableFilterComposer,
          $$TrackerGoalsTableOrderingComposer,
          $$TrackerGoalsTableAnnotationComposer,
          $$TrackerGoalsTableCreateCompanionBuilder,
          $$TrackerGoalsTableUpdateCompanionBuilder,
          (
            TrackerGoal,
            BaseReferences<_$AppDatabase, $TrackerGoalsTable, TrackerGoal>,
          ),
          TrackerGoal,
          PrefetchHooks Function()
        > {
  $$TrackerGoalsTableTableManager(_$AppDatabase db, $TrackerGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackerGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackerGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackerGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerGoalsCompanion(
                id: id,
                trackerId: trackerId,
                goalType: goalType,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required String goalType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerGoalsCompanion.insert(
                id: id,
                trackerId: trackerId,
                goalType: goalType,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackerGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackerGoalsTable,
      TrackerGoal,
      $$TrackerGoalsTableFilterComposer,
      $$TrackerGoalsTableOrderingComposer,
      $$TrackerGoalsTableAnnotationComposer,
      $$TrackerGoalsTableCreateCompanionBuilder,
      $$TrackerGoalsTableUpdateCompanionBuilder,
      (
        TrackerGoal,
        BaseReferences<_$AppDatabase, $TrackerGoalsTable, TrackerGoal>,
      ),
      TrackerGoal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrackersTableTableManager get trackers =>
      $$TrackersTableTableManager(_db, _db.trackers);
  $$DailyEntriesTableTableManager get dailyEntries =>
      $$DailyEntriesTableTableManager(_db, _db.dailyEntries);
  $$EntryPlatformSpendsTableTableManager get entryPlatformSpends =>
      $$EntryPlatformSpendsTableTableManager(_db, _db.entryPlatformSpends);
  $$TrackerPlatformsTableTableManager get trackerPlatforms =>
      $$TrackerPlatformsTableTableManager(_db, _db.trackerPlatforms);
  $$PostsTableTableManager get posts =>
      $$PostsTableTableManager(_db, _db.posts);
  $$TrackerGoalsTableTableManager get trackerGoals =>
      $$TrackerGoalsTableTableManager(_db, _db.trackerGoals);
}
