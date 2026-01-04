import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/foundation/gol_radius.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../domain/models/tracker.dart';
import '../../../routing/routes.dart';
import '../../shared/widgets/empty_state.dart';
import '../../dashboard/widgets/tracker_card.dart';

/// Screen 35: Projects List View
///
/// Shows all active and archived projects.
class TrackersListScreen extends ConsumerWidget {
  const TrackersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final trackersState = ref.watch(trackersProvider);

    return Scaffold(
      body: SafeArea(
        child: switch (trackersState) {
          TrackersLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          TrackersError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.warning_2, size: 48, color: colors.stateError),
                  const SizedBox(height: GOLSpacing.space4),
                  Text(
                    'Error loading projects',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Text(
                    message,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          TrackersLoaded(:final trackers) when trackers.isEmpty =>
            _ProjectsEmptyState(
              onCreateProject: () => context.push(Routes.createTracker),
            ),
          TrackersLoaded(:final trackers) => _TrackersListContent(
              activeTrackers: trackers.where((t) => !t.isArchived).toList(),
              archivedTrackers: trackers.where((t) => t.isArchived).toList(),
            ),
        },
      ),
      // Only show FAB when there are existing projects
      floatingActionButton: trackersState is TrackersLoaded &&
              trackersState.trackers.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.push(Routes.createTracker),
              backgroundColor: colors.interactivePrimary,
              child: Icon(Iconsax.add, color: colors.textInverse),
            )
          : null,
    );
  }
}

class _ProjectsEmptyState extends StatelessWidget {
  final VoidCallback onCreateProject;

  const _ProjectsEmptyState({required this.onCreateProject});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),

          // Header - consistent with non-empty state
          Text(
            'Projects',
            style: textTheme.displaySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Manage all your projects',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: GOLSpacing.space6),

          // Empty state card with feature bullets
          EmptyState.dashboard(onCreateProject: onCreateProject),
        ],
      ),
    );
  }
}

/// Helper class to hold tracker stats calculated from entries
class _TrackerStats {
  final int totalProfit;
  final int entryCount;

  const _TrackerStats({
    this.totalProfit = 0,
    this.entryCount = 0,
  });
}

class _TrackersListContent extends ConsumerStatefulWidget {
  final List<Tracker> activeTrackers;
  final List<Tracker> archivedTrackers;

  const _TrackersListContent({
    required this.activeTrackers,
    required this.archivedTrackers,
  });

  @override
  ConsumerState<_TrackersListContent> createState() => _TrackersListContentState();
}

class _TrackersListContentState extends ConsumerState<_TrackersListContent> {
  void _showProjectOptions(Tracker tracker) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.modal),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(GOLSpacing.space4),
              child: Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tracker.name,
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: GOLSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tracker.isArchived
                                ? colors.surfaceRaised
                                : colors.stateSuccess.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tracker.isArchived ? 'Archived' : 'Active',
                            style: textTheme.labelSmall?.copyWith(
                              color: tracker.isArchived
                                  ? colors.textTertiary
                                  : colors.stateSuccess,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Archive/Restore option
            InkWell(
              onTap: () {
                Navigator.pop(dialogContext);
                _handleArchiveRestore(tracker);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space4,
                  vertical: GOLSpacing.space3,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.interactivePrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        tracker.isArchived ? Iconsax.refresh : Iconsax.archive_1,
                        size: 20,
                        color: colors.interactivePrimary,
                      ),
                    ),
                    const SizedBox(width: GOLSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tracker.isArchived ? 'Restore Project' : 'Archive Project',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            tracker.isArchived
                                ? 'Move back to active projects'
                                : 'Move to archive (read-only)',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 16,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Delete option
            InkWell(
              onTap: () {
                Navigator.pop(dialogContext);
                _showDeleteConfirmation(tracker);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space4,
                  vertical: GOLSpacing.space3,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.stateError.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.trash,
                        size: 20,
                        color: colors.stateError,
                      ),
                    ),
                    const SizedBox(width: GOLSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Project',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.stateError,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Permanently delete this project',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 16,
                      color: colors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: GOLSpacing.space2),
          ],
        ),
      ),
    );
  }

  Future<void> _handleArchiveRestore(Tracker tracker) async {
    final notifier = ref.read(trackersProvider.notifier);

    if (tracker.isArchived) {
      final result = await notifier.restoreTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          'Project restored',
          variant: GOLToastVariant.success,
        );
      } else {
        showGOLToast(
          context,
          result.error ?? 'Failed to restore project',
          variant: GOLToastVariant.error,
        );
      }
    } else {
      final result = await notifier.archiveTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          'Project archived',
          variant: GOLToastVariant.success,
        );
      } else {
        showGOLToast(
          context,
          result.error ?? 'Failed to archive project',
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  void _showDeleteConfirmation(Tracker tracker) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.modal),
        ),
        title: Text(
          'Delete Project?',
          style: textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently delete "${tracker.name}" and all its entries. This action cannot be undone.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          GOLButton(
            label: 'Cancel',
            variant: GOLButtonVariant.secondary,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          GOLButton(
            label: 'Delete',
            variant: GOLButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(dialogContext);

              final result = await ref.read(trackersProvider.notifier).deleteTracker(tracker.id);
              if (!mounted) return;

              if (result.success) {
                showGOLToast(
                  context,
                  'Project deleted',
                  variant: GOLToastVariant.success,
                );
              } else {
                showGOLToast(
                  context,
                  result.error ?? 'Failed to delete project',
                  variant: GOLToastVariant.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Calculate stats from entries for each tracker
    final Map<String, _TrackerStats> trackerStats = {};

    for (final tracker in [...widget.activeTrackers, ...widget.archivedTrackers]) {
      final entriesState = ref.watch(entriesProvider(tracker.id));

      if (entriesState is EntriesLoaded) {
        int revenue = 0;
        int spend = 0;
        for (final entry in entriesState.entries) {
          revenue += entry.totalRevenue;
          spend += entry.totalSpend;
        }
        trackerStats[tracker.id] = _TrackerStats(
          totalProfit: revenue - spend,
          entryCount: entriesState.entries.length,
        );
      } else {
        // Use tracker's stored values as fallback while loading
        trackerStats[tracker.id] = _TrackerStats(
          totalProfit: tracker.totalProfit.round(),
          entryCount: tracker.entryCount,
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Provider handles refresh
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GOLSpacing.space4),

            // Header
            Text(
              'Projects',
              style: textTheme.displaySmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.activeTrackers.length} active, ${widget.archivedTrackers.length} archived',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Active projects
            if (widget.activeTrackers.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Iconsax.chart_square, size: 20, color: colors.interactivePrimary),
                  const SizedBox(width: GOLSpacing.space2),
                  Text(
                    'Active Projects',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.activeTrackers.length}/20',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space3),
              ...widget.activeTrackers.map((tracker) {
                final stats = trackerStats[tracker.id] ?? const _TrackerStats();
                return Padding(
                  padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                  child: GestureDetector(
                    onLongPress: () => _showProjectOptions(tracker),
                    child: TrackerCard(
                      tracker: tracker,
                      onTap: () => context.push('/trackers/${tracker.id}'),
                      liveProfit: stats.totalProfit,
                      liveEntryCount: stats.entryCount,
                    ),
                  ),
                );
              }),
            ],

            // Archived projects
            if (widget.archivedTrackers.isNotEmpty) ...[
              const SizedBox(height: GOLSpacing.space6),
              Row(
                children: [
                  Icon(Iconsax.archive_1, size: 20, color: colors.textTertiary),
                  const SizedBox(width: GOLSpacing.space2),
                  Text(
                    'Archived',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space3),
              ...widget.archivedTrackers.map((tracker) {
                final stats = trackerStats[tracker.id] ?? const _TrackerStats();
                return Padding(
                  padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                  child: GestureDetector(
                    onLongPress: () => _showProjectOptions(tracker),
                    child: Opacity(
                      opacity: 0.7,
                      child: TrackerCard(
                        tracker: tracker,
                        onTap: () => context.push('/trackers/${tracker.id}'),
                        liveProfit: stats.totalProfit,
                        liveEntryCount: stats.entryCount,
                      ),
                    ),
                  ),
                );
              }),
            ],

            // Bottom padding for FAB
            const SizedBox(height: GOLSpacing.space11),
          ],
        ),
      ),
    );
  }
}
