import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/models/tracker.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Compact tracker card for dashboard lists.
/// Uses horizontal layout per design patterns.
///
/// Accepts optional live stats (totalProfit, entryCount) that override
/// tracker's stored values for real-time display.
class TrackerCard extends StatelessWidget {
  final Tracker tracker;
  final VoidCallback? onTap;

  /// Live profit from entries (overrides tracker.totalProfit)
  final int? liveProfit;

  /// Live entry count from entries (overrides tracker.entryCount)
  final int? liveEntryCount;

  const TrackerCard({
    super.key,
    required this.tracker,
    this.onTap,
    this.liveProfit,
    this.liveEntryCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Use live data if provided, otherwise fall back to tracker values
    final displayProfit = liveProfit ?? tracker.totalProfit.round();
    final displayEntryCount = liveEntryCount ?? tracker.entryCount;

    final isProfit = displayProfit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.standard,
      onTap: onTap,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.chart_square,
              size: 22,
              color: colors.interactivePrimary,
            ),
          ),

          const SizedBox(width: GOLSpacing.space3),

          // Name and entries count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tracker.name,
                  style: textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: GOLSpacing.space1),
                Text(
                  '$displayEntryCount ${displayEntryCount == 1 ? l10n.entrySingular : l10n.entriesPlural}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: GOLSpacing.space3),

          // Profit
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isProfit ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                    size: 14,
                    color: profitColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    _formatProfit(displayProfit),
                    style: textTheme.titleSmall?.copyWith(
                      color: profitColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space1),
              Text(
                isProfit ? l10n.profit : l10n.loss,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(width: GOLSpacing.space2),

          // Chevron
          Icon(
            Iconsax.arrow_right_3,
            size: 18,
            color: colors.textTertiary,
          ),
        ],
      ),
    );
  }

  String _formatProfit(int amount) {
    final absAmount = amount.abs();
    return CurrencyFormatter.format(
      absAmount,
      currencyCode: tracker.currency,
      showSymbol: false,
    );
  }
}
