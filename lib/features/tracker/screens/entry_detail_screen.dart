import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../domain/models/tracker.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/platform_icons.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../routing/routes.dart';

/// Screen 8: Entry Detail View
///
/// Read-only view of a single daily entry showing all logged data
/// with profit breakdown and platform spend details.
class EntryDetailScreen extends ConsumerWidget {
  final String trackerId;
  final String entryId;

  const EntryDetailScreen({
    super.key,
    required this.trackerId,
    required this.entryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final trackersState = ref.watch(trackersProvider);
    final entriesState = ref.watch(entriesProvider(trackerId));

    // Get tracker
    Tracker? tracker;
    if (trackersState is TrackersLoaded) {
      tracker = trackersState.trackers.cast<Tracker?>().firstWhere(
            (t) => t?.id == trackerId,
            orElse: () => null,
          );
    }

    // Get entry
    Entry? entry;
    if (entriesState is EntriesLoaded) {
      try {
        entry = entriesState.entries.firstWhere((e) => e.id == entryId);
      } catch (_) {
        entry = null;
      }
    }

    // Loading state
    if (entriesState is EntriesLoading || trackersState is TrackersLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error or not found state
    if (tracker == null || entry == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
            onPressed: () => context.pop(),
          ),
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
                'Entry not found',
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isProfit = entry.profit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entry Detail',
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(entry.entryDate),
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(
              Routes.editEntryPath(trackerId, entryId),
            ),
            icon: Icon(Iconsax.edit_2, size: 18, color: colors.interactivePrimary),
            label: Text(
              'Edit',
              style: textTheme.labelLarge?.copyWith(
                color: colors.interactivePrimary,
              ),
            ),
          ),
        ],
        backgroundColor: colors.surfaceDefault,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GOLSpacing.space4),

            // Profit/Loss Summary Card
            _ProfitSummaryCard(
              entry: entry,
              currency: tracker.currency,
            ),

            const SizedBox(height: GOLSpacing.space5),

            // Breakdown Section
            _SectionHeader(title: 'Breakdown'),
            const SizedBox(height: GOLSpacing.space3),

            // Revenue Card
            _BreakdownCard(
              icon: Iconsax.wallet_add,
              title: 'REVENUE',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Received',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(
                          entry.totalRevenue,
                          currencyCode: tracker.currency,
                        ),
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.stateSuccess,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GOLSpacing.space1),
                  Text(
                    'From all channels combined',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: GOLSpacing.space3),

            // Ad Spend Card
            _BreakdownCard(
              icon: Iconsax.money_send,
              title: 'AD SPEND',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform breakdown
                  if (entry.platformSpends.isEmpty)
                    Text(
                      'No ad spend recorded',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textTertiary,
                      ),
                    )
                  else ...[
                    ...entry.platformSpends.entries.map((spend) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                PlatformIcons.getIcon(
                                  spend.key,
                                  size: 16,
                                  color: colors.textSecondary,
                                ),
                                const SizedBox(width: GOLSpacing.space2),
                                Text(
                                  spend.key,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              CurrencyFormatter.format(
                                spend.value,
                                currencyCode: tracker!.currency,
                              ),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const GOLDivider(),
                    const SizedBox(height: GOLSpacing.space2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Spend',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                            entry.totalSpend,
                            currencyCode: tracker.currency,
                          ),
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.stateError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: GOLSpacing.space3),

            // DMs/Leads Card
            _BreakdownCard(
              icon: Iconsax.message_text,
              title: 'DMS / LEADS',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Received',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${entry.totalDmsLeads}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.interactivePrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Text(
                            entry.totalDmsLeads == 1 ? 'message' : 'messages',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: GOLSpacing.space1),
                  Text(
                    'Potential leads',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: GOLSpacing.space5),

            // Calculation Section
            _SectionHeader(title: 'Calculation'),
            const SizedBox(height: GOLSpacing.space3),

            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Column(
                children: [
                  _CalculationRow(
                    label: 'Revenue',
                    value: CurrencyFormatter.format(
                      entry.totalRevenue,
                      currencyCode: tracker.currency,
                    ),
                    isPositive: true,
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _CalculationRow(
                    label: 'Total Spend',
                    value: '- ${CurrencyFormatter.format(
                      entry.totalSpend,
                      currencyCode: tracker.currency,
                    )}',
                    isPositive: false,
                  ),
                  const SizedBox(height: GOLSpacing.space3),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily ${isProfit ? 'Profit' : 'Loss'}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                            size: 20,
                            color: profitColor,
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Text(
                            CurrencyFormatter.format(
                              entry.profit,
                              currencyCode: tracker.currency,
                            ),
                            style: textTheme.titleLarge?.copyWith(
                              color: profitColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notes section (if any)
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: GOLSpacing.space5),
              _SectionHeader(title: 'Notes'),
              const SizedBox(height: GOLSpacing.space3),
              GOLCard(
                variant: GOLCardVariant.standard,
                padding: const EdgeInsets.all(GOLSpacing.cardPadding),
                child: Text(
                  entry.notes!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],

            const SizedBox(height: GOLSpacing.space5),

            // Metadata Section
            _SectionHeader(title: 'Metadata'),
            const SizedBox(height: GOLSpacing.space3),

            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Column(
                children: [
                  _MetadataRow(
                    label: 'Logged',
                    value: '${DateFormat('MMM d, yyyy').format(entry.createdAt)} at ${DateFormat('h:mm a').format(entry.createdAt)}',
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _MetadataRow(
                    label: 'Last edited',
                    value: entry.updatedAt.isAtSameMomentAs(entry.createdAt)
                        ? 'Never'
                        : '${DateFormat('MMM d, yyyy').format(entry.updatedAt)} at ${DateFormat('h:mm a').format(entry.updatedAt)}',
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _MetadataRow(
                    label: 'Project',
                    value: tracker.name,
                  ),
                ],
              ),
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Actions Section
            Row(
              children: [
                Expanded(
                  child: GOLButton(
                    label: 'Edit Entry',
                    onPressed: () => context.push(
                      Routes.editEntryPath(trackerId, entryId),
                    ),
                    variant: GOLButtonVariant.secondary,
                    size: GOLButtonSize.large,
                    fullWidth: true,
                  ),
                ),
                const SizedBox(width: GOLSpacing.space3),
                Expanded(
                  child: GOLButton(
                    label: 'Delete Entry',
                    onPressed: () => _showDeleteConfirmation(
                      context,
                      ref,
                      entry!,
                      tracker!.currency,
                    ),
                    variant: GOLButtonVariant.destructive,
                    size: GOLButtonSize.large,
                    fullWidth: true,
                  ),
                ),
              ],
            ),

            // Bottom padding
            const SizedBox(height: GOLSpacing.space8),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Entry entry,
    String currency,
  ) async {
    final confirmed = await showDeleteEntryConfirmation(
      context: context,
      date: DateFormat('MMMM d, yyyy').format(entry.entryDate),
      revenue: CurrencyFormatter.format(entry.totalRevenue, currencyCode: currency),
      spend: CurrencyFormatter.format(entry.totalSpend, currencyCode: currency),
      profit: '${entry.isProfitable ? '+' : ''}${CurrencyFormatter.format(entry.profit, currencyCode: currency)}',
      isProfit: entry.isProfitable,
    );

    if (confirmed && context.mounted) {
      final result = await ref
          .read(entriesProvider(trackerId).notifier)
          .deleteEntry(entryId);
      if (result.success && context.mounted) {
        context.pop();
        showSuccessToast(context, 'Entry deleted successfully');
      } else if (!result.success && context.mounted) {
        showErrorToast(context, result.error ?? 'Failed to delete entry');
      }
    }
  }
}

class _ProfitSummaryCard extends StatelessWidget {
  final Entry entry;
  final String currency;

  const _ProfitSummaryCard({
    required this.entry,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isProfit = entry.profit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPaddingSpacious),
      child: Column(
        children: [
          Text(
            'PROFIT/LOSS SUMMARY',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                size: 32,
                color: profitColor,
              ),
              const SizedBox(width: GOLSpacing.space2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  CurrencyFormatter.format(entry.profit, currencyCode: currency),
                  style: textTheme.displaySmall?.copyWith(
                    color: profitColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(
            isProfit ? 'Net Profit' : 'Net Loss',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title.toUpperCase(),
      style: textTheme.labelMedium?.copyWith(
        color: colors.textSecondary,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _BreakdownCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: GOLSpacing.space3),
          child,
        ],
      ),
    );
  }
}

class _CalculationRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _CalculationRow({
    required this.label,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Text(
          isPositive ? '+$value' : value,
          style: textTheme.bodyMedium?.copyWith(
            // Use normal text color for positive, only red for loss
            color: isPositive ? colors.textPrimary : colors.stateError,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetadataRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
