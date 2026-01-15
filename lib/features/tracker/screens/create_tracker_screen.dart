import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_inputs.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../grow_out_loud/components/gol_chips.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../grow_out_loud/components/gol_select_field.dart';
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../providers/tracker_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/currency_constants.dart';
import '../../../core/constants/platform_constants.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Screen 2: Create Project
///
/// Manual project creation form.
class CreateTrackerScreen extends ConsumerStatefulWidget {
  const CreateTrackerScreen({super.key});

  @override
  ConsumerState<CreateTrackerScreen> createState() => _CreateTrackerScreenState();
}

class _CreateTrackerScreenState extends ConsumerState<CreateTrackerScreen> {
  final _nameController = TextEditingController();
  final _revenueTargetController = TextEditingController();
  final _engagementTargetController = TextEditingController();
  final _setupCostController = TextEditingController();
  final _growthCostController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  String _currency = 'XAF'; // Default to Franc CFA (BEAC)
  final Set<String> _selectedPlatforms = {"Facebook", "TikTok"};
  final Set<String> _selectedGoals = {};

  // Reminder notification settings
  bool _reminderEnabled = false;
  String _reminderFrequency = 'daily';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  int _reminderDayOfWeek = 1; // Monday

  String? _nameError;
  bool _isLoading = false;

  /// Get available platforms from PlatformConstants (single source of truth)
  List<String> get _availablePlatforms =>
      PlatformConstants.platforms.map((p) => p.name).toList();

  /// Get the current currency info
  CurrencyInfo get _currencyInfo => CurrencyConstants.getCurrency(_currency);

  List<String> _goalOptions(AppLocalizations l10n) => [
        l10n.goalProductLaunch,
        l10n.goalLeadGeneration,
        l10n.goalBrandAwareness,
        l10n.goalSales,
        l10n.goalEngagement,
      ];

  @override
  void dispose() {
    _nameController.dispose();
    _revenueTargetController.dispose();
    _engagementTargetController.dispose();
    _setupCostController.dispose();
    _growthCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  Future<void> _handleCreate() async {
    // Validate
    setState(() {
      _nameError = Validators.trackerName(_nameController.text);
    });

    if (_nameError != null) return;
    if (_selectedPlatforms.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      showGOLToast(context, l10n.pleaseSelectPlatform);
      return;
    }

    setState(() => _isLoading = true);

    // Parse optional numeric values
    final revenueTarget = double.tryParse(_revenueTargetController.text);
    final engagementTarget = int.tryParse(_engagementTargetController.text);
    final setupCost = double.tryParse(_setupCostController.text) ?? 0;
    final growthCost = double.tryParse(_growthCostController.text) ?? 0;

    final result = await ref.read(trackersProvider.notifier).createTracker(
          name: _nameController.text.trim(),
          startDate: _startDate,
          currency: _currency,
          revenueTarget: revenueTarget,
          engagementTarget: engagementTarget,
          setupCost: setupCost,
          growthCostMonthly: growthCost,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          platforms: _selectedPlatforms.toList(),
          goalTypes: _selectedGoals.toList(),
          reminderEnabled: _reminderEnabled,
          reminderFrequency: _reminderFrequency,
          reminderTime: _reminderEnabled
              ? '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'
              : null,
          reminderDayOfWeek: _reminderFrequency == 'weekly' ? _reminderDayOfWeek : null,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      if (result.success) {
        final l10n = AppLocalizations.of(context)!;
        showGOLToast(
          context,
          l10n.projectCreatedSuccess,
          variant: GOLToastVariant.success,
        );
        context.pop();
      } else if (result.error != null) {
        showGOLToast(
          context,
          result.error!,
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final canCreate = ref.watch(canCreateTrackerProvider);
    final l10n = AppLocalizations.of(context)!;
    final availableGoals = _goalOptions(l10n);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.newProject,
          style: textTheme.headlineSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !canCreate
          ? _LimitReachedState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  GOLTextField(
                    label: l10n.projectName,
                    hintText: l10n.projectNameHint,
                    controller: _nameController,
                    errorText: _nameError,
                    maxLength: 50,
                    prefixIcon: Icon(Iconsax.edit_2, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Start date
                  _buildLabel(l10n.startDate),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  GOLCard(
                    variant: GOLCardVariant.interactive,
                    onTap: _selectDate,
                    padding: const EdgeInsets.symmetric(
                      horizontal: GOLSpacing.inputPaddingHorizontal,
                      vertical: GOLSpacing.inputPaddingVertical,
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.calendar_1, color: colors.textTertiary),
                        const SizedBox(width: GOLSpacing.space3),
                        Text(
                          DateFormat('dd/MM/yyyy', l10n.localeName).format(_startDate),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(Iconsax.arrow_down_1, size: 16, color: colors.textTertiary),
                      ],
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Currency dropdown
                  _buildLabel(l10n.currency),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  _CurrencyDropdown(
                    value: _currency,
                    onChanged: (value) => setState(() => _currency = value),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Platforms
                  _buildLabel(l10n.platforms),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  GOLSelectableChipGroup(
                    items: _availablePlatforms,
                    selectedItems: _selectedPlatforms,
                    onChanged: (selected) => setState(() {
                      _selectedPlatforms.clear();
                      _selectedPlatforms.addAll(selected);
                    }),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Revenue target (optional) - with currency suffix
                  GOLTextField(
                    label: l10n.revenueTargetOptional,
                    hintText: 'e.g., 500000',
                    controller: _revenueTargetController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.money, color: colors.textTertiary),
                    trailingSuffix: GOLBadge(text: _currencyInfo.code),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Engagement target (optional)
                  GOLTextField(
                    label: l10n.engagementTargetOptional,
                    hintText: l10n.engagementTargetHint,
                    controller: _engagementTargetController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.message, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Setup cost - with currency suffix
                  GOLTextField(
                    label: l10n.setupCost,
                    hintText: '0',
                    controller: _setupCostController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.wallet_minus, color: colors.textTertiary),
                    trailingSuffix: GOLBadge(text: _currencyInfo.code),
                    helperText: l10n.setupCostHelper,
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Monthly growth cost - with currency suffix
                  GOLTextField(
                    label: l10n.monthlyGrowthCost,
                    hintText: '0',
                    controller: _growthCostController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.chart_1, color: colors.textTertiary),
                    trailingSuffix: GOLBadge(text: _currencyInfo.code),
                    helperText: l10n.monthlyGrowthCostHelper,
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Goals (optional)
                  _buildLabel(l10n.goalsOptional),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  GOLSelectableChipGroup(
                    items: availableGoals,
                    selectedItems: _selectedGoals,
                    onChanged: (selected) => setState(() {
                      _selectedGoals.clear();
                      _selectedGoals.addAll(selected);
                    }),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Notes (optional)
                  GOLTextField(
                    label: l10n.notesOptional,
                    hintText: l10n.addNotesOptional,
                    controller: _notesController,
                    maxLength: 500,
                  ),

                  const SizedBox(height: GOLSpacing.betweenSections),

                  // Reminder Notifications Section
                  GOLDivider(),
                  const SizedBox(height: GOLSpacing.space6),

                  _buildLabel(l10n.reminderNotifications),
                  Text(
                    l10n.reminderNotificationsHelper,
                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: GOLSpacing.space4),

                  // Enable/disable switch
                  Semantics(
                    label: l10n.enableReminders,
                    child: GOLCard(
                      variant: GOLCardVariant.elevated,
                      child: Padding(
                        padding: const EdgeInsets.all(GOLSpacing.space4),
                        child: Row(
                          children: [
                            Icon(Iconsax.notification, color: colors.interactivePrimary),
                            const SizedBox(width: GOLSpacing.space3),
                            Expanded(
                              child: Text(
                                l10n.enableReminders,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Switch(
                              value: _reminderEnabled,
                              onChanged: (value) => setState(() => _reminderEnabled = value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (_reminderEnabled) ...[
                    const SizedBox(height: GOLSpacing.space4),

                    // Frequency selector
                    _buildLabel(l10n.frequency),
                    const SizedBox(height: GOLSpacing.inputLabelGap),
                    GOLSelectableChipGroup(
                      items: [l10n.daily, l10n.weekly],
                      selectedItems: {_reminderFrequency == 'daily' ? l10n.daily : l10n.weekly},
                      onChanged: (selected) {
                        setState(() {
                          _reminderFrequency = selected.first == l10n.daily ? 'daily' : 'weekly';
                          // Reset day of week when switching to daily
                          if (_reminderFrequency == 'daily') {
                            _reminderDayOfWeek = 1;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: GOLSpacing.space4),

                    // Time picker
                    _buildLabel(l10n.reminderTime),
                    const SizedBox(height: GOLSpacing.inputLabelGap),
                    Semantics(
                      label: l10n.selectReminderTime,
                      button: true,
                      child: GOLCard(
                        variant: GOLCardVariant.interactive,
                        onTap: _selectTime,
                        padding: const EdgeInsets.symmetric(
                          horizontal: GOLSpacing.inputPaddingHorizontal,
                          vertical: GOLSpacing.inputPaddingVertical,
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.clock, color: colors.textTertiary),
                            const SizedBox(width: GOLSpacing.space3),
                            Expanded(
                              child: Text(
                                _reminderTime.format(context),
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Icon(Iconsax.arrow_right_3, size: 16, color: colors.textTertiary),
                          ],
                        ),
                      ),
                    ),

                    // Day picker (if weekly)
                    if (_reminderFrequency == 'weekly') ...[
                      const SizedBox(height: GOLSpacing.space4),
                      _buildLabel(l10n.selectDayOfWeek),
                      const SizedBox(height: GOLSpacing.inputLabelGap),
                      GOLSelectableChipGroup(
                        items: [
                          l10n.monday,
                          l10n.tuesday,
                          l10n.wednesday,
                          l10n.thursday,
                          l10n.friday,
                          l10n.saturday,
                          l10n.sunday,
                        ],
                        selectedItems: {
                          () {
                            final dayNames = [
                              l10n.monday,
                              l10n.tuesday,
                              l10n.wednesday,
                              l10n.thursday,
                              l10n.friday,
                              l10n.saturday,
                              l10n.sunday,
                            ];
                            // Bounds check for safety
                            final index = _reminderDayOfWeek - 1;
                            if (index >= 0 && index < dayNames.length) {
                              return dayNames[index];
                            }
                            return dayNames[0]; // Default to Monday
                          }()
                        },
                        onChanged: (selected) {
                          setState(() {
                            final dayNames = [
                              l10n.monday,
                              l10n.tuesday,
                              l10n.wednesday,
                              l10n.thursday,
                              l10n.friday,
                              l10n.saturday,
                              l10n.sunday,
                            ];
                            final index = dayNames.indexOf(selected.first);
                            if (index >= 0 && index < dayNames.length) {
                              _reminderDayOfWeek = index + 1;
                            }
                          });
                        },
                      ),
                    ],
                  ],

                  const SizedBox(height: GOLSpacing.betweenSections),

                  // Create button
                  GOLButton(
                    label: l10n.createProject,
                    onPressed: _isLoading ? null : _handleCreate,
                    isLoading: _isLoading,
                    fullWidth: true,
                    size: GOLButtonSize.large,
                  ),

                  const SizedBox(height: GOLSpacing.screenPaddingBottomNoNav),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
          ),
    );
  }
}

/// Currency dropdown with name on left and code on right
class _CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencyDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final selectedCurrency = CurrencyConstants.getCurrency(value);

    return GOLCard(
      variant: GOLCardVariant.interactive,
      onTap: () => _showCurrencyPicker(context),
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.inputPaddingHorizontal,
        vertical: GOLSpacing.inputPaddingVertical,
      ),
      child: Row(
        children: [
          Icon(Iconsax.dollar_circle, color: colors.textTertiary),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Text(
              selectedCurrency.name,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: GOLSpacing.space2,
              vertical: GOLSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: colors.interactivePrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              selectedCurrency.code,
              style: textTheme.labelMedium?.copyWith(
                color: colors.interactivePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: GOLSpacing.space2),
          Icon(Iconsax.arrow_down_1, size: 16, color: colors.textTertiary),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final currencies = CurrencyConstants.supportedCurrencies;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceDefault,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: GOLSpacing.space3),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderDefault,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(GOLSpacing.space4),
                child: Text(
                  AppLocalizations.of(context)!.selectCurrency,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const GOLDivider(),

              // Currency list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected = currency.code == value;

                    return ListTile(
                      onTap: () {
                        onChanged(currency.code);
                        Navigator.pop(context);
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.interactivePrimary.withValues(alpha: 0.15)
                              : colors.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            currency.symbol,
                            style: textTheme.titleSmall?.copyWith(
                              color: isSelected
                                  ? colors.interactivePrimary
                                  : colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        currency.name,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: GOLSpacing.space2,
                              vertical: GOLSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.interactivePrimary.withValues(alpha: 0.15)
                                  : colors.surfaceRaised,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              currency.code,
                              style: textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? colors.interactivePrimary
                                    : colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: GOLSpacing.space2),
                            Icon(
                              Iconsax.tick_circle5,
                              color: colors.interactivePrimary,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: GOLSpacing.space4),
            ],
          ),
        );
      },
    );
  }
}

class _LimitReachedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: GOLPrimitives.warning50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                size: 36,
                color: colors.stateWarning,
              ),
            ),
            const SizedBox(height: GOLSpacing.space6),
            Text(
              l10n.projectLimitReached,
              style: textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              l10n.projectLimitMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space6),
            GOLButton(
              label: l10n.goBack,
              onPressed: () => context.pop(),
              variant: GOLButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
