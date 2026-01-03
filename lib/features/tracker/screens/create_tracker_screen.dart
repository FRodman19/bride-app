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
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../providers/tracker_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/currency_constants.dart';

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
  String _currency = 'XOF';
  final Set<String> _selectedPlatforms = {'Facebook', 'TikTok'};
  final Set<String> _selectedGoals = {};

  String? _nameError;
  bool _isLoading = false;

  final List<String> _availablePlatforms = ['Facebook', 'TikTok'];
  final List<String> _availableGoals = [
    'Product Launch',
    'Lead Generation',
    'Brand Awareness',
    'Sales',
    'Engagement',
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

  Future<void> _handleCreate() async {
    // Validate
    setState(() {
      _nameError = Validators.trackerName(_nameController.text);
    });

    if (_nameError != null) return;
    if (_selectedPlatforms.isEmpty) {
      showGOLToast(context, 'Please select at least one platform');
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
        );

    if (mounted) {
      setState(() => _isLoading = false);

      if (result.success) {
        showGOLToast(context, 'Project created successfully');
        context.pop();
      } else if (result.error != null) {
        showGOLToast(context, result.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final canCreate = ref.watch(canCreateTrackerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'New Project',
          style: textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
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
                    label: 'Project Name',
                    hintText: 'e.g., Summer Campaign 2024',
                    controller: _nameController,
                    errorText: _nameError,
                    maxLength: 50,
                    prefixIcon: Icon(Iconsax.edit_2, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Start date
                  _buildLabel('Start Date'),
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
                          DateFormat('dd/MM/yyyy').format(_startDate),
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

                  // Currency selector
                  _buildLabel('Currency'),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  _CurrencySelector(
                    value: _currency,
                    onChanged: (value) => setState(() => _currency = value),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Platforms
                  _buildLabel('Platforms'),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  Wrap(
                    spacing: GOLSpacing.space2,
                    runSpacing: GOLSpacing.space2,
                    children: _availablePlatforms.map((platform) {
                      final isSelected = _selectedPlatforms.contains(platform);
                      return FilterChip(
                        label: Text(platform),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPlatforms.add(platform);
                            } else {
                              _selectedPlatforms.remove(platform);
                            }
                          });
                        },
                        backgroundColor: colors.surfaceDefault,
                        selectedColor: colors.accentSubtle,
                        checkmarkColor: colors.interactivePrimary,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Revenue target (optional)
                  GOLTextField(
                    label: 'Revenue Target (Optional)',
                    hintText: 'e.g., 500000',
                    controller: _revenueTargetController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.money, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Engagement target (optional)
                  GOLTextField(
                    label: 'Engagement Target (Optional)',
                    hintText: 'e.g., 100 DMs/Leads',
                    controller: _engagementTargetController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.message, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Setup cost
                  GOLTextField(
                    label: 'Setup Cost',
                    hintText: '0',
                    controller: _setupCostController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.wallet_minus, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Monthly growth cost
                  GOLTextField(
                    label: 'Monthly Growth Cost',
                    hintText: '0',
                    controller: _growthCostController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Iconsax.chart_1, color: colors.textTertiary),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Goals (optional)
                  _buildLabel('Goals (Optional)'),
                  const SizedBox(height: GOLSpacing.inputLabelGap),
                  Wrap(
                    spacing: GOLSpacing.space2,
                    runSpacing: GOLSpacing.space2,
                    children: _availableGoals.map((goal) {
                      final isSelected = _selectedGoals.contains(goal);
                      return FilterChip(
                        label: Text(goal),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedGoals.add(goal);
                            } else {
                              _selectedGoals.remove(goal);
                            }
                          });
                        },
                        backgroundColor: colors.surfaceDefault,
                        selectedColor: colors.accentSubtle,
                        checkmarkColor: colors.interactivePrimary,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: GOLSpacing.betweenFormFields),

                  // Notes (optional)
                  GOLTextField(
                    label: 'Notes (Optional)',
                    hintText: 'Add any notes about this project...',
                    controller: _notesController,
                    maxLength: 500,
                  ),

                  const SizedBox(height: GOLSpacing.betweenSections),

                  // Create button
                  GOLButton(
                    label: 'Create Project',
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

class _CurrencySelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencySelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final currencies = CurrencyConstants.supportedCurrencies;

    return Wrap(
      spacing: GOLSpacing.space2,
      runSpacing: GOLSpacing.space2,
      children: currencies.map((currency) {
        final isSelected = currency.code == value;
        return ChoiceChip(
          label: Text('${currency.symbol} ${currency.code}'),
          selected: isSelected,
          onSelected: (_) => onChanged(currency.code),
          backgroundColor: colors.surfaceDefault,
          selectedColor: colors.accentSubtle,
        );
      }).toList(),
    );
  }
}

class _LimitReachedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

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
              'Project Limit Reached',
              style: textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'You have 20 active projects. Archive some to create new ones.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space6),
            GOLButton(
              label: 'Go Back',
              onPressed: () => context.pop(),
              variant: GOLButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
