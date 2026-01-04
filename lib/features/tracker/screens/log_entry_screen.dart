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
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../grow_out_loud/components/gol_select_field.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/platform_icons.dart';

/// Screen 7: Log Daily Entry
///
/// Entry form to log daily performance:
/// - Date picker (required)
/// - Total Revenue (required)
/// - Platform Spend (per platform)
/// - DMs/Leads count
/// - Notes (optional)
/// - Auto-calculated profit summary
class LogEntryScreen extends ConsumerStatefulWidget {
  final String trackerId;
  final DateTime? initialDate;

  const LogEntryScreen({super.key, required this.trackerId, this.initialDate});

  @override
  ConsumerState<LogEntryScreen> createState() => _LogEntryScreenState();
}

class _LogEntryScreenState extends ConsumerState<LogEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _revenueController = TextEditingController();
  final _notesController = TextEditingController();
  final _dmsLeadsController = TextEditingController(text: '0');

  late DateTime _selectedDate;
  int _dmsLeads = 0;
  final Map<String, TextEditingController> _spendControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _revenueController.dispose();
    _notesController.dispose();
    _dmsLeadsController.dispose();
    for (final controller in _spendControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _totalRevenue => int.tryParse(_revenueController.text) ?? 0;

  int get _totalSpend {
    int total = 0;
    for (final controller in _spendControllers.values) {
      total += int.tryParse(controller.text) ?? 0;
    }
    return total;
  }

  int get _profit => _totalRevenue - _totalSpend;

  Future<void> _selectDate() async {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: colors.interactivePrimary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Collect platform spends
    final platformSpends = <String, int>{};
    for (final entry in _spendControllers.entries) {
      final amount = int.tryParse(entry.value.text) ?? 0;
      if (amount > 0) {
        platformSpends[entry.key] = amount;
      }
    }

    final result = await ref
        .read(entriesProvider(widget.trackerId).notifier)
        .createEntry(
          entryDate: _selectedDate,
          totalRevenue: _totalRevenue,
          totalDmsLeads: _dmsLeads,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          platformSpends: platformSpends,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      showGOLToast(
        context,
        'Entry logged successfully',
        variant: GOLToastVariant.success,
      );
      context.pop();
    } else if (result.error != null) {
      showGOLToast(context, result.error!, variant: GOLToastVariant.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final tracker = ref.watch(trackerByIdProvider(widget.trackerId));

    if (tracker == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Log Entry')),
        body: const Center(child: Text('Tracker not found')),
      );
    }

    // Initialize spend controllers for tracker's platforms
    for (final platform in tracker.platforms) {
      _spendControllers.putIfAbsent(platform, () => TextEditingController());
    }

    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final isToday = _isSameDay(_selectedDate, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.close_circle),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Log Entry',
          style: textTheme.headlineSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: GOLSpacing.space3),
            child: GOLButton(
              label: 'Save',
              onPressed: _isLoading ? null : _saveEntry,
              variant: GOLButtonVariant.primary,
              size: GOLButtonSize.small,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          children: [
            // Date Selector
            _buildDateSelector(colors, textTheme, dateFormat, isToday),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Total Revenue
            GOLTextField(
              label: 'Total Revenue',
              hintText: '0',
              controller: _revenueController,
              keyboardType: TextInputType.number,
              prefixIcon: Icon(
                Iconsax.money_recive,
                color: colors.textTertiary,
              ),
              trailingSuffix: GOLBadge(text: tracker.currency),
            ),
            Text(
              'How much did you earn today?',
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Platform Spends Section
            _buildPlatformSpendsSection(colors, textTheme, tracker),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // DMs/Leads Counter
            _buildDmsLeadsCounter(colors, textTheme),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Notes (optional)
            GOLTextField(
              label: 'Notes (Optional)',
              hintText: 'Any notes about today...',
              controller: _notesController,
              prefixIcon: Icon(Iconsax.note_1, color: colors.textTertiary),
            ),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Summary Card
            _buildSummaryCard(colors, textTheme, tracker.currency),

            const SizedBox(height: GOLSpacing.space8),

            // Save Button (bottom)
            GOLButton(
              label: _isLoading ? 'Saving...' : 'Save Entry',
              onPressed: _isLoading ? null : _saveEntry,
              variant: GOLButtonVariant.primary,
              fullWidth: true,
            ),

            const SizedBox(height: GOLSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    GOLSemanticColors colors,
    TextTheme textTheme,
    DateFormat dateFormat,
    bool isToday,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: textTheme.labelSmall?.copyWith(color: colors.textSecondary),
        ),
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
              IconButton(
                icon: const Icon(Iconsax.arrow_left_2),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(
                      const Duration(days: 1),
                    );
                  });
                },
                iconSize: 20,
                color: colors.textTertiary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isToday
                          ? 'TODAY'
                          : dateFormat.format(_selectedDate).toUpperCase(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.interactivePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isToday)
                      Text(
                        dateFormat.format(_selectedDate),
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: GOLSpacing.space3),
              IconButton(
                icon: const Icon(Iconsax.arrow_right_3),
                onPressed: _isSameDay(_selectedDate, DateTime.now())
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = _selectedDate.add(
                            const Duration(days: 1),
                          );
                        });
                      },
                iconSize: 20,
                color: _isSameDay(_selectedDate, DateTime.now())
                    ? colors.textTertiary.withValues(alpha: 0.3)
                    : colors.textTertiary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSpendsSection(
    GOLSemanticColors colors,
    TextTheme textTheme,
    dynamic tracker,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Iconsax.money_send, size: 16, color: colors.textSecondary),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  'AD SPEND',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              'Today: ${CurrencyFormatter.format(_totalSpend, currencyCode: tracker.currency)}',
              style: textTheme.labelMedium?.copyWith(
                color: colors.interactivePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),

        // Platform spend fields
        ...tracker.platforms.map<Widget>((platform) {
          return Padding(
            padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
            child: GOLTextField(
              label: platform,
              hintText: '0',
              controller: _spendControllers[platform]!,
              keyboardType: TextInputType.number,
              prefixIcon: PlatformIcons.getIcon(
                platform,
                size: 20,
                color: colors.textTertiary,
              ),
              trailingSuffix: GOLBadge(text: tracker.currency),
            ),
          );
        }),

        Text(
          'Enter how much you spent on each platform today',
          style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildDmsLeadsCounter(GOLSemanticColors colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Iconsax.message, size: 20, color: colors.textSecondary),
            const SizedBox(width: GOLSpacing.space2),
            Text(
              'DMS / LEADS (Optional)',
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'Inbound only',
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),

        // Counter with inline text input
        GOLCard(
          variant: GOLCardVariant.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: GOLSpacing.space4,
            vertical: GOLSpacing.space3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.minus),
                onPressed: _dmsLeads > 0
                    ? () {
                        setState(() {
                          _dmsLeads--;
                          _dmsLeadsController.text = '$_dmsLeads';
                        });
                      }
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceRaised,
                  disabledBackgroundColor: colors.surfaceRaised.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: GOLSpacing.space4),
              // Direct inline text input
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _dmsLeadsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: GOLSpacing.space2,
                      vertical: GOLSpacing.space2,
                    ),
                    filled: true,
                    fillColor: colors.surfaceRaised,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.borderStrong,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final newValue = int.tryParse(value) ?? 0;
                    setState(() => _dmsLeads = newValue.clamp(0, 9999));
                  },
                ),
              ),
              const SizedBox(width: GOLSpacing.space4),
              IconButton(
                icon: const Icon(Iconsax.add),
                onPressed: () {
                  setState(() {
                    _dmsLeads++;
                    _dmsLeadsController.text = '$_dmsLeads';
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: colors.interactivePrimary,
                  foregroundColor: colors.textInverse,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    GOLSemanticColors colors,
    TextTheme textTheme,
    String currency,
  ) {
    final isProfitable = _profit >= 0;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUMMARY',
            style: textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),

          _buildSummaryRow(
            textTheme,
            colors,
            'Revenue',
            CurrencyFormatter.format(_totalRevenue, currencyCode: currency),
            colors.textPrimary,
          ),
          const SizedBox(height: GOLSpacing.space2),
          _buildSummaryRow(
            textTheme,
            colors,
            'Spend',
            '-${CurrencyFormatter.format(_totalSpend, currencyCode: currency)}',
            colors.stateError,
          ),

          const SizedBox(height: GOLSpacing.space3),
          const GOLDivider(),
          const SizedBox(height: GOLSpacing.space3),

          _buildSummaryRow(
            textTheme,
            colors,
            'Profit/Loss',
            '${isProfitable ? '+' : ''}${CurrencyFormatter.format(_profit, currencyCode: currency)}',
            isProfitable ? colors.stateSuccess : colors.stateError,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    TextTheme textTheme,
    GOLSemanticColors colors,
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (isBold ? textTheme.titleMedium : textTheme.bodyMedium)
              ?.copyWith(
                color: valueColor,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
