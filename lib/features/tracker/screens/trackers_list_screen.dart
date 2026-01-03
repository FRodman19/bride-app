import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../providers/tracker_provider.dart';
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

class _TrackersListContent extends StatelessWidget {
  final List<dynamic> activeTrackers;
  final List<dynamic> archivedTrackers;

  const _TrackersListContent({
    required this.activeTrackers,
    required this.archivedTrackers,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

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
              '${activeTrackers.length} active, ${archivedTrackers.length} archived',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Active projects
            if (activeTrackers.isNotEmpty) ...[
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
                    '${activeTrackers.length}/20',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space3),
              ...activeTrackers.map((tracker) => Padding(
                    padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                    child: TrackerCard(
                      tracker: tracker,
                      onTap: () => context.push('/trackers/${tracker.id}'),
                    ),
                  )),
            ],

            // Archived projects
            if (archivedTrackers.isNotEmpty) ...[
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
              ...archivedTrackers.map((tracker) => Padding(
                    padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                    child: Opacity(
                      opacity: 0.7,
                      child: TrackerCard(
                        tracker: tracker,
                        onTap: () => context.push('/trackers/${tracker.id}'),
                      ),
                    ),
                  )),
            ],

            // Bottom padding for FAB
            const SizedBox(height: GOLSpacing.space11),
          ],
        ),
      ),
    );
  }
}
