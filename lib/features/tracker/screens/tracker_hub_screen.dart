import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../domain/models/tracker.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/tracker_provider.dart';
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
class _OverviewTab extends StatelessWidget {
  final Tracker tracker;

  const _OverviewTab({required this.tracker});

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
                '${tracker.entryCount} ${tracker.entryCount == 1 ? 'entry' : 'entries'}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: GOLSpacing.space5),

          // Performance card
          _PerformanceCard(tracker: tracker),

          const SizedBox(height: GOLSpacing.space5),

          // Key Metrics Grid (2x2)
          _MetricsGrid(tracker: tracker),

          const SizedBox(height: GOLSpacing.space5),

          // Platforms section
          if (tracker.platforms.isNotEmpty) ...[
            _SectionHeader(
              title: 'Platforms',
              icon: Iconsax.global,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Wrap(
              spacing: GOLSpacing.space2,
              runSpacing: GOLSpacing.space2,
              children: tracker.platforms.map((platform) {
                return Chip(
                  label: Text(platform),
                  avatar: Icon(
                    _getPlatformIcon(platform),
                    size: 16,
                    color: colors.interactivePrimary,
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
            icon: Iconsax.calendar_1,
            trailing: tracker.entryCount > 0
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

          if (tracker.entryCount == 0)
            _EmptySection(
              icon: Iconsax.calendar_tick,
              title: 'No entries yet',
              subtitle: 'Log your first daily entry to start tracking',
            )
          else
            // Placeholder for entries list
            GOLCard(
              variant: GOLCardVariant.standard,
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Center(
                child: Text(
                  '${tracker.entryCount} entries - View in Entries tab',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),

          const SizedBox(height: GOLSpacing.space5),

          // Goals section (if any)
          if (tracker.goalTypes.isNotEmpty) ...[
            _SectionHeader(
              title: 'Goals',
              icon: Iconsax.flag,
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
              icon: Iconsax.chart_2,
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
              icon: Iconsax.document_text,
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

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Iconsax.message_circle;
      case 'instagram':
        return Iconsax.image;
      case 'tiktok':
        return Iconsax.video_square;
      case 'youtube':
        return Iconsax.video_play;
      case 'twitter':
      case 'x':
        return Iconsax.message;
      case 'linkedin':
        return Iconsax.briefcase;
      default:
        return Iconsax.global;
    }
  }
}

/// Performance card showing profit, revenue, and spend
class _PerformanceCard extends StatelessWidget {
  final Tracker tracker;

  const _PerformanceCard({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isProfit = tracker.totalProfit >= 0;
    final profitColor = isProfit ? colors.stateSuccess : colors.stateError;

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
                      tracker.totalProfit.round(),
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
                      tracker.totalRevenue.round(),
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
                      tracker.totalSpend.round(),
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

  const _MetricsGrid({required this.tracker});

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
                value: '${tracker.entryCount}',
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
  final IconData icon;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colors.interactivePrimary),
        const SizedBox(width: GOLSpacing.space2),
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

/// Entries Tab - Screen 4 placeholder
class _EntriesTab extends StatelessWidget {
  final Tracker tracker;

  const _EntriesTab({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (tracker.entryCount == 0) {
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
                Iconsax.calendar_tick,
                size: 32,
                color: colors.textTertiary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),
            Text(
              'No entries yet',
              style: textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'Log your first daily entry to start tracking',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space5),
            GOLButton(
              label: 'Log Entry',
              onPressed: () =>
                  context.push(Routes.logEntryPath(tracker.id)),
              size: GOLButtonSize.large,
            ),
          ],
        ),
      );
    }

    // Placeholder for entries list
    return Center(
      child: Text(
        'Entries list coming soon',
        style: textTheme.bodyLarge?.copyWith(
          color: colors.textSecondary,
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
