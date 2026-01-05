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
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../domain/models/tracker.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/platform_icons.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../providers/post_provider.dart';
import '../../../providers/reports_provider.dart';
import '../../../routing/routes.dart';
import '../../../services/export_service.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Screen 3: Project Hub - Overview Tab
///
/// Central hub for a single project showing stats, entries, and posts.
class TrackerHubScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const TrackerHubScreen({super.key, required this.trackerId});

  @override
  ConsumerState<TrackerHubScreen> createState() => _TrackerHubScreenState();
}

class _TrackerHubScreenState extends ConsumerState<TrackerHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final trackersState = ref.watch(trackersProvider);

    // Find the tracker by ID
    Tracker? tracker;
    if (trackersState is TrackersLoaded) {
      tracker = trackersState.trackers.cast<Tracker?>().firstWhere(
            (t) => t?.id == widget.trackerId,
            orElse: () => null,
          );
    }

    final l10n = AppLocalizations.of(context)!;

    if (tracker == null) {
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
              Icon(Iconsax.folder_cross, size: 48, color: colors.textTertiary),
              const SizedBox(height: GOLSpacing.space4),
              Text(
                l10n.projectNotFound,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
                onPressed: () => context.pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tracker!.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    l10n.projectStartedOn(
                      DateFormat('MMM d, yyyy', l10n.localeName).format(tracker.startDate),
                    ),
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Iconsax.more, color: colors.textPrimary),
                  onPressed: () => _showActionsMenu(context, tracker!),
                ),
              ],
              backgroundColor: colors.surfaceDefault,
              elevation: 0,
              floating: true,
              pinned: true,
              bottom: TabBar(
                controller: _tabController,
                labelColor: colors.interactivePrimary,
                unselectedLabelColor: colors.textSecondary,
                indicatorColor: colors.interactivePrimary,
                labelStyle: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: textTheme.labelLarge,
                tabs: [
                  Tab(text: l10n.overview),
                  Tab(text: l10n.entries),
                  Tab(text: l10n.reports),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(tracker: tracker),
            _EntriesTab(tracker: tracker),
            _ReportsTab(tracker: tracker),
          ],
        ),
      ),
      // Hide FAB when project is archived (read-only mode)
      floatingActionButton: tracker!.isArchived
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(Routes.logEntryPath(tracker!.id)),
              backgroundColor: colors.interactivePrimary,
              icon: Icon(Iconsax.add, color: colors.textInverse),
              label: Text(
                l10n.logEntry,
                style: textTheme.labelLarge?.copyWith(
                  color: colors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  void _showActionsMenu(BuildContext context, Tracker tracker) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceDefault,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: GOLSpacing.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle indicator
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderDefault,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: GOLSpacing.space4),

                // Actions - Edit only available when not archived
                if (!tracker.isArchived)
                  ListTile(
                    leading: Icon(Iconsax.edit_2, color: colors.textPrimary),
                    title: Text(
                      l10n.editProject,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(Routes.editTrackerPath(tracker.id));
                    },
                  ),
                ListTile(
                  leading: Icon(Iconsax.archive_1, color: colors.textPrimary),
                  title: Text(
                    tracker.isArchived ? l10n.restoreProject : l10n.archiveProject,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleArchiveRestore(tracker);
                  },
                ),
                ListTile(
                  leading: Icon(Iconsax.export_1, color: colors.textPrimary),
                  title: Text(
                    l10n.exportData,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _tabController.animateTo(2); // Switch to Reports tab for export
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Iconsax.trash, color: colors.stateError),
                  title: Text(
                    l10n.deleteProject,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.stateError,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(tracker);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleArchiveRestore(Tracker tracker) async {
    final notifier = ref.read(trackersProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    if (tracker.isArchived) {
      // Restore
      final result = await notifier.restoreTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          l10n.nameRestored(tracker.name),
          variant: GOLToastVariant.success,
        );
      } else {
        showGOLToast(
          context,
          result.error ?? l10n.failedToRestore,
          variant: GOLToastVariant.error,
        );
      }
    } else {
      // Archive
      final result = await notifier.archiveTracker(tracker.id);
      if (!mounted) return;

      if (result.success) {
        showGOLToast(
          context,
          l10n.nameArchived(tracker.name),
          variant: GOLToastVariant.success,
        );
        context.go(Routes.dashboard);
      } else {
        showGOLToast(
          context,
          result.error ?? l10n.failedToArchive,
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
        title: Text(l10n.deleteTrackerTitle),
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
              l10n.deleteTrackerMessage,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            _buildDeleteInfoItem(l10n.allDailyEntries, colors, textTheme),
            _buildDeleteInfoItem(l10n.allPosts, colors, textTheme),
            _buildDeleteInfoItem(l10n.allReportsData, colors, textTheme),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              l10n.actionCannotBeUndone,
              style: textTheme.bodySmall?.copyWith(
                color: colors.stateError,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          GOLButton(
            label: l10n.cancel,
            variant: GOLButtonVariant.tertiary,
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
                  l10n.trackerDeleted(tracker.name),
                  variant: GOLToastVariant.success,
                );
                context.go(Routes.dashboard);
              } else {
                showGOLToast(
                  context,
                  result.error ?? l10n.failedToDelete,
                  variant: GOLToastVariant.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteInfoItem(String text, GOLSemanticColors colors, TextTheme textTheme) {
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

/// Overview Tab - Screen 3 main content
///
/// Now watches entries provider to show real-time calculated stats.
class _OverviewTab extends ConsumerWidget {
  final Tracker tracker;

  const _OverviewTab({required this.tracker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Watch entries for real-time stats
    final entriesState = ref.watch(entriesProvider(tracker.id));

    // Calculate stats from entries
    List<Entry> entries = [];
    int entryCount = 0;
    int totalRevenue = 0;
    int totalSpend = 0;
    int totalProfit = 0;
    int totalDmsLeads = 0;

    if (entriesState is EntriesLoaded) {
      entries = entriesState.entries;
      entryCount = entries.length;
      for (final entry in entries) {
        totalRevenue += entry.totalRevenue;
        totalSpend += entry.totalSpend;
        totalDmsLeads += entry.totalDmsLeads;
      }
      totalProfit = totalRevenue - totalSpend;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),

          // Performance card - now with live data
          _PerformanceCard(
            tracker: tracker,
            totalRevenue: totalRevenue,
            totalSpend: totalSpend,
            totalProfit: totalProfit,
          ),

          const SizedBox(height: GOLSpacing.space5),

          // Key Metrics Grid (2x2) - now with live data
          _MetricsGrid(
            tracker: tracker,
            entryCount: entryCount,
            totalDmsLeads: totalDmsLeads,
            entries: entries,
          ),

          const SizedBox(height: GOLSpacing.space5),

          // Platforms section - now with actual icons
          if (tracker.platforms.isNotEmpty) ...[
            _SectionHeader(
              title: l10n.platforms,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Wrap(
              spacing: GOLSpacing.space2,
              runSpacing: GOLSpacing.space2,
              children: tracker.platforms.map((platform) {
                return Chip(
                  label: Text(platform),
                  avatar: SizedBox(
                    width: 18,
                    height: 18,
                    child: PlatformIcons.getIcon(
                      platform,
                      size: 16,
                      color: colors.interactivePrimary,
                    ),
                  ),
                  backgroundColor: colors.surfaceRaised,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: GOLSpacing.space5),
          ],

          // Recent Entries section
          _SectionHeader(
            title: l10n.recentEntries,
            trailing: entryCount > 0
                ? TextButton(
                    onPressed: () {
                      // Switch to entries tab
                    },
                    child: Text(
                      l10n.viewAll,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.interactivePrimary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: GOLSpacing.space3),

          if (entryCount == 0)
            _EmptySection(
              icon: Iconsax.calendar_tick,
              title: l10n.noEntriesYetShort,
              subtitle: l10n.logFirstEntryToStart,
            )
          else
            // Show recent entries from live data
            Column(
              children: entries.take(3).map((entry) {
                final isProfit = entry.profit >= 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
                  child: GOLCard(
                    variant: GOLCardVariant.standard,
                    padding: const EdgeInsets.all(GOLSpacing.space3),
                    child: InkWell(
                      onTap: () => context.push(Routes.entryDetailPath(tracker.id, entry.id)),
                      child: Row(
                        children: [
                          Text(
                            DateFormat("MMM d", l10n.localeName).format(entry.entryDate),
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                            size: 14,
                            color: isProfit ? colors.textPrimary : colors.stateError,
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Text(
                            CurrencyFormatter.format(entry.profit, currencyCode: tracker.currency),
                            style: textTheme.bodyMedium?.copyWith(
                              color: isProfit ? colors.textPrimary : colors.stateError,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          if (entryCount > 3) ...[
            const SizedBox(height: GOLSpacing.space2),
            Center(
              child: Text(
                l10n.moreEntriesInTab(entryCount - 3),
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],

          const SizedBox(height: GOLSpacing.space5),

          // Goals section (if any)
          if (tracker.goalTypes.isNotEmpty) ...[
            _SectionHeader(
              title: l10n.goals,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Wrap(
              spacing: GOLSpacing.space2,
              runSpacing: GOLSpacing.space2,
              children: tracker.goalTypes.map((goal) {
                return Chip(
                  label: Text(goal),
                  backgroundColor: colors.accentSubtle,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: GOLSpacing.space5),
          ],

          // Targets section
          if (tracker.revenueTarget != null ||
              tracker.engagementTarget != null) ...[
            _SectionHeader(
              title: l10n.targets,
            ),
            const SizedBox(height: GOLSpacing.space3),
            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Column(
                children: [
                  if (tracker.revenueTarget != null)
                    _TargetRow(
                      label: l10n.revenueTarget,
                      value: CurrencyFormatter.format(
                        tracker.revenueTarget!.round(),
                        currencyCode: tracker.currency,
                      ),
                      current: totalRevenue.toDouble(),
                      target: tracker.revenueTarget!,
                    ),
                  if (tracker.revenueTarget != null &&
                      tracker.engagementTarget != null)
                    const SizedBox(height: GOLSpacing.space3),
                  if (tracker.engagementTarget != null)
                    _TargetRow(
                      label: l10n.engagementTarget,
                      value: '${tracker.engagementTarget} ${l10n.dmsLeads}',
                      current: totalDmsLeads.toDouble(),
                      target: tracker.engagementTarget!.toDouble(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: GOLSpacing.space5),
          ],

          // Notes section
          if (tracker.notes != null && tracker.notes!.isNotEmpty) ...[
            _SectionHeader(
              title: l10n.notes,
            ),
            const SizedBox(height: GOLSpacing.space3),
            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Text(
                tracker.notes!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: GOLSpacing.space5),
          ],

          // Posts section (Optional)
          _PostsSection(tracker: tracker),

          // Bottom padding for FAB
          const SizedBox(height: GOLSpacing.space11),
        ],
      ),
    );
  }

}

/// Performance card showing profit, revenue, and spend
class _PerformanceCard extends StatelessWidget {
  final Tracker tracker;
  final int totalRevenue;
  final int totalSpend;
  final int totalProfit;

  const _PerformanceCard({
    required this.tracker,
    required this.totalRevenue,
    required this.totalSpend,
    required this.totalProfit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final isProfit = totalProfit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPaddingSpacious),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with badge
          Row(
            children: [
              Icon(Iconsax.chart_2, size: 20, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                l10n.performance,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textPrimary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: tracker.isArchived
                      ? colors.surfaceRaised
                      : colors.stateSuccess.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: tracker.isArchived
                            ? colors.textTertiary
                            : colors.stateSuccess,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: GOLSpacing.space1),
                    Text(
                      tracker.isArchived ? l10n.archived : l10n.active,
                      style: textTheme.labelSmall?.copyWith(
                        color: tracker.isArchived
                            ? colors.textTertiary
                            : colors.stateSuccess,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space4),

          // Net profit
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
                    CurrencyFormatter.format(
                      totalProfit,
                      currencyCode: tracker.currency,
                    ),
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
            isProfit ? l10n.netProfit : l10n.netLoss,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),

          const SizedBox(height: GOLSpacing.space4),

          // Revenue and Spend
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _MetricColumn(
                    label: l10n.revenue,
                    value: CurrencyFormatter.format(
                      totalRevenue,
                      currencyCode: tracker.currency,
                    ),
                    icon: Iconsax.wallet_add,
                  ),
                ),
                Container(
                  width: 1,
                  color: colors.borderDefault,
                  margin: const EdgeInsets.symmetric(
                    horizontal: GOLSpacing.space3,
                  ),
                ),
                Expanded(
                  child: _MetricColumn(
                    label: l10n.spend,
                    value: CurrencyFormatter.format(
                      totalSpend,
                      currencyCode: tracker.currency,
                    ),
                    icon: Iconsax.wallet_minus,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricColumn({
    required this.label,
    required this.value,
    required this.icon,
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
            Icon(icon, size: 16, color: colors.interactivePrimary),
            const SizedBox(width: GOLSpacing.space1),
            Text(
              label.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: colors.textPrimary,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
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
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 2x2 metrics grid
class _MetricsGrid extends StatelessWidget {
  final Tracker tracker;
  final int entryCount;
  final int totalDmsLeads;
  final List<Entry> entries;

  const _MetricsGrid({
    required this.tracker,
    required this.entryCount,
    required this.totalDmsLeads,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysSinceStart =
        DateTime.now().difference(tracker.startDate).inDays + 1;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _MetricCard(
                icon: Iconsax.calendar_tick,
                label: l10n.daysActive,
                value: '$daysSinceStart',
                subtitle: l10n.sinceStart,
                subtitleStyle: _MetricSubtitleStyle.plain,
              ),
              const SizedBox(height: GOLSpacing.space3),
              _MetricCard(
                icon: Iconsax.document_text,
                label: l10n.entries,
                value: '$entryCount',
                subtitle: l10n.logged,
                subtitleStyle: _MetricSubtitleStyle.plain,
              ),
            ],
          ),
        ),
        const SizedBox(width: GOLSpacing.space3),
        Expanded(
          child: Column(
            children: [
              _MetricCard(
                icon: Iconsax.wallet_1,
                label: l10n.setupCost,
                value: CurrencyFormatter.format(
                  tracker.setupCost.round(),
                  currencyCode: tracker.currency,
                ),
              ),
              const SizedBox(height: GOLSpacing.space3),
              _MetricCard(
                icon: Iconsax.chart_1,
                label: l10n.monthlyCost,
                value: CurrencyFormatter.format(
                  tracker.growthCostMonthly.round(),
                  currencyCode: tracker.currency,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _MetricSubtitleStyle { plain, badge }

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final _MetricSubtitleStyle subtitleStyle;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.subtitleStyle = _MetricSubtitleStyle.badge,
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
              Icon(icon, size: 16, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space1),
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textPrimary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: GOLSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Only show subtitle if provided
              if (subtitle != null) ...[
                const SizedBox(width: GOLSpacing.space1),
                if (subtitleStyle == _MetricSubtitleStyle.badge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GOLSpacing.space1,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.interactivePrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      subtitle!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.interactivePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      subtitle!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptySection({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.symmetric(
        horizontal: GOLSpacing.cardPadding,
        vertical: GOLSpacing.space5,
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: colors.textTertiary),
            ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space1),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  final String label;
  final String value;
  final double current;
  final double target;

  const _TargetRow({
    required this.label,
    required this.value,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              '$percentage%',
              style: textTheme.labelMedium?.copyWith(
                color: colors.interactivePrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.surfaceRaised,
            valueColor: AlwaysStoppedAnimation(colors.interactivePrimary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: GOLSpacing.space1),
        Text(
          'Target: $value',
          style: textTheme.labelSmall?.copyWith(
            color: colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Entries Tab - Screen 4 Daily Entries Tab
///
/// Shows summary stats, filter pills, and entry list grouped by date.
class _EntriesTab extends ConsumerStatefulWidget {
  final Tracker tracker;

  const _EntriesTab({required this.tracker});

  @override
  ConsumerState<_EntriesTab> createState() => _EntriesTabState();
}

enum _EntryFilter { thisWeek, thisMonth, allTime }

class _EntriesTabState extends ConsumerState<_EntriesTab> {
  _EntryFilter _selectedFilter = _EntryFilter.thisMonth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final entriesState = ref.watch(entriesProvider(widget.tracker.id));
    final l10n = AppLocalizations.of(context)!;

    // Loading state
    if (entriesState is EntriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (entriesState is EntriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 48, color: colors.stateError),
            const SizedBox(height: GOLSpacing.space4),
            Text(
              l10n.failedToLoadEntries,
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              entriesState.message,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final loadedState = entriesState as EntriesLoaded;
    final allEntries = loadedState.entries;

    // Empty state
    if (allEntries.isEmpty) {
      return _buildEmptyState(context);
    }

    // Filter entries based on selection
    final filteredEntries = _filterEntries(allEntries);

    // Calculate summary stats for filtered entries
    final summaryStats = _calculateSummaryStats(filteredEntries);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),

          // Summary Card
          _buildSummaryCard(context, summaryStats),

          const SizedBox(height: GOLSpacing.space5),

          // Filter Pills
          _buildFilterPills(context),

          const SizedBox(height: GOLSpacing.space5),

          // Entries list grouped by date
          if (filteredEntries.isEmpty)
            _buildNoEntriesForFilter(context)
          else
            _buildEntriesList(context, filteredEntries),

          // Bottom padding for FAB
          const SizedBox(height: GOLSpacing.space11),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.edit_2,
                size: 36,
                color: colors.textTertiary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space5),

            // Title
            Text(
              l10n.noEntriesYetTitle,
              style: textTheme.headlineSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),

            // Description
            Text(
              l10n.dailyEntriesDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space4),

            // What each entry logs
            Container(
              padding: const EdgeInsets.all(GOLSpacing.space4),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(GOLRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.eachEntryLogs,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _buildBulletPoint(context, l10n.totalRevenueForDay),
                  _buildBulletPoint(context, l10n.adSpendPerPlatform),
                  _buildBulletPoint(context, l10n.dmsLeadsReceived),
                  _buildBulletPoint(context, l10n.dailyProfitCalculated),
                ],
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Secondary message
            Text(
              l10n.startTrackingToSee,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space5),

            // CTA Button
            GOLButton(
              label: l10n.logFirstEntry,
              icon: const Icon(Iconsax.add),
              onPressed: () =>
                  context.push(Routes.logEntryPath(widget.tracker.id)),
              size: GOLButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GOLSpacing.space1),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(right: GOLSpacing.space2),
            decoration: BoxDecoration(
              color: colors.interactivePrimary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, _EntrySummaryStats stats) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final isProfit = stats.totalProfit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Iconsax.chart_2, size: 18, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                '${l10n.summary} (${_getFilterLabel(l10n)})',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space4),

          // Stats Grid (2 rows of stats)
          Row(
            children: [
              Expanded(
                child: _SummaryStatItem(
                  label: l10n.totalEntries,
                  value: '${stats.totalEntries}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.borderDefault,
                margin: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space3,
                ),
              ),
              Expanded(
                child: _SummaryStatItem(
                  label: l10n.totalProfit,
                  value: CurrencyFormatter.format(
                    stats.totalProfit.round(),
                    currencyCode: widget.tracker.currency,
                  ),
                  valueColor: profitColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space3),
          const GOLDivider(),
          const SizedBox(height: GOLSpacing.space3),

          Row(
            children: [
              Expanded(
                child: _SummaryStatItem(
                  label: l10n.avgDailyProfit,
                  value: CurrencyFormatter.format(
                    stats.avgDailyProfit.round(),
                    currencyCode: widget.tracker.currency,
                  ),
                  valueColor: stats.avgDailyProfit >= 0
                      ? colors.textPrimary
                      : colors.stateError,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.borderDefault,
                margin: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space3,
                ),
              ),
              Expanded(
                child: _SummaryStatItem(
                  label: l10n.totalDmsLeads,
                  value: '${stats.totalDmsLeads}',
                ),
              ),
            ],
          ),

          // Best and Worst Days
          if (stats.bestDay != null || stats.worstDay != null) ...[
            const SizedBox(height: GOLSpacing.space3),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space3),
            if (stats.bestDay != null)
              _BestWorstDayRow(
                label: l10n.bestDay,
                date: stats.bestDay!.date,
                profit: stats.bestDay!.profit,
                currency: widget.tracker.currency,
                isPositive: true,
              ),
            if (stats.bestDay != null && stats.worstDay != null)
              const SizedBox(height: GOLSpacing.space2),
            if (stats.worstDay != null)
              _BestWorstDayRow(
                label: l10n.worstDay,
                date: stats.worstDay!.date,
                profit: stats.worstDay!.profit,
                currency: widget.tracker.currency,
                isPositive: false,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterPills(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterPill(
                  label: l10n.thisWeek,
                  isSelected: _selectedFilter == _EntryFilter.thisWeek,
                  onTap: () => setState(() => _selectedFilter = _EntryFilter.thisWeek),
                ),
                const SizedBox(width: GOLSpacing.space2),
                _FilterPill(
                  label: l10n.thisMonth,
                  isSelected: _selectedFilter == _EntryFilter.thisMonth,
                  onTap: () => setState(() => _selectedFilter = _EntryFilter.thisMonth),
                ),
                const SizedBox(width: GOLSpacing.space2),
                _FilterPill(
                  label: l10n.allTime,
                  isSelected: _selectedFilter == _EntryFilter.allTime,
                  onTap: () => setState(() => _selectedFilter = _EntryFilter.allTime),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: GOLSpacing.space2),
        // View History button
        TextButton.icon(
          onPressed: () =>
              context.push(Routes.entryHistoryPath(widget.tracker.id)),
          icon: Icon(Iconsax.clock, size: 16, color: colors.interactivePrimary),
          label: Text(
            l10n.history,
            style: textTheme.labelMedium?.copyWith(
              color: colors.interactivePrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoEntriesForFilter(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: GOLSpacing.space6),
        child: Column(
          children: [
            Icon(
              Iconsax.calendar_remove,
              size: 48,
              color: colors.textTertiary,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              '${l10n.noEntriesFor} ${_getFilterLabel(l10n).toLowerCase()}',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context, List<Entry> entries) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Group entries by relative date section
    final groupedEntries = _groupEntriesBySection(entries);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedEntries.entries.map((group) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Text(
              group.key,
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),
            // Entries in this section
            ...group.value.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                  child: _EntryCard(
                    entry: entry,
                    tracker: widget.tracker,
                    onTap: () => context.push(
                      Routes.entryDetailPath(widget.tracker.id, entry.id),
                    ),
                  ),
                )),
            const SizedBox(height: GOLSpacing.space4),
          ],
        );
      }).toList(),
    );
  }

  List<Entry> _filterEntries(List<Entry> entries) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedFilter) {
      case _EntryFilter.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return entries
            .where((e) =>
                e.entryDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) ||
                _isSameDay(e.entryDate, startOfWeek))
            .toList();
      case _EntryFilter.thisMonth:
        return entries
            .where((e) =>
                e.entryDate.year == now.year && e.entryDate.month == now.month)
            .toList();
      case _EntryFilter.allTime:
        return entries;
    }
  }

  Map<String, List<Entry>> _groupEntriesBySection(List<Entry> entries) {
    final Map<String, List<Entry>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));
    final l10n = AppLocalizations.of(context)!;

    for (final entry in entries) {
      String section;
      final entryDate = DateTime(
        entry.entryDate.year,
        entry.entryDate.month,
        entry.entryDate.day,
      );

      if (_isSameDay(entryDate, today)) {
        section = l10n.todaySection;
      } else if (_isSameDay(entryDate, today.subtract(const Duration(days: 1)))) {
        section = l10n.yesterdaySection;
      } else if (entryDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
        section = l10n.thisWeekSection;
      } else if (entryDate.isAfter(startOfLastWeek.subtract(const Duration(days: 1)))) {
        section = l10n.lastWeekSection;
      } else if (entryDate.year == now.year && entryDate.month == now.month) {
        section = l10n.thisMonthSection;
      } else {
        section = DateFormat('MMMM yyyy', l10n.localeName).format(entryDate).toUpperCase();
      }

      grouped.putIfAbsent(section, () => []);
      grouped[section]!.add(entry);
    }

    // Sort entries within each group by date (most recent first)
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    }

    return grouped;
  }

  _EntrySummaryStats _calculateSummaryStats(List<Entry> entries) {
    if (entries.isEmpty) {
      return _EntrySummaryStats(
        totalEntries: 0,
        totalProfit: 0,
        avgDailyProfit: 0,
        totalDmsLeads: 0,
        bestDay: null,
        worstDay: null,
      );
    }

    int totalRevenue = 0;
    int totalSpend = 0;
    int totalDmsLeads = 0;
    Entry? bestEntry;
    Entry? worstEntry;

    for (final entry in entries) {
      totalRevenue += entry.totalRevenue;
      totalSpend += entry.totalSpend;
      totalDmsLeads += entry.totalDmsLeads;

      if (bestEntry == null || entry.profit > bestEntry.profit) {
        bestEntry = entry;
      }
      if (worstEntry == null || entry.profit < worstEntry.profit) {
        worstEntry = entry;
      }
    }

    final totalProfit = totalRevenue - totalSpend;
    final avgDailyProfit = entries.isNotEmpty
        ? totalProfit / entries.length
        : 0.0;

    return _EntrySummaryStats(
      totalEntries: entries.length,
      totalProfit: totalProfit,
      avgDailyProfit: avgDailyProfit,
      totalDmsLeads: totalDmsLeads,
      bestDay: bestEntry != null
          ? _DayProfit(bestEntry.entryDate, bestEntry.profit)
          : null,
      worstDay: worstEntry != null
          ? _DayProfit(worstEntry.entryDate, worstEntry.profit)
          : null,
    );
  }

  String _getFilterLabel([AppLocalizations? l10n]) {
    final localization = l10n ?? AppLocalizations.of(context)!;
    switch (_selectedFilter) {
      case _EntryFilter.thisWeek:
        return localization.thisWeek;
      case _EntryFilter.thisMonth:
        return localization.thisMonth;
      case _EntryFilter.allTime:
        return localization.allTime;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _EntrySummaryStats {
  final int totalEntries;
  final int totalProfit;
  final double avgDailyProfit;
  final int totalDmsLeads;
  final _DayProfit? bestDay;
  final _DayProfit? worstDay;

  _EntrySummaryStats({
    required this.totalEntries,
    required this.totalProfit,
    required this.avgDailyProfit,
    required this.totalDmsLeads,
    this.bestDay,
    this.worstDay,
  });
}

class _DayProfit {
  final DateTime date;
  final int profit;

  _DayProfit(this.date, this.profit);
}

class _SummaryStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryStatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.textTertiary,
          ),
        ),
        const SizedBox(height: GOLSpacing.space1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: valueColor ?? colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BestWorstDayRow extends StatelessWidget {
  final String label;
  final DateTime date;
  final int profit;
  final String currency;
  final bool isPositive;

  const _BestWorstDayRow({
    required this.label,
    required this.date,
    required this.profit,
    required this.currency,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          isPositive ? Iconsax.trend_up : Iconsax.trend_down,
          size: 16,
          color: isPositive ? colors.textPrimary : colors.stateError,
        ),
        const SizedBox(width: GOLSpacing.space2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(width: GOLSpacing.space2),
        Text(
          DateFormat("MMM d", l10n.localeName).format(date),
          style: textTheme.bodySmall?.copyWith(
            color: colors.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          CurrencyFormatter.format(profit, currencyCode: currency),
          style: textTheme.labelMedium?.copyWith(
            color: isPositive ? colors.textPrimary : colors.stateError,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected ? colors.interactivePrimary : colors.surfaceRaised,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GOLSpacing.space3,
            vertical: GOLSpacing.space2,
          ),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: isSelected ? colors.textInverse : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Entry card showing daily entry summary
class _EntryCard extends StatelessWidget {
  final Entry entry;
  final Tracker tracker;
  final VoidCallback onTap;

  const _EntryCard({
    required this.entry,
    required this.tracker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final isProfit = entry.profit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(GOLSpacing.cardPadding),
            child: Row(
              children: [
                // Date column
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d', l10n.localeName).format(entry.entryDate),
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM', l10n.localeName).format(entry.entryDate),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: GOLSpacing.space3),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profit row
                      Row(
                        children: [
                          Icon(
                            isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                            size: 16,
                            color: profitColor,
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Flexible(
                            child: Text(
                              CurrencyFormatter.format(
                                entry.profit,
                                currencyCode: tracker.currency,
                              ),
                              style: textTheme.titleSmall?.copyWith(
                                color: profitColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Text(
                            isProfit ? l10n.profit : l10n.loss,
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GOLSpacing.space1),
                      // Revenue and Spend - use Flexible to prevent overflow
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${l10n.revenue}: ${CurrencyFormatter.format(entry.totalRevenue, currencyCode: tracker.currency)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 12,
                            margin: const EdgeInsets.symmetric(
                              horizontal: GOLSpacing.space2,
                            ),
                            color: colors.borderDefault,
                          ),
                          Flexible(
                            child: Text(
                              '${l10n.spend}: ${CurrencyFormatter.format(entry.totalSpend, currencyCode: tracker.currency)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // DMs badge
                if (entry.totalDmsLeads > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GOLSpacing.space2,
                      vertical: GOLSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accentSubtle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.message_text,
                          size: 12,
                          color: colors.interactivePrimary,
                        ),
                        const SizedBox(width: GOLSpacing.space1),
                        Text(
                          '${entry.totalDmsLeads}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.interactivePrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(width: GOLSpacing.space2),

                // Chevron
                Icon(
                  Iconsax.arrow_right_3,
                  size: 16,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reports Tab - Screen 5: Performance reports
class _ReportsTab extends ConsumerWidget {
  final Tracker tracker;

  const _ReportsTab({required this.tracker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final selectedPeriod = ref.watch(selectedReportPeriodProvider);

    final reportsData = ref.watch(reportsProvider((
      trackerId: tracker.id,
      tracker: tracker,
      period: selectedPeriod,
    )));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Period Selector
          _TimePeriodSelector(
            selectedPeriod: selectedPeriod,
            onPeriodChanged: (period) {
              ref.read(selectedReportPeriodProvider.notifier).state = period;
            },
          ),
          const SizedBox(height: GOLSpacing.space4),

          // Period Label
          Text(
            _getPeriodLabel(l10n, selectedPeriod, reportsData),
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),

          // Show empty state if no data
          if (!reportsData.hasData) ...[
            _ReportsEmptyState(tracker: tracker),
          ] else ...[
            // Total Profit/Loss Card
            _TotalProfitCard(
              reportsData: reportsData,
              currency: tracker.currency,
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Revenue vs Spend Breakdown
            if (reportsData.weeklyBreakdown.isNotEmpty) ...[
              _RevenueSpendBreakdownCard(
                weeklyBreakdown: reportsData.weeklyBreakdown,
                currency: tracker.currency,
              ),
              const SizedBox(height: GOLSpacing.space4),
            ],

            // Worst Performing Days
            if (reportsData.worstDays.isNotEmpty) ...[
              _WorstPerformingDaysCard(
                worstDays: reportsData.worstDays,
                currency: tracker.currency,
              ),
              const SizedBox(height: GOLSpacing.space4),
            ],

            // Burn Rate Card
            _BurnRateCard(
              reportsData: reportsData,
              currency: tracker.currency,
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Cumulative Profit Trend
            if (reportsData.cumulativeProfitTrend.isNotEmpty) ...[
              _CumulativeProfitCard(
                reportsData: reportsData,
                currency: tracker.currency,
              ),
              const SizedBox(height: GOLSpacing.space4),
            ],

            // Export Button
            _ExportButton(tracker: tracker, reportsData: reportsData),
          ],

          const SizedBox(height: GOLSpacing.space8),
        ],
      ),
    );
  }

  String _getPeriodLabel(
    AppLocalizations l10n,
    ReportPeriod period,
    ReportsData data,
  ) {
    final now = DateTime.now();
    switch (period) {
      case ReportPeriod.daily:
        return l10n.dailyReportLabel(
          DateFormat('MMMM d, yyyy', l10n.localeName).format(now),
        );
      case ReportPeriod.weekly:
        return l10n.weeklyReportRange(
          DateFormat('MMM d', l10n.localeName).format(data.periodStart),
          DateFormat('MMM d', l10n.localeName).format(data.periodEnd),
        );
      case ReportPeriod.monthly:
        return l10n.monthlyReportLabel(
          DateFormat('MMMM yyyy', l10n.localeName).format(now),
        );
    }
  }
}

/// Time period selector pills
class _TimePeriodSelector extends StatelessWidget {
  final ReportPeriod selectedPeriod;
  final ValueChanged<ReportPeriod> onPeriodChanged;

  const _TimePeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _PeriodPill(
          label: l10n.daily,
          isSelected: selectedPeriod == ReportPeriod.daily,
          onTap: () => onPeriodChanged(ReportPeriod.daily),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _PeriodPill(
          label: l10n.weekly,
          isSelected: selectedPeriod == ReportPeriod.weekly,
          onTap: () => onPeriodChanged(ReportPeriod.weekly),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _PeriodPill(
          label: l10n.monthly,
          isSelected: selectedPeriod == ReportPeriod.monthly,
          onTap: () => onPeriodChanged(ReportPeriod.monthly),
        ),
      ],
    );
  }
}

class _PeriodPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.space4,
          vertical: GOLSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.interactivePrimary : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(GOLRadius.full),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colors.textInverse : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Empty state for reports
class _ReportsEmptyState extends StatelessWidget {
  final Tracker tracker;

  const _ReportsEmptyState({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: GOLSpacing.space8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.chart_2,
                size: 32,
                color: colors.textTertiary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),
            Text(
              l10n.noDataYet,
              style: textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              l10n.logFirstEntryForReports,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Total Profit/Loss Card
class _TotalProfitCard extends StatelessWidget {
  final ReportsData reportsData;
  final String currency;

  const _TotalProfitCard({
    required this.reportsData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final profitResult = CurrencyFormatter.formatProfit(
      reportsData.netProfit,
      currencyCode: currency,
    );

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.chart,
                  size: 20,
                  color: colors.interactivePrimary,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.totalProfitLoss,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space3),

            // Net Profit
            Text(
              profitResult.formatted,
              style: textTheme.displaySmall?.copyWith(
                color: profitResult.isProfit
                    ? colors.textPrimary
                    : colors.stateError,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),

            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space3),

            // Breakdown
            _BreakdownRow(
              label: l10n.totalRevenue,
              value: CurrencyFormatter.format(
                reportsData.totalRevenue,
                currencyCode: currency,
              ),
              valueColor: colors.textPrimary,
            ),
            const SizedBox(height: GOLSpacing.space2),
            _BreakdownRow(
              label: l10n.totalSpend,
              value: '-${CurrencyFormatter.format(
                reportsData.totalSpend,
                currencyCode: currency,
              )}',
              valueColor: colors.stateError,
            ),
            if (reportsData.setupCost > 0) ...[
              const SizedBox(height: GOLSpacing.space2),
              _BreakdownRow(
                label: l10n.setupCosts,
                value: '-${CurrencyFormatter.format(
                  reportsData.setupCost,
                  currencyCode: currency,
                )}',
                valueColor: colors.stateError,
              ),
            ],
            const SizedBox(height: GOLSpacing.space2),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space2),
            _BreakdownRow(
              label: l10n.finalProfitLabel,
              value: profitResult.formatted,
              valueColor: profitResult.isProfit
                  ? colors.textPrimary
                  : colors.stateError,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: GOLSpacing.space2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Revenue vs Spend Breakdown Card
class _RevenueSpendBreakdownCard extends StatelessWidget {
  final List<WeeklyBreakdown> weeklyBreakdown;
  final String currency;

  const _RevenueSpendBreakdownCard({
    required this.weeklyBreakdown,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.graph,
                  size: 20,
                  color: colors.interactivePrimary,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.revenueVsSpendOverTime,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Weekly breakdown
            ...weeklyBreakdown.map((week) => Padding(
              padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    week.weekLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space1),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.revenue}: ${CurrencyFormatter.format(week.revenue, currencyCode: currency)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.spend}: ${CurrencyFormatter.format(week.spend, currencyCode: currency)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.profit}: ${CurrencyFormatter.formatProfit(week.profit, currencyCode: currency).formatted}',
                          style: textTheme.bodySmall?.copyWith(
                            color: week.profit >= 0
                                ? colors.textPrimary
                                : colors.stateError,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (week != weeklyBreakdown.last)
                    const Padding(
                      padding: EdgeInsets.only(top: GOLSpacing.space2),
                      child: GOLDivider(),
                    ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

/// Worst Performing Days Card
class _WorstPerformingDaysCard extends StatelessWidget {
  final List<DayPerformance> worstDays;
  final String currency;

  const _WorstPerformingDaysCard({
    required this.worstDays,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.warning_2,
                  size: 20,
                  color: colors.stateWarning,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.worstPerformingDays,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Worst days list
            ...worstDays.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final day = entry.value;
              final profitResult = CurrencyFormatter.formatProfit(
                day.profit,
                currencyCode: currency,
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    children: [
                      Text(
                        '$index. ${DateFormat('MMM d', l10n.localeName).format(day.date)}: ',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                        Text(
                          profitResult.formatted,
                          style: textTheme.bodyMedium?.copyWith(
                            color: profitResult.isProfit
                                ? colors.textPrimary
                                : colors.stateError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${l10n.revenue}: ${CurrencyFormatter.format(day.revenue, currencyCode: currency)}, ${l10n.spend}: ${CurrencyFormatter.format(day.spend, currencyCode: currency)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (entry.key < worstDays.length - 1)
                      const Padding(
                        padding: EdgeInsets.only(top: GOLSpacing.space2),
                        child: GOLDivider(),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Burn Rate Card
class _BurnRateCard extends StatelessWidget {
  final ReportsData reportsData;
  final String currency;

  const _BurnRateCard({
    required this.reportsData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.money_send,
                  size: 20,
                  color: colors.interactivePrimary,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.burnRate,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        l10n.burnRateDescription,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Spend averages
            _BreakdownRow(
              label: l10n.averageDailySpend,
              value: CurrencyFormatter.format(
                reportsData.avgDailySpend,
                currencyCode: currency,
              ),
              valueColor: colors.textPrimary,
            ),
            const SizedBox(height: GOLSpacing.space2),
            _BreakdownRow(
              label: l10n.averageWeeklySpend,
              value: CurrencyFormatter.format(
                reportsData.avgWeeklySpend,
                currencyCode: currency,
              ),
              valueColor: colors.textPrimary,
            ),
            const SizedBox(height: GOLSpacing.space2),
            _BreakdownRow(
              label: l10n.averageMonthlySpend,
              value: CurrencyFormatter.format(
                reportsData.avgMonthlySpend,
                currencyCode: currency,
              ),
              valueColor: colors.textPrimary,
            ),

            const SizedBox(height: GOLSpacing.space3),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space3),

            // Projections
            Text(
              l10n.currentPace,
              style: textTheme.labelMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space1),
            Text(
              l10n.burnRateProjection(
                CurrencyFormatter.format(
                  reportsData.projectedYearlySpend,
                  currencyCode: currency,
                ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),

            const SizedBox(height: GOLSpacing.space3),
            const GOLDivider(),
            const SizedBox(height: GOLSpacing.space3),

            // ROI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.roi,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  reportsData.totalSpend > 0
                      ? '${reportsData.roi.toStringAsFixed(0)}%'
                      : l10n.notAvailable,
                  style: textTheme.titleMedium?.copyWith(
                    color: reportsData.roi >= 0
                        ? colors.textPrimary
                        : colors.stateError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (reportsData.totalSpend > 0 && reportsData.roi > 0)
              Text(
                l10n.roiEarningsDescription(
                  currency == "XOF" ? "FCFA" : currency,
                  (reportsData.roi / 100 + 1).toStringAsFixed(2),
                ),
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

/// Cumulative Profit Trend Card
class _CumulativeProfitCard extends StatelessWidget {
  final ReportsData reportsData;
  final String currency;

  const _CumulativeProfitCard({
    required this.reportsData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Show last 5 data points
    final trendPoints = reportsData.cumulativeProfitTrend.length > 5
        ? reportsData.cumulativeProfitTrend.sublist(
            reportsData.cumulativeProfitTrend.length - 5)
        : reportsData.cumulativeProfitTrend;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Padding(
        padding: const EdgeInsets.all(GOLSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.trend_up,
                  size: 20,
                  color: colors.interactivePrimary,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.cumulativeProfitTrend,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Trend points
            ...trendPoints.map((point) {
              final profitResult = CurrencyFormatter.formatProfit(
                point.cumulativeProfit,
                currencyCode: currency,
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM d', l10n.localeName).format(point.date),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      profitResult.formatted,
                      style: textTheme.bodyMedium?.copyWith(
                        color: profitResult.isProfit
                            ? colors.textPrimary
                            : colors.stateError,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Break-even info
            if (reportsData.breakEvenDate != null) ...[
              const SizedBox(height: GOLSpacing.space3),
              const GOLDivider(),
              const SizedBox(height: GOLSpacing.space3),
              Row(
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    size: 16,
                    color: colors.interactivePrimary,
                  ),
                  const SizedBox(width: GOLSpacing.space2),
                  Expanded(
                    child: Text(
                      l10n.breakEvenLabel(
                        DateFormat('MMM d', l10n.localeName).format(
                          reportsData.breakEvenDate!,
                        ),
                        reportsData.breakEvenDays!,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                l10n.recoveredSetupCosts(
                  DateFormat('MMM d', l10n.localeName).format(
                    reportsData.breakEvenDate!,
                  ),
                ),
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Export Button
class _ExportButton extends ConsumerStatefulWidget {
  final Tracker tracker;
  final ReportsData reportsData;

  const _ExportButton({
    required this.tracker,
    required this.reportsData,
  });

  @override
  ConsumerState<_ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends ConsumerState<_ExportButton> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GOLButton(
      label: _isExporting ? l10n.exporting : l10n.exportReport,
      variant: GOLButtonVariant.secondary,
      icon: Icon(
        _isExporting ? Iconsax.refresh : Iconsax.export_1,
        size: 18,
      ),
      onPressed: _isExporting ? null : () => _exportReport(context),
      fullWidth: true,
    );
  }

  Future<void> _exportReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isExporting = true);

    try {
      // Get entries
      final entriesState = ref.read(entriesProvider(widget.tracker.id));
      if (entriesState is! EntriesLoaded) {
        throw Exception(l10n.entriesNotLoaded);
      }

      await ExportService.exportEntriesToCsv(
        tracker: widget.tracker,
        entries: entriesState.entries,
        reportsData: widget.reportsData,
      );

      if (mounted) {
        showGOLToast(
          context,
          l10n.exportedSuccess,
          variant: GOLToastVariant.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showGOLToast(
          context,
          '${l10n.failedToExport}: ${e.toString()}',
          variant: GOLToastVariant.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }
}

/// Posts Section - Optional content references
class _PostsSection extends ConsumerWidget {
  final Tracker tracker;

  const _PostsSection({required this.tracker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final postsState = ref.watch(postsProvider(tracker.id));
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: '${l10n.posts} (${l10n.optional})',
          trailing: TextButton.icon(
            onPressed: () => _showAddPostModal(context, ref),
            icon: Icon(
              Iconsax.add,
              size: 16,
              color: colors.interactivePrimary,
            ),
            label: Text(
              l10n.addPost,
              style: textTheme.labelMedium?.copyWith(
                color: colors.interactivePrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: GOLSpacing.space3),

        if (postsState is PostsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(GOLSpacing.space4),
              child: CircularProgressIndicator(),
            ),
          )
        else if (postsState is PostsLoaded && postsState.posts.isEmpty)
          _PostsEmptyState(onAddPost: () => _showAddPostModal(context, ref))
        else if (postsState is PostsLoaded)
          Column(
            children: postsState.posts.take(5).map((post) {
              return Padding(
                padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
                child: _PostCard(
                  post: post,
                  tracker: tracker,
                ),
              );
            }).toList(),
          )
        else if (postsState is PostsError)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(GOLSpacing.space4),
              child: Text(
                postsState.message,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.stateError,
                ),
              ),
            ),
          ),

        if (postsState is PostsLoaded && postsState.count > 5) ...[
          const SizedBox(height: GOLSpacing.space2),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full posts list (could be a separate screen)
              },
              child: Text(
                l10n.viewAllPosts(postsState.count),
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.interactivePrimary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAddPostModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddPostModal(trackerId: tracker.id),
    );
  }
}

/// Empty state for posts section (Screen 23)
class _PostsEmptyState extends StatelessWidget {
  final VoidCallback onAddPost;

  const _PostsEmptyState({required this.onAddPost});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPaddingSpacious),
      child: Column(
        children: [
          Icon(
            Iconsax.link_2,
            size: 40,
            color: colors.textTertiary,
          ),
          const SizedBox(height: GOLSpacing.space3),
          Text(
            l10n.noPostsYet,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(
            l10n.postsOptionalDescription,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(
            l10n.postsDoNotAffectMetrics,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: GOLSpacing.space4),
          GOLButton(
            label: l10n.addYourFirstPost,
            variant: GOLButtonVariant.secondary,
            onPressed: onAddPost,
          ),
        ],
      ),
    );
  }
}

/// Post Card
class _PostCard extends ConsumerWidget {
  final PostModel post;
  final Tracker tracker;

  const _PostCard({
    required this.post,
    required this.tracker,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.space3),
      child: InkWell(
        onTap: () => _showEditPostModal(context, ref),
        borderRadius: BorderRadius.circular(GOLRadius.md),
        child: Row(
          children: [
            // Platform icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(GOLRadius.sm),
              ),
              child: Center(
                child: PlatformIcons.getIcon(
                  post.platform,
                  size: 20,
                  color: colors.interactivePrimary,
                ),
              ),
            ),
            const SizedBox(width: GOLSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${post.platform}${post.publishedDate != null ? ' • ${DateFormat('MMM d, yyyy').format(post.publishedDate!)}' : ''}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.edit_2,
              size: 16,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPostModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditPostModal(
        post: post,
        trackerId: tracker.id,
      ),
    );
  }
}

/// Add Post Modal (Screen 12)
class _AddPostModal extends ConsumerStatefulWidget {
  final String trackerId;

  const _AddPostModal({required this.trackerId});

  @override
  ConsumerState<_AddPostModal> createState() => _AddPostModalState();
}

class _AddPostModalState extends ConsumerState<_AddPostModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPlatform = PostPlatforms.all.first;
  DateTime? _publishedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(GOLRadius.modal),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: GOLSpacing.space4),
                      decoration: BoxDecoration(
                        color: colors.borderDefault,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.addPost,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Iconsax.close_circle),
                      ),
                    ],
                  ),

                  const SizedBox(height: GOLSpacing.space4),

                  // Title field
                  Text(
                    l10n.postTitleRequired,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: l10n.postTitleHint,
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return l10n.postTitleValidation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Text(
                    l10n.postContentPrompt,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Platform dropdown
                  Text(
                    l10n.platformRequired,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: GOLSpacing.space3),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.borderDefault),
                      borderRadius: BorderRadius.circular(GOLRadius.md),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPlatform,
                        isExpanded: true,
                        icon: const Icon(Iconsax.arrow_down_1),
                        items: PostPlatforms.all.map((platform) {
                          return DropdownMenuItem(
                            value: platform,
                            child: Row(
                              children: [
                                PlatformIcons.getIcon(
                                  platform,
                                  size: 18,
                                  color: colors.textPrimary,
                                ),
                                const SizedBox(width: GOLSpacing.space2),
                                Text(platform),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPlatform = value);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Publish date
                  Text(
                    l10n.publishDate,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(GOLRadius.md),
                    child: Container(
                      padding: const EdgeInsets.all(GOLSpacing.space3),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.borderDefault),
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            size: 20,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Text(
                            _publishedDate != null
                                ? DateFormat('MMM d, yyyy', l10n.localeName).format(
                                    _publishedDate!,
                                  )
                                : l10n.selectDateOptional,
                            style: textTheme.bodyMedium?.copyWith(
                              color: _publishedDate != null
                                  ? colors.textPrimary
                                  : colors.textTertiary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: colors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // URL field
                  Text(
                    l10n.postLinkOptional,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'https://...',
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Notes field
                  Text(
                    l10n.descriptionOptional,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      hintText: l10n.postDescriptionHint,
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: GOLSpacing.space6),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GOLButton(
                          label: l10n.cancel,
                          variant: GOLButtonVariant.secondary,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: GOLSpacing.space3),
                      Expanded(
                        child: GOLButton(
                          label: _isSubmitting ? l10n.adding : l10n.addPost,
                          variant: GOLButtonVariant.primary,
                          onPressed: _isSubmitting ? null : _submitPost,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _publishedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _publishedDate = date);
    }
  }

  Future<void> _submitPost() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await ref.read(postsProvider(widget.trackerId).notifier).createPost(
      title: _titleController.text,
      platform: _selectedPlatform,
      url: _urlController.text.isEmpty ? null : _urlController.text,
      publishedDate: _publishedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    if (!mounted) return;

    if (result.success) {
      Navigator.pop(context);
      showGOLToast(
        context,
        l10n.postAddedSuccessfully,
        variant: GOLToastVariant.success,
      );
    } else {
      setState(() => _isSubmitting = false);
      showGOLToast(
        context,
        result.error ?? l10n.failedToAddPost,
        variant: GOLToastVariant.error,
      );
    }
  }
}

/// Edit Post Modal (Screen 13)
class _EditPostModal extends ConsumerStatefulWidget {
  final PostModel post;
  final String trackerId;

  const _EditPostModal({
    required this.post,
    required this.trackerId,
  });

  @override
  ConsumerState<_EditPostModal> createState() => _EditPostModalState();
}

class _EditPostModalState extends ConsumerState<_EditPostModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;

  late String _selectedPlatform;
  DateTime? _publishedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _urlController = TextEditingController(text: widget.post.url ?? '');
    _notesController = TextEditingController(text: widget.post.notes ?? '');
    _selectedPlatform = widget.post.platform;
    _publishedDate = widget.post.publishedDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(GOLRadius.modal),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: GOLSpacing.space4),
                      decoration: BoxDecoration(
                        color: colors.borderDefault,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.editPost,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Iconsax.close_circle),
                      ),
                    ],
                  ),

                  const SizedBox(height: GOLSpacing.space4),

                  // Title field
                  Text(
                    l10n.postTitleRequired,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: l10n.postTitleHint,
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return l10n.postTitleValidation;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Platform dropdown
                  Text(
                    l10n.platformRequired,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: GOLSpacing.space3),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.borderDefault),
                      borderRadius: BorderRadius.circular(GOLRadius.md),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPlatform,
                        isExpanded: true,
                        icon: const Icon(Iconsax.arrow_down_1),
                        items: PostPlatforms.all.map((platform) {
                          return DropdownMenuItem(
                            value: platform,
                            child: Row(
                              children: [
                                PlatformIcons.getIcon(
                                  platform,
                                  size: 18,
                                  color: colors.textPrimary,
                                ),
                                const SizedBox(width: GOLSpacing.space2),
                                Text(platform),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPlatform = value);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Publish date
                  Text(
                    l10n.publishDate,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(GOLRadius.md),
                    child: Container(
                      padding: const EdgeInsets.all(GOLSpacing.space3),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.borderDefault),
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            size: 20,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Text(
                            _publishedDate != null
                                ? DateFormat('MMM d, yyyy', l10n.localeName).format(
                                    _publishedDate!,
                                  )
                                : l10n.selectDateOptional,
                            style: textTheme.bodyMedium?.copyWith(
                              color: _publishedDate != null
                                  ? colors.textPrimary
                                  : colors.textTertiary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: colors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // URL field
                  Text(
                    l10n.postLinkOptional,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'https://...',
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                  const GOLDivider(),
                  const SizedBox(height: GOLSpacing.space4),

                  // Notes field
                  Text(
                    l10n.descriptionOptional,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      hintText: l10n.postDescriptionHint,
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GOLRadius.md),
                        borderSide: BorderSide(color: colors.interactivePrimary),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: GOLSpacing.space4),

                  // Post metadata
                  Container(
                    padding: const EdgeInsets.all(GOLSpacing.space3),
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(GOLRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.postInfo,
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: GOLSpacing.space2),
                        Text(
                          l10n.createdOn(
                            DateFormat('MMM d, yyyy', l10n.localeName).format(
                              widget.post.createdAt,
                            ),
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          l10n.lastEditedOn(
                            DateFormat('MMM d, yyyy', l10n.localeName).format(
                              widget.post.updatedAt,
                            ),
                            DateFormat('h:mm a', l10n.localeName).format(
                              widget.post.updatedAt,
                            ),
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: GOLSpacing.space6),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GOLButton(
                          label: l10n.deletePost,
                          variant: GOLButtonVariant.destructive,
                          onPressed: _showDeleteConfirmation,
                        ),
                      ),
                      const SizedBox(width: GOLSpacing.space3),
                      Expanded(
                        child: GOLButton(
                          label: _isSubmitting ? l10n.saving : l10n.saveChanges,
                          variant: GOLButtonVariant.primary,
                          onPressed: _isSubmitting ? null : _submitPost,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: GOLSpacing.space4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _publishedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _publishedDate = date);
    }
  }

  Future<void> _submitPost() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final updatedPost = widget.post.copyWith(
      title: _titleController.text,
      platform: _selectedPlatform,
      url: _urlController.text.isEmpty ? null : _urlController.text,
      publishedDate: _publishedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final result = await ref.read(postsProvider(widget.trackerId).notifier).updatePost(updatedPost);

    if (!mounted) return;

    if (result.success) {
      Navigator.pop(context);
      showGOLToast(
        context,
        l10n.postUpdatedSuccessfully,
        variant: GOLToastVariant.success,
      );
    } else {
      setState(() => _isSubmitting = false);
      showGOLToast(
        context,
        result.error ?? l10n.failedToUpdatePost,
        variant: GOLToastVariant.error,
      );
    }
  }

  void _showDeleteConfirmation() {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePostQuestion),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"${widget.post.title}"',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              '${l10n.platformLabel}: ${widget.post.platform}',
              style: textTheme.bodySmall,
            ),
            if (widget.post.publishedDate != null)
              Text(
                l10n.postedOn(
                  DateFormat('MMM d, yyyy', l10n.localeName).format(
                    widget.post.publishedDate!,
                  ),
                ),
                style: textTheme.bodySmall,
              ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              l10n.actionCannotBeUndone,
              style: textTheme.bodySmall?.copyWith(
                color: colors.stateError,
              ),
            ),
          ],
        ),
        actions: [
          GOLButton(
            label: l10n.cancel,
            variant: GOLButtonVariant.tertiary,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          GOLButton(
            label: l10n.deletePost,
            variant: GOLButtonVariant.destructive,
            onPressed: () async {
              Navigator.pop(dialogContext); // Close dialog

              final result = await ref.read(postsProvider(widget.trackerId).notifier).deletePost(widget.post.id);

              if (!mounted) return;

              Navigator.pop(context); // Close modal

              if (result.success) {
                showGOLToast(
                  context,
                  l10n.postDeleted,
                  variant: GOLToastVariant.success,
                );
              } else {
                showGOLToast(
                  context,
                  result.error ?? l10n.failedToDeletePost,
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
