import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/components/gol_loading_screen.dart';
import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/foundation/gol_radius.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../domain/models/tracker.dart';
import '../../../routing/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: switch (trackersState) {
          TrackersLoading() => GOLLoadingScreen(
              message: 'Loading your projects...',
              icon: Iconsax.folder_2,
              showRetryWhileLoading: false,
            ),
          TrackersError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.warning_2, size: 48, color: colors.stateError),
                  const SizedBox(height: GOLSpacing.space4),
                  Text(
                    l10n.errorLoadingProjects,
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
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),

          // Header - consistent with non-empty state
          Text(
            l10n.projects,
            style: textTheme.displaySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l10n.manageAllProjects,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: GOLSpacing.space6),

          // Empty state card with feature bullets
          EmptyState.dashboard(onCreateProject: onCreateProject, l10n: l10n),
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
    final l10n = AppLocalizations.of(context)!;

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
                            tracker.isArchived ? l10n.archived : l10n.active,
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
                            tracker.isArchived ? l10n.restoreProject : l10n.archiveProject,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            tracker.isArchived
                                ? l10n.moveToActive
                                : l10n.moveToArchive,
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
                            l10n.deleteProject,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.stateError,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.deleteProjectPermanently,
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
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(trackersProvider.notifier);

    if (tracker.isArchived) {
      final result = await notifier.restoreTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          l10n.projectRestored,
          variant: GOLToastVariant.success,
        );
      } else {
        showGOLToast(
          context,
          result.error ?? l10n.failedToRestoreProject,
          variant: GOLToastVariant.error,
        );
      }
    } else {
      final result = await notifier.archiveTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          l10n.projectArchived,
          variant: GOLToastVariant.success,
        );
      } else {
        showGOLToast(
          context,
          result.error ?? l10n.failedToArchiveProject,
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  void _showDeleteConfirmation(Tracker tracker) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.modal),
        ),
        title: Text(
          l10n.deleteProjectConfirmTitle,
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
              l10n.deleteProjectConfirmMessage(tracker.name),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          GOLButton(
            label: l10n.cancel,
            variant: GOLButtonVariant.secondary,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          GOLButton(
            label: l10n.delete,
            variant: GOLButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(dialogContext);

              final result = await ref.read(trackersProvider.notifier).deleteTracker(tracker.id);
              if (!mounted) return;

              if (result.success) {
                showGOLToast(
                  context,
                  l10n.projectDeleted,
                  variant: GOLToastVariant.success,
                );
              } else {
                showGOLToast(
                  context,
                  result.error ?? l10n.failedToDeleteProject,
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
    final l10n = AppLocalizations.of(context)!;

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
          totalProfit: revenue - spend - tracker.setupCost.round(),
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
        await ref.read(trackersProvider.notifier).loadTrackers();
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
              l10n.projectsHeading,
              style: textTheme.displaySmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.activeArchivedCount(
                widget.activeTrackers.length,
                widget.archivedTrackers.length,
              ),
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
                    l10n.activeProjects,
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
                    l10n.archived,
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
