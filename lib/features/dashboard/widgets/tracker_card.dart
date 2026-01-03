import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/models/tracker.dart';

/// Compact tracker card for dashboard lists.
/// Uses horizontal layout per design patterns.
class TrackerCard extends StatelessWidget {
  final Tracker tracker;
  final VoidCallback? onTap;

  const TrackerCard({
    super.key,
    required this.tracker,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isProfit = tracker.totalProfit >= 0;
    final profitColor = isProfit ? colors.stateSuccess : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.interactive,
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
                  '${tracker.entryCount} ${tracker.entryCount == 1 ? 'entry' : 'entries'}',
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
                    _formatProfit(tracker.totalProfit.round()),
                    style: textTheme.titleSmall?.copyWith(
                      color: profitColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space1),
              Text(
                isProfit ? 'profit' : 'loss',
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
