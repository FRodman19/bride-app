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
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../grow_out_loud/components/gol_select_field.dart';
import '../../../providers/tracker_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/currency_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../domain/models/tracker.dart';

/// Screen 14: Edit Project Settings
///
/// Edit tracker form - same as create but with pre-filled data.
/// Start date is NOT editable.
class EditTrackerScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const EditTrackerScreen({super.key, required this.trackerId});

  @override
  ConsumerState<EditTrackerScreen> createState() => _EditTrackerScreenState();
}

class _EditTrackerScreenState extends ConsumerState<EditTrackerScreen> {
  final _nameController = TextEditingController();
  final _revenueTargetController = TextEditingController();
  final _engagementTargetController = TextEditingController();
  final _setupCostController = TextEditingController();
  final _growthCostController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  String _currency = 'XAF';
  final Set<String> _selectedPlatforms = {};
  final Set<String> _selectedGoals = {};

  String? _nameError;
  bool _isLoading = false;
  bool _isInitialized = false;

  final List<String> _availablePlatforms = ["Facebook", "TikTok"];

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

  void _initializeFromTracker(Tracker tracker) {
    if (_isInitialized) return;
    _isInitialized = true;

    _nameController.text = tracker.name;
    _startDate = tracker.startDate;
    _currency = tracker.currency;
    _selectedPlatforms.addAll(tracker.platforms);
    _selectedGoals.addAll(tracker.goalTypes);

    if (tracker.revenueTarget != null) {
      _revenueTargetController.text = tracker.revenueTarget!.round().toString();
    }
    if (tracker.engagementTarget != null) {
      _engagementTargetController.text = tracker.engagementTarget.toString();
    }
    if (tracker.setupCost > 0) {
      _setupCostController.text = tracker.setupCost.round().toString();
    }
    if (tracker.growthCostMonthly > 0) {
      _growthCostController.text = tracker.growthCostMonthly.round().toString();
    }
    if (tracker.notes != null && tracker.notes!.isNotEmpty) {
      _notesController.text = tracker.notes!;
    }
  }

  Future<void> _handleSave(Tracker originalTracker) async {
    final l10n = AppLocalizations.of(context)!;

    // Validate
    setState(() {
      _nameError = Validators.trackerName(_nameController.text);
    });

    if (_nameError != null) return;
    if (_selectedPlatforms.isEmpty) {
      showGOLToast(context, l10n.pleaseSelectPlatform);
      return;
    }

    setState(() => _isLoading = true);

    // Parse optional numeric values
    final revenueTarget = double.tryParse(_revenueTargetController.text);
    final engagementTarget = int.tryParse(_engagementTargetController.text);
    final setupCost = double.tryParse(_setupCostController.text) ?? 0;
    final growthCost = double.tryParse(_growthCostController.text) ?? 0;

    // Create updated tracker
    final updatedTracker = originalTracker.copyWith(
      name: _nameController.text.trim(),
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
    );

    final result = await ref.read(trackersProvider.notifier).updateTracker(updatedTracker);

    if (mounted) {
      setState(() => _isLoading = false);

      if (result.success) {
        showGOLToast(
          context,
          l10n.projectUpdatedSuccess,
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
    final l10n = AppLocalizations.of(context)!;
    final availableGoals = _goalOptions(l10n);
    final tracker = ref.watch(trackerByIdProvider(widget.trackerId));

    if (tracker == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.editProject),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.warning_2, size: 48, color: colors.textTertiary),
              const SizedBox(height: GOLSpacing.space4),
              Text(
                l10n.trackerNotFound,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Initialize form with tracker data
    _initializeFromTracker(tracker);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.editProject,
          style: textTheme.headlineSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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

            // Start date (read-only)
            _buildLabel(l10n.startDate),
            const SizedBox(height: GOLSpacing.inputLabelGap),
            GOLCard(
              variant: GOLCardVariant.standard,
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
                      color: colors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Iconsax.lock_1, size: 16, color: colors.textTertiary),
                ],
              ),
            ),
            Text(
              l10n.startDateCannotBeChanged,
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
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

            // Revenue target (optional)
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

            // Setup cost
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

            // Monthly growth cost
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

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GOLButton(
                    label: l10n.cancel,
                    onPressed: () => context.pop(),
                    variant: GOLButtonVariant.secondary,
                    fullWidth: true,
                  ),
                ),
                const SizedBox(width: GOLSpacing.space3),
                Expanded(
                  child: GOLButton(
                    label: _isLoading ? l10n.saving : l10n.saveChanges,
                    onPressed: _isLoading ? null : () => _handleSave(tracker),
                    isLoading: _isLoading,
                    fullWidth: true,
                    size: GOLButtonSize.large,
                  ),
                ),
              ],
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Danger zone
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            Text(
              l10n.dangerZone,
              style: textTheme.labelMedium?.copyWith(
                color: colors.stateError,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),

            GOLButton(
              label: l10n.deleteProject,
              onPressed: () => _showDeleteConfirmation(tracker),
              variant: GOLButtonVariant.destructive,
              fullWidth: true,
              icon: Icon(Iconsax.trash, size: 18),
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

  void _showDeleteConfirmation(Tracker tracker) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceDefault,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => _DeleteTrackerConfirmation(
        tracker: tracker,
        onDelete: () async {
          Navigator.pop(sheetContext);
          setState(() => _isLoading = true);

          final result = await ref.read(trackersProvider.notifier).deleteTracker(tracker.id);

          if (!mounted) return;
          setState(() => _isLoading = false);
          // Use State's context after mounted check
          final l10n = AppLocalizations.of(context)!;

          if (result.success) {
            showGOLToast(
              context,
              l10n.projectDeletedSuccess,
              variant: GOLToastVariant.success,
            );
            // Go back to trackers list
            if (mounted) context.go('/trackers');
          } else if (result.error != null) {
            showGOLToast(
              context,
              result.error!,
              variant: GOLToastVariant.error,
            );
          }
        },
      ),
    );
  }
}

/// Screen 15: Delete Tracker Confirmation
class _DeleteTrackerConfirmation extends StatefulWidget {
  final Tracker tracker;
  final VoidCallback onDelete;

  const _DeleteTrackerConfirmation({
    required this.tracker,
    required this.onDelete,
  });

  @override
  State<_DeleteTrackerConfirmation> createState() => _DeleteTrackerConfirmationState();
}

class _DeleteTrackerConfirmationState extends State<_DeleteTrackerConfirmation> {
  final _confirmController = TextEditingController();
  bool get _canDelete => _confirmController.text.trim() == widget.tracker.name;

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _confirmController.removeListener(_onTextChanged);
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(GOLSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),

          // Warning icon and title
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.stateError.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.warning_2,
                  color: colors.stateError,
                  size: 24,
                ),
              ),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.deleteProject,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.stateError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      l10n.thisActionCannotBeUndone,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space5),

          // What gets deleted
          GOLCard(
            variant: GOLCardVariant.standard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.whatWillBeDeleted,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: GOLSpacing.space3),
                _DeleteItem(
                  icon: Iconsax.document_text,
                  text: l10n.allEntriesCount(widget.tracker.entryCount),
                ),
                const SizedBox(height: GOLSpacing.space2),
                _DeleteItem(
                  icon: Iconsax.gallery,
                  text: l10n.allPosts,
                ),
                const SizedBox(height: GOLSpacing.space2),
                _DeleteItem(
                  icon: Iconsax.chart_square,
                  text: l10n.allReportsData,
                ),
                const SizedBox(height: GOLSpacing.space2),
                _DeleteItem(
                  icon: Iconsax.clock,
                  text: l10n.completeHistory,
                ),
              ],
            ),
          ),

          const SizedBox(height: GOLSpacing.space5),

          // Confirm by typing name
          Text(
            l10n.typeProjectNameToConfirm(widget.tracker.name),
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: GOLSpacing.space2),
          GOLTextField(
            label: '',
            hintText: widget.tracker.name,
            controller: _confirmController,
          ),

          const SizedBox(height: GOLSpacing.space5),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: GOLButton(
                  label: l10n.cancel,
                  onPressed: () => Navigator.pop(context),
                  variant: GOLButtonVariant.secondary,
                  fullWidth: true,
                ),
              ),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: GOLButton(
                  label: l10n.deleteProject,
                  onPressed: _canDelete ? widget.onDelete : null,
                  variant: GOLButtonVariant.destructive,
                  fullWidth: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space4),
        ],
      ),
    );
  }
}

class _DeleteItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DeleteItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colors.stateError),
        const SizedBox(width: GOLSpacing.space2),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
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
