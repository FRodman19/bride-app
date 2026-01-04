import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../core/utils/currency_formatter.dart';

/// Performance overview card showing aggregated metrics.
/// Uses horizontal layout with dividers per design patterns.
class PerformanceOverviewCard extends StatelessWidget {
  final double totalProfit;
  final double totalRevenue;
  final double totalSpend;
  final String currencyCode;
  final int activeProjectsCount;

  const PerformanceOverviewCard({
    super.key,
    required this.totalProfit,
    required this.totalRevenue,
    required this.totalSpend,
    this.currencyCode = 'XOF',
    this.activeProjectsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isProfit = totalProfit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPaddingSpacious),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Iconsax.chart_2,
                size: 20,
                color: colors.interactivePrimary,
              ),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                'PERFORMANCE OVERVIEW',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colors.interactivePrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.folder_2,
                      size: 14,
                      color: colors.interactivePrimary,
                    ),
                    const SizedBox(width: GOLSpacing.space1),
                    Text(
                      '$activeProjectsCount active',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.interactivePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space4),

          // Net profit - main metric
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                size: 24,
                color: profitColor,
              ),
              const SizedBox(width: GOLSpacing.space2),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatAmount(totalProfit.round()),
                    style: textTheme.displaySmall?.copyWith(
                      color: profitColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space1),

          Text(
            isProfit ? 'Net profit' : 'Net loss',
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: GOLSpacing.space4),

          // Revenue and Spend row with divider
          IntrinsicHeight(
            child: Row(
              children: [
                // Revenue
                Expanded(
                  child: _MetricItem(
                    label: 'Revenue',
                    value: _formatAmount(totalRevenue.round()),
                    icon: Iconsax.wallet_add,
                    valueColor: colors.textPrimary,
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  color: colors.borderDefault,
                  margin: const EdgeInsets.symmetric(
                    horizontal: GOLSpacing.space3,
                  ),
                ),

                // Spend
                Expanded(
                  child: _MetricItem(
                    label: 'Spend',
                    value: _formatAmount(totalSpend.round()),
                    icon: Iconsax.wallet_minus,
                    valueColor: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    return CurrencyFormatter.format(amount, currencyCode: currencyCode);
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colors.textTertiary),
            const SizedBox(width: GOLSpacing.space1),
            Flexible(
              child: Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
