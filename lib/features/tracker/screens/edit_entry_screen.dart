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
import '../../../l10n/generated/app_localizations.dart';

/// Screen 9: Edit Entry
///
/// Edit form for modifying an existing daily entry.
/// Same structure as Log Entry but pre-filled with existing data.
class EditEntryScreen extends ConsumerStatefulWidget {
  final String trackerId;
  final String entryId;

  const EditEntryScreen({
    super.key,
    required this.trackerId,
    required this.entryId,
  });

  @override
  ConsumerState<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends ConsumerState<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _revenueController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _entryDate;
  int _dmsLeads = 0;
  final Map<String, TextEditingController> _spendControllers = {};
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _revenueController.dispose();
    _notesController.dispose();
    for (final controller in _spendControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeFromEntry(Entry entry, List<String> platforms) {
    if (_isInitialized) return;

    _entryDate = entry.entryDate;
    _revenueController.text = entry.totalRevenue.toString();
    _notesController.text = entry.notes ?? '';
    _dmsLeads = entry.totalDmsLeads;

    // Initialize spend controllers for all tracker platforms
    for (final platform in platforms) {
      final controller = TextEditingController();
      controller.text = (entry.platformSpends[platform] ?? 0).toString();
      _spendControllers[platform] = controller;
    }

    _isInitialized = true;
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

  Future<void> _saveEntry(Entry originalEntry) async {
    final l10n = AppLocalizations.of(context)!;
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

    final updatedEntry = originalEntry.copyWith(
      totalRevenue: _totalRevenue,
      totalDmsLeads: _dmsLeads,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      platformSpends: platformSpends,
    );

    final result = await ref
        .read(entriesProvider(widget.trackerId).notifier)
        .updateEntry(updatedEntry);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      showGOLToast(context, l10n.entryUpdatedSuccessfully, variant: GOLToastVariant.success);
      context.pop();
    } else if (result.error != null) {
      showGOLToast(context, result.error!, variant: GOLToastVariant.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final tracker = ref.watch(trackerByIdProvider(widget.trackerId));
    final entriesState = ref.watch(entriesProvider(widget.trackerId));

    if (tracker == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editEntry)),
        body: Center(child: Text(l10n.trackerNotFound)),
      );
    }

    // Get the entry
    Entry? entry;
    if (entriesState is EntriesLoaded) {
      try {
        entry = entriesState.entries.firstWhere((e) => e.id == widget.entryId);
      } catch (_) {
        entry = null;
      }
    }

    if (entriesState is EntriesLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.editEntry),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.editEntry),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.document_text, size: 48, color: colors.textTertiary),
              const SizedBox(height: GOLSpacing.space4),
              Text(
                l10n.entryNotFound,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Initialize form with entry data
    _initializeFromEntry(entry, tracker.platforms);

    final dateFormat = DateFormat('EEEE, MMM d, yyyy', l10n.localeName);

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.cancel,
            style: textTheme.labelLarge?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          l10n.editEntry,
          style: textTheme.headlineSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: GOLSpacing.space3),
            child: GOLButton(
              label: l10n.save,
              onPressed: _isLoading ? null : () => _saveEntry(entry!),
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
            // Date Display (Read-only for edit)
            _buildDateDisplay(colors, textTheme, dateFormat, l10n),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Total Revenue
            GOLTextField(
              label: l10n.totalRevenue,
              hintText: '0',
              controller: _revenueController,
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Iconsax.money_recive, color: colors.textTertiary),
              trailingSuffix: GOLBadge(text: tracker.currency),
            ),
            Text(
              l10n.dailyEarningQuestion,
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Platform Spends Section
            _buildPlatformSpendsSection(colors, textTheme, tracker, l10n),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // DMs/Leads Counter
            _buildDmsLeadsCounter(colors, textTheme, l10n),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Notes (optional)
            GOLTextField(
              label: l10n.notesOptional,
              hintText: l10n.anyNotesAboutToday,
              controller: _notesController,
              prefixIcon: Icon(Iconsax.note_1, color: colors.textTertiary),
            ),

            const SizedBox(height: GOLSpacing.space6),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space6),

            // Summary Card
            _buildSummaryCard(colors, textTheme, tracker.currency, l10n),

            const SizedBox(height: GOLSpacing.space8),

            // Save Button (bottom)
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
                    onPressed: _isLoading ? null : () => _saveEntry(entry!),
                    variant: GOLButtonVariant.primary,
                    fullWidth: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: GOLSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDisplay(
    GOLSemanticColors colors,
    TextTheme textTheme,
    DateFormat dateFormat,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dateLabel,
          style: textTheme.labelSmall?.copyWith(color: colors.textSecondary),
        ),
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
              Expanded(
                child: Text(
                  dateFormat.format(_entryDate),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(Iconsax.lock_1, size: 16, color: colors.textTertiary),
            ],
          ),
        ),
        const SizedBox(height: GOLSpacing.space1),
        Text(
          l10n.dateLocked,
          style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildPlatformSpendsSection(
    GOLSemanticColors colors,
    TextTheme textTheme,
    dynamic tracker,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Iconsax.money_send, size: 20, color: colors.textSecondary),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.adSpend,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${l10n.totalLabel}: ${CurrencyFormatter.format(_totalSpend, currencyCode: tracker.currency)}',
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
          // Ensure controller exists
          _spendControllers.putIfAbsent(platform, () => TextEditingController(text: '0'));

          return Padding(
            padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
            child: GOLTextField(
              label: platform,
              hintText: '0',
              controller: _spendControllers[platform]!,
              keyboardType: TextInputType.number,
              prefixIcon: PlatformIcons.getIcon(platform, size: 20, color: colors.textTertiary),
              trailingSuffix: GOLBadge(text: tracker.currency),
            ),
          );
        }),

        Text(
          l10n.enterSpendPerPlatform,
          style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildDmsLeadsCounter(
    GOLSemanticColors colors,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Iconsax.message, size: 20, color: colors.textSecondary),
            const SizedBox(width: GOLSpacing.space2),
            Text(
              l10n.dmsLeads,
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              l10n.inboundOnly,
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),

        // Counter
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
                    ? () => setState(() => _dmsLeads--)
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceRaised,
                  disabledBackgroundColor: colors.surfaceRaised.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: GOLSpacing.space6),
              Text(
                '$_dmsLeads',
                style: textTheme.displaySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: GOLSpacing.space6),
              IconButton(
                icon: const Icon(Iconsax.add),
                onPressed: () => setState(() => _dmsLeads++),
                style: IconButton.styleFrom(
                  backgroundColor: colors.interactivePrimary,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: GOLSpacing.space2),
        Text(
          l10n.messagesReceivedQuestion,
          style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    GOLSemanticColors colors,
    TextTheme textTheme,
    String currency,
    AppLocalizations l10n,
  ) {
    final isProfitable = _profit >= 0;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.summary,
            style: textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),

          _buildSummaryRow(
            textTheme,
            colors,
            l10n.revenue,
            CurrencyFormatter.format(_totalRevenue, currencyCode: currency),
            colors.textPrimary,
          ),
          const SizedBox(height: GOLSpacing.space2),
          _buildSummaryRow(
            textTheme,
            colors,
            l10n.spend,
            '-${CurrencyFormatter.format(_totalSpend, currencyCode: currency)}',
            colors.stateError,
          ),

          const SizedBox(height: GOLSpacing.space3),
          const GOLDivider(),
          const SizedBox(height: GOLSpacing.space3),

          _buildSummaryRow(
            textTheme,
            colors,
            l10n.profitLoss,
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
          style: (isBold ? textTheme.titleMedium : textTheme.bodyMedium)?.copyWith(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
