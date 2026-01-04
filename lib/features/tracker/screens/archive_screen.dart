import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/foundation/gol_radius.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../domain/models/tracker.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/tracker_provider.dart';
import '../../../routing/routes.dart';

/// Screen 6: Archive View
///
/// Shows all archived trackers with restore/delete options.
class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final trackersState = ref.watch(trackersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Archived Trackers',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Performance',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Iconsax.arrow_left),
        ),
        actions: [
          if (trackersState is TrackersLoaded && trackersState.archivedTrackers.isNotEmpty)
            IconButton(
              onPressed: () {
                // TODO: Implement search
              },
              icon: const Icon(Iconsax.search_normal),
            ),
        ],
      ),
      body: _buildBody(context, ref, trackersState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, TrackersState state) {
    if (state is TrackersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TrackersError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.warning_2, size: 48),
            const SizedBox(height: GOLSpacing.space4),
            Text('Error: ${state.message}'),
            const SizedBox(height: GOLSpacing.space4),
            GOLButton(
              label: 'Retry',
              onPressed: () => ref.read(trackersProvider.notifier).loadTrackers(),
            ),
          ],
        ),
      );
    }

    if (state is TrackersLoaded) {
      final archivedTrackers = state.archivedTrackers;

      if (archivedTrackers.isEmpty) {
        return const _ArchiveEmptyState();
      }

      return _ArchiveList(trackers: archivedTrackers);
    }

    return const SizedBox();
  }
}

/// Empty state for archive (Screen 24)
class _ArchiveEmptyState extends StatelessWidget {
  const _ArchiveEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.archive_tick,
              size: 64,
              color: colors.textTertiary,
            ),
            const SizedBox(height: GOLSpacing.space5),
            Text(
              'No Archived Trackers',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              'Archived trackers are campaigns you\'ve completed or paused.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space5),
            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Archiving a tracker:',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space3),
                  _InfoRow(
                    icon: Iconsax.minus_cirlce,
                    text: 'Removes it from active dashboard',
                    colors: colors,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _InfoRow(
                    icon: Iconsax.document_text,
                    text: 'Preserves all data',
                    colors: colors,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _InfoRow(
                    icon: Iconsax.refresh_circle,
                    text: 'Can be restored anytime',
                    colors: colors,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _InfoRow(
                    icon: Iconsax.clock,
                    text: 'Keeps historical records',
                    colors: colors,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: GOLSpacing.space5),
            Text(
              'To archive a tracker:\nOpen tracker > Menu > Archive',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final GOLSemanticColors colors;
  final TextTheme textTheme;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.textSecondary,
        ),
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

/// List of archived trackers
class _ArchiveList extends ConsumerWidget {
  final List<Tracker> trackers;

  const _ArchiveList({required this.trackers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),
          Text(
            'These trackers are archived but preserved for reference. You can restore or permanently delete them.',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: GOLSpacing.space5),
          Text(
            'ARCHIVED TRACKERS (${trackers.length})',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: GOLSpacing.space3),
          ...trackers.map((tracker) => Padding(
            padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
            child: _ArchivedTrackerCard(tracker: tracker),
          )),
          const SizedBox(height: GOLSpacing.space4),
          Container(
            padding: const EdgeInsets.all(GOLSpacing.space3),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(GOLRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 16,
                  color: colors.textTertiary,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Expanded(
                  child: Text(
                    'Archived trackers don\'t count toward active performance metrics',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: GOLSpacing.space7),
        ],
      ),
    );
  }
}

/// Individual archived tracker card
class _ArchivedTrackerCard extends ConsumerWidget {
  final Tracker tracker;

  const _ArchivedTrackerCard({required this.tracker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Calculate final profit
    final finalProfit = (tracker.totalRevenue - tracker.totalSpend - tracker.setupCost).round();
    final profitResult = CurrencyFormatter.formatProfit(finalProfit, currencyCode: tracker.currency);

    // Calculate duration (use updatedAt as approximate archive date)
    final duration = _calculateDuration(tracker.startDate, tracker.updatedAt);

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          InkWell(
            onTap: () => context.push(Routes.trackerHubPath(tracker.id)),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(GOLRadius.sm),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.chart_1,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: GOLSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tracker.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (tracker.notes != null && tracker.notes!.isNotEmpty)
                        Text(
                          tracker.notes!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: GOLSpacing.space3),

          // Info rows
          Row(
            children: [
              Expanded(
                child: _InfoChip(
                  label: 'Archived',
                  value: DateFormat('MMM d, yyyy').format(tracker.updatedAt),
                  colors: colors,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: GOLSpacing.space2),
              Expanded(
                child: _InfoChip(
                  label: 'Duration',
                  value: duration,
                  colors: colors,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space2),

          // Final profit row
          Container(
            padding: const EdgeInsets.all(GOLSpacing.space3),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(GOLRadius.sm),
            ),
            child: Row(
              children: [
                Text(
                  'Final Profit:',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  profitResult.formatted,
                  style: textTheme.titleSmall?.copyWith(
                    color: profitResult.isProfit ? colors.textPrimary : colors.stateError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: GOLSpacing.space3),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: GOLButton(
                  label: 'Restore',
                  variant: GOLButtonVariant.secondary,
                  onPressed: () => _restoreTracker(context, ref),
                ),
              ),
              const SizedBox(width: GOLSpacing.space2),
              Expanded(
                child: GOLButton(
                  label: 'Delete',
                  variant: GOLButtonVariant.destructive,
                  onPressed: () => _showDeleteConfirmation(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final days = difference.inDays;

    if (days < 7) {
      return '$days days';
    } else if (days < 30) {
      final weeks = (days / 7).round();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else {
      final months = (days / 30).round();
      return '$months ${months == 1 ? 'month' : 'months'}';
    }
  }

  Future<void> _restoreTracker(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(trackersProvider.notifier).restoreTracker(tracker.id);

    if (!context.mounted) return;

    if (result.success) {
      showGOLToast(
        context,
        '${tracker.name} restored',
        variant: GOLToastVariant.success,
      );
    } else {
      showGOLToast(
        context,
        result.error ?? 'Failed to restore tracker',
        variant: GOLToastVariant.error,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Tracker?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"${tracker.name}"',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              'This will permanently delete the tracker and all associated data including:',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            _DeleteInfoItem(text: 'All daily entries', colors: colors, textTheme: textTheme),
            _DeleteInfoItem(text: 'All posts', colors: colors, textTheme: textTheme),
            _DeleteInfoItem(text: 'All reports data', colors: colors, textTheme: textTheme),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              'This action cannot be undone.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.stateError,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          GOLButton(
            label: 'Cancel',
            variant: GOLButtonVariant.tertiary,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          GOLButton(
            label: 'Delete',
            variant: GOLButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(dialogContext);

              final result = await ref.read(trackersProvider.notifier).deleteTracker(tracker.id);

              if (!context.mounted) return;

              if (result.success) {
                showGOLToast(
                  context,
                  '${tracker.name} deleted',
                  variant: GOLToastVariant.success,
                );
              } else {
                showGOLToast(
                  context,
                  result.error ?? 'Failed to delete tracker',
                  variant: GOLToastVariant.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final GOLSemanticColors colors;
  final TextTheme textTheme;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.space3,
        vertical: GOLSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(GOLRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.textTertiary,
            ),
          ),
          Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteInfoItem extends StatelessWidget {
  final String text;
  final GOLSemanticColors colors;
  final TextTheme textTheme;

  const _DeleteInfoItem({
    required this.text,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: GOLSpacing.space1),
      child: Row(
        children: [
          Icon(
            Iconsax.minus,
            size: 14,
            color: colors.stateError,
          ),
          const SizedBox(width: GOLSpacing.space2),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
