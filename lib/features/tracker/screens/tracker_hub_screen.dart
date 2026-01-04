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
import '../../../routing/routes.dart';

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
                'Project not found',
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
                    'Started ${DateFormat('MMM d, yyyy').format(tracker.startDate)}',
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
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Entries'),
                  Tab(text: 'Reports'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.logEntryPath(tracker!.id)),
        backgroundColor: colors.interactivePrimary,
        icon: Icon(Iconsax.add, color: colors.textInverse),
        label: Text(
          'Log Entry',
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

                // Actions
                ListTile(
                  leading: Icon(Iconsax.edit_2, color: colors.textPrimary),
                  title: Text(
                    'Edit Project',
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
                    tracker.isArchived ? 'Restore Project' : 'Archive Project',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement archive/restore
                  },
                ),
                ListTile(
                  leading: Icon(Iconsax.export_1, color: colors.textPrimary),
                  title: Text(
                    'Export Data',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement export
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Iconsax.trash, color: colors.stateError),
                  title: Text(
                    'Delete Project',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.stateError,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Show delete confirmation
                  },
                ),
              ],
            ),
          ),
        );
      },
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

          // Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space3,
                  vertical: GOLSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: tracker.isArchived
                      ? colors.surfaceRaised
                      : colors.stateSuccess.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tracker.isArchived
                            ? colors.textTertiary
                            : colors.stateSuccess,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: GOLSpacing.space2),
                    Text(
                      tracker.isArchived ? 'Archived' : 'Active',
                      style: textTheme.labelMedium?.copyWith(
                        color: tracker.isArchived
                            ? colors.textTertiary
                            : colors.stateSuccess,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '$entryCount ${entryCount == 1 ? 'entry' : 'entries'}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space5),

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
              title: 'Platforms',
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
            title: 'Recent Entries',
            trailing: entryCount > 0
                ? TextButton(
                    onPressed: () {
                      // Switch to entries tab
                    },
                    child: Text(
                      'View All',
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
              title: 'No entries yet',
              subtitle: 'Log your first daily entry to start tracking',
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
                            DateFormat('MMM d').format(entry.entryDate),
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
                '${entryCount - 3} more entries - View in Entries tab',
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
              title: 'Goals',
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
              title: 'Targets',
            ),
            const SizedBox(height: GOLSpacing.space3),
            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Column(
                children: [
                  if (tracker.revenueTarget != null)
                    _TargetRow(
                      label: 'Revenue Target',
                      value: CurrencyFormatter.format(
                        tracker.revenueTarget!.round(),
                        currencyCode: tracker.currency,
                      ),
                      current: tracker.totalRevenue,
                      target: tracker.revenueTarget!,
                    ),
                  if (tracker.revenueTarget != null &&
                      tracker.engagementTarget != null)
                    const SizedBox(height: GOLSpacing.space3),
                  if (tracker.engagementTarget != null)
                    _TargetRow(
                      label: 'Engagement Target',
                      value: '${tracker.engagementTarget} DMs/Leads',
                      current: 0, // TODO: Get from entries
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
              title: 'Notes',
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
          ],

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

    final isProfit = totalProfit >= 0;
    // Use normal text color for profit, only red for loss (more professional)
    final profitColor = isProfit ? colors.textPrimary : colors.stateError;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPaddingSpacious),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - white text for visibility
          Row(
            children: [
              Icon(Iconsax.chart_2, size: 20, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                'PERFORMANCE',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textPrimary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
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
            isProfit ? 'Net profit' : 'Net loss',
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
                    label: 'Revenue',
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
                    label: 'Spend',
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
    final daysSinceStart =
        DateTime.now().difference(tracker.startDate).inDays + 1;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _MetricCard(
                icon: Iconsax.calendar_tick,
                label: 'Days Active',
                value: '$daysSinceStart',
                subtitle: 'since start',
                subtitleStyle: _MetricSubtitleStyle.plain,
              ),
              const SizedBox(height: GOLSpacing.space3),
              _MetricCard(
                icon: Iconsax.document_text,
                label: 'Entries',
                value: '$entryCount',
                subtitle: 'logged',
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
                label: 'Setup Cost',
                value: CurrencyFormatter.format(
                  tracker.setupCost.round(),
                  currencyCode: tracker.currency,
                ),
              ),
              const SizedBox(height: GOLSpacing.space3),
              _MetricCard(
                icon: Iconsax.chart_1,
                label: 'Monthly Cost',
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
              'Failed to load entries',
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
              'No Entries Yet',
              style: textTheme.headlineSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),

            // Description
            Text(
              'Daily entries track your campaign performance day by day.',
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
                    'Each entry logs:',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _buildBulletPoint(context, 'Total revenue for the day'),
                  _buildBulletPoint(context, 'Ad spend per platform'),
                  _buildBulletPoint(context, 'DMs/Leads received'),
                  _buildBulletPoint(context, 'Daily profit (calculated)'),
                ],
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Secondary message
            Text(
              'Start tracking to see trends, ROI, and burn rate.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space5),

            // CTA Button
            GOLButton(
              label: 'Log First Entry',
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
                'SUMMARY (${_getFilterLabel()})',
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
                  label: 'Total Entries',
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
                  label: 'Total Profit',
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
                  label: 'Avg Daily Profit',
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
                  label: 'Total DMs/Leads',
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
                label: 'Best Day',
                date: stats.bestDay!.date,
                profit: stats.bestDay!.profit,
                currency: widget.tracker.currency,
                isPositive: true,
              ),
            if (stats.bestDay != null && stats.worstDay != null)
              const SizedBox(height: GOLSpacing.space2),
            if (stats.worstDay != null)
              _BestWorstDayRow(
                label: 'Worst Day',
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

    return Row(
      children: [
        _FilterPill(
          label: 'This Week',
          isSelected: _selectedFilter == _EntryFilter.thisWeek,
          onTap: () => setState(() => _selectedFilter = _EntryFilter.thisWeek),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _FilterPill(
          label: 'This Month',
          isSelected: _selectedFilter == _EntryFilter.thisMonth,
          onTap: () => setState(() => _selectedFilter = _EntryFilter.thisMonth),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _FilterPill(
          label: 'All Time',
          isSelected: _selectedFilter == _EntryFilter.allTime,
          onTap: () => setState(() => _selectedFilter = _EntryFilter.allTime),
        ),
        const Spacer(),
        // View History button
        TextButton.icon(
          onPressed: () =>
              context.push(Routes.entryHistoryPath(widget.tracker.id)),
          icon: Icon(Iconsax.clock, size: 16, color: colors.interactivePrimary),
          label: Text(
            'History',
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
              'No entries for ${_getFilterLabel().toLowerCase()}',
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

    for (final entry in entries) {
      String section;
      final entryDate = DateTime(
        entry.entryDate.year,
        entry.entryDate.month,
        entry.entryDate.day,
      );

      if (_isSameDay(entryDate, today)) {
        section = 'TODAY';
      } else if (_isSameDay(entryDate, today.subtract(const Duration(days: 1)))) {
        section = 'YESTERDAY';
      } else if (entryDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
        section = 'THIS WEEK';
      } else if (entryDate.isAfter(startOfLastWeek.subtract(const Duration(days: 1)))) {
        section = 'LAST WEEK';
      } else if (entryDate.year == now.year && entryDate.month == now.month) {
        section = 'THIS MONTH';
      } else {
        section = DateFormat('MMMM yyyy').format(entryDate).toUpperCase();
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

  String _getFilterLabel() {
    switch (_selectedFilter) {
      case _EntryFilter.thisWeek:
        return 'This Week';
      case _EntryFilter.thisMonth:
        return 'This Month';
      case _EntryFilter.allTime:
        return 'All Time';
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
          DateFormat('MMM d').format(date),
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
                        DateFormat('d').format(entry.entryDate),
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(entry.entryDate),
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
                          Text(
                            CurrencyFormatter.format(
                              entry.profit,
                              currencyCode: tracker.currency,
                            ),
                            style: textTheme.titleSmall?.copyWith(
                              color: profitColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Text(
                            isProfit ? 'profit' : 'loss',
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
                              'Rev: ${CurrencyFormatter.format(entry.totalRevenue, currencyCode: tracker.currency)}',
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
                              'Spend: ${CurrencyFormatter.format(entry.totalSpend, currencyCode: tracker.currency)}',
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

/// Reports Tab - Screen 5 placeholder
class _ReportsTab extends StatelessWidget {
  final Tracker tracker;

  const _ReportsTab({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
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
            'Reports coming soon',
            style: textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(
            'Performance reports will be available here',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
