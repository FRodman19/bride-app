import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../providers/tracker_provider.dart';
import '../../../routing/routes.dart';
import '../../shared/widgets/empty_state.dart';
import '../widgets/performance_overview_card.dart';
import '../widgets/tracker_card.dart';

/// Screen 1: Performance Dashboard
///
/// Shows aggregated performance metrics across all trackers.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

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
                    'Error loading trackers',
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
            _DashboardEmptyState(
              onCreateProject: () => context.push(Routes.createTracker),
            ),
          TrackersLoaded(:final trackers) => _DashboardContent(
              trackers: trackers,
            ),
        },
      ),
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

class _DashboardContent extends StatelessWidget {
  final List<dynamic> trackers;

  const _DashboardContent({required this.trackers});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Calculate aggregated metrics
    double totalProfit = 0;
    double totalRevenue = 0;
    double totalSpend = 0;

    for (final tracker in trackers) {
      if (!tracker.isArchived) {
        totalProfit += tracker.totalProfit;
        totalRevenue += tracker.totalRevenue;
        totalSpend += tracker.totalSpend;
      }
    }

    // Get active trackers sorted by profit
    final activeTrackers = trackers
        .where((t) => !t.isArchived)
        .toList()
      ..sort((a, b) => b.totalProfit.compareTo(a.totalProfit));

    // Top 3 and worst 3
    final topTrackers = activeTrackers.take(3).toList();
    final worstTrackers = activeTrackers.length > 3
        ? activeTrackers.reversed.take(3).toList()
        : <dynamic>[];

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refresh via provider
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GOLSpacing.space4),

            // Header with design system button (dev only)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: textTheme.displaySmall?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${activeTrackers.length} active project${activeTrackers.length == 1 ? '' : 's'}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Dev only - Design System Gallery button
                IconButton(
                  onPressed: () => context.push(Routes.designSystemGallery),
                  icon: Icon(Iconsax.color_swatch, color: colors.textSecondary),
                  tooltip: 'Design System Gallery',
                ),
              ],
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Performance overview card
            PerformanceOverviewCard(
              totalProfit: totalProfit,
              totalRevenue: totalRevenue,
              totalSpend: totalSpend,
            ),

            const SizedBox(height: GOLSpacing.space6),

            // Top performing trackers
            if (topTrackers.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Iconsax.trend_up, size: 20, color: colors.stateSuccess),
                  const SizedBox(width: GOLSpacing.space2),
                  Text(
                    'Top Performers',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space3),
              ...topTrackers.map((tracker) => Padding(
                    padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                    child: TrackerCard(
                      tracker: tracker,
                      onTap: () => context.push('/trackers/${tracker.id}'),
                    ),
                  )),
            ],

            // Worst performing trackers
            if (worstTrackers.isNotEmpty) ...[
              const SizedBox(height: GOLSpacing.space4),
              Row(
                children: [
                  Icon(Iconsax.trend_down, size: 20, color: colors.stateError),
                  const SizedBox(width: GOLSpacing.space2),
                  Text(
                    'Needs Attention',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space3),
              ...worstTrackers.map((tracker) => Padding(
                    padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                    child: TrackerCard(
                      tracker: tracker,
                      onTap: () => context.push('/trackers/${tracker.id}'),
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

class _DashboardEmptyState extends StatelessWidget {
  final VoidCallback onCreateProject;

  const _DashboardEmptyState({required this.onCreateProject});

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

          // Header with design system button (dev only)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: textTheme.displaySmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track your project performance',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Dev only - Design System Gallery button
              IconButton(
                onPressed: () => context.push(Routes.designSystemGallery),
                icon: Icon(Iconsax.color_swatch, color: colors.textSecondary),
                tooltip: 'Design System Gallery',
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space6),

          // Empty state card with feature bullets
          EmptyState.dashboard(onCreateProject: onCreateProject),
        ],
      ),
    );
  }
}
