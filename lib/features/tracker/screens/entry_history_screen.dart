import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../grow_out_loud/components/gol_dividers.dart';
import '../../../domain/models/tracker.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/tracker_provider.dart';
import '../../../providers/entry_provider.dart';
import '../../../routing/routes.dart';

/// Screen 10: Entry History (All Entries List)
///
/// Comprehensive scrollable list of all entries with search/filter.
class EntryHistoryScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const EntryHistoryScreen({
    super.key,
    required this.trackerId,
  });

  @override
  ConsumerState<EntryHistoryScreen> createState() => _EntryHistoryScreenState();
}

enum _HistoryFilter { all, profit, loss }

class _EntryHistoryScreenState extends ConsumerState<EntryHistoryScreen> {
  _HistoryFilter _selectedFilter = _HistoryFilter.all;
  String _searchQuery = '';
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final tracker = ref.watch(trackerByIdProvider(widget.trackerId));
    final entriesState = ref.watch(entriesProvider(widget.trackerId));

    if (tracker == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('All Entries')),
        body: const Center(child: Text('Tracker not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by date...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colors.textTertiary,
                  ),
                  border: InputBorder.none,
                ),
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Entries',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${tracker.name} - Complete History',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Iconsax.close_circle : Iconsax.search_normal,
              color: colors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
        backgroundColor: colors.surfaceDefault,
        elevation: 0,
      ),
      body: _buildBody(context, tracker, entriesState),
    );
  }

  Widget _buildBody(BuildContext context, Tracker tracker, EntriesState entriesState) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (entriesState is EntriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entriesState is EntriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.warning_2, size: 48, color: colors.stateError),
            const SizedBox(height: GOLSpacing.space4),
            Text(
              'Failed to load entries',
              style: textTheme.titleMedium?.copyWith(color: colors.textPrimary),
            ),
          ],
        ),
      );
    }

    final loadedState = entriesState as EntriesLoaded;
    final allEntries = loadedState.entries;

    // Empty state
    if (allEntries.isEmpty) {
      return _buildEmptyState(context, tracker);
    }

    // Apply filters
    var filteredEntries = _applyFilters(allEntries);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filteredEntries = filteredEntries.where((e) {
        final dateStr = DateFormat('MMM d yyyy').format(e.entryDate).toLowerCase();
        return dateStr.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Calculate overview stats from all entries (not filtered)
    final overviewStats = _calculateOverviewStats(allEntries);

    // Group entries by month
    final groupedEntries = _groupEntriesByMonth(filteredEntries);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: GOLSpacing.space4),

          // Overview Card
          _buildOverviewCard(context, overviewStats, tracker.currency),

          const SizedBox(height: GOLSpacing.space5),

          // Filter Pills
          _buildFilterPills(context),

          const SizedBox(height: GOLSpacing.space5),

          // Entries grouped by month
          if (filteredEntries.isEmpty)
            _buildNoResultsState(context)
          else
            ...groupedEntries.entries.map((group) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        group.key,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${group.value.length} ${group.value.length == 1 ? 'entry' : 'entries'}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GOLSpacing.space3),

                  // Entries in this month
                  ...group.value.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
                        child: _HistoryEntryCard(
                          entry: entry,
                          currency: tracker.currency,
                          onTap: () => context.push(
                            Routes.entryDetailPath(widget.trackerId, entry.id),
                          ),
                        ),
                      )),

                  const SizedBox(height: GOLSpacing.space4),
                ],
              );
            }),

          // Bottom padding
          const SizedBox(height: GOLSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Tracker tracker) {
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
                Iconsax.chart_2,
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
              'Entry history shows all your daily performance logs in one place.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space4),

            // What you'll see
            Container(
              padding: const EdgeInsets.all(GOLSpacing.space4),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'As you log entries, you\'ll see:',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  _buildHistoryBulletPoint(context, 'Complete timeline'),
                  _buildHistoryBulletPoint(context, 'Profit trends'),
                  _buildHistoryBulletPoint(context, 'Revenue patterns'),
                  _buildHistoryBulletPoint(context, 'Spend analysis'),
                  _buildHistoryBulletPoint(context, 'Engagement metrics'),
                ],
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),

            // Secondary message
            Text(
              'Start logging to build your performance history!',
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
              onPressed: () => context.push(Routes.logEntryPath(widget.trackerId)),
              size: GOLButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryBulletPoint(BuildContext context, String text) {
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

  Widget _buildNoResultsState(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: GOLSpacing.space8),
        child: Column(
          children: [
            Icon(Iconsax.search_status, size: 48, color: colors.textTertiary),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              'No entries found',
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'Try adjusting your filters or search',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    _OverviewStats stats,
    String currency,
  ) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isProfit = stats.totalProfit >= 0;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.chart_2, size: 18, color: colors.interactivePrimary),
              const SizedBox(width: GOLSpacing.space2),
              Text(
                'OVERVIEW',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: GOLSpacing.space4),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _OverviewStatItem(
                  label: 'Total Entries',
                  value: '${stats.totalEntries}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.borderDefault,
                margin: const EdgeInsets.symmetric(horizontal: GOLSpacing.space3),
              ),
              Expanded(
                child: _OverviewStatItem(
                  label: 'Date Range',
                  value: stats.dateRange,
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
                child: _OverviewStatItem(
                  label: 'Total Profit',
                  value: CurrencyFormatter.format(
                    stats.totalProfit,
                    currencyCode: currency,
                  ),
                  valueColor: isProfit ? colors.textPrimary : colors.stateError,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.borderDefault,
                margin: const EdgeInsets.symmetric(horizontal: GOLSpacing.space3),
              ),
              Expanded(
                child: _OverviewStatItem(
                  label: 'Avg Daily',
                  value: CurrencyFormatter.format(
                    stats.avgDaily.round(),
                    currencyCode: currency,
                  ),
                  valueColor: stats.avgDaily >= 0
                      ? colors.textPrimary
                      : colors.stateError,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills(BuildContext context) {
    return Row(
      children: [
        _FilterPill(
          label: 'All',
          isSelected: _selectedFilter == _HistoryFilter.all,
          onTap: () => setState(() => _selectedFilter = _HistoryFilter.all),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _FilterPill(
          label: 'Profit',
          isSelected: _selectedFilter == _HistoryFilter.profit,
          onTap: () => setState(() => _selectedFilter = _HistoryFilter.profit),
        ),
        const SizedBox(width: GOLSpacing.space2),
        _FilterPill(
          label: 'Loss',
          isSelected: _selectedFilter == _HistoryFilter.loss,
          onTap: () => setState(() => _selectedFilter = _HistoryFilter.loss),
        ),
      ],
    );
  }

  List<Entry> _applyFilters(List<Entry> entries) {
    switch (_selectedFilter) {
      case _HistoryFilter.all:
        return entries;
      case _HistoryFilter.profit:
        return entries.where((e) => e.profit >= 0).toList();
      case _HistoryFilter.loss:
        return entries.where((e) => e.profit < 0).toList();
    }
  }

  Map<String, List<Entry>> _groupEntriesByMonth(List<Entry> entries) {
    final Map<String, List<Entry>> grouped = {};

    // Sort entries by date (most recent first)
    final sortedEntries = List<Entry>.from(entries)
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));

    for (final entry in sortedEntries) {
      final monthKey = DateFormat('MMMM yyyy').format(entry.entryDate).toUpperCase();
      grouped.putIfAbsent(monthKey, () => []);
      grouped[monthKey]!.add(entry);
    }

    return grouped;
  }

  _OverviewStats _calculateOverviewStats(List<Entry> entries) {
    if (entries.isEmpty) {
      return _OverviewStats(
        totalEntries: 0,
        dateRange: 'No entries',
        totalProfit: 0,
        avgDaily: 0,
      );
    }

    // Sort to get date range
    final sorted = List<Entry>.from(entries)
      ..sort((a, b) => a.entryDate.compareTo(b.entryDate));

    final firstDate = sorted.first.entryDate;
    final lastDate = sorted.last.entryDate;

    // Calculate totals
    int totalRevenue = 0;
    int totalSpend = 0;
    for (final entry in entries) {
      totalRevenue += entry.totalRevenue;
      totalSpend += entry.totalSpend;
    }
    final totalProfit = totalRevenue - totalSpend;
    final avgDaily = entries.isNotEmpty ? totalProfit / entries.length : 0.0;

    // Format date range
    final dateFormat = DateFormat('MMM d');
    final yearFormat = DateFormat('yyyy');
    String dateRange;
    if (firstDate.year == lastDate.year) {
      dateRange = '${dateFormat.format(firstDate)} - ${dateFormat.format(lastDate)}, ${yearFormat.format(lastDate)}';
    } else {
      dateRange = '${dateFormat.format(firstDate)}, ${yearFormat.format(firstDate)} - ${dateFormat.format(lastDate)}, ${yearFormat.format(lastDate)}';
    }

    return _OverviewStats(
      totalEntries: entries.length,
      dateRange: dateRange,
      totalProfit: totalProfit,
      avgDaily: avgDaily,
    );
  }
}

class _OverviewStats {
  final int totalEntries;
  final String dateRange;
  final int totalProfit;
  final double avgDaily;

  _OverviewStats({
    required this.totalEntries,
    required this.dateRange,
    required this.totalProfit,
    required this.avgDaily,
  });
}

class _OverviewStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _OverviewStatItem({
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
            style: textTheme.titleSmall?.copyWith(
              color: valueColor ?? colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
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
            horizontal: GOLSpacing.space4,
            vertical: GOLSpacing.space2,
          ),
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected ? colors.textInverse : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Entry card for history list
class _HistoryEntryCard extends StatelessWidget {
  final Entry entry;
  final String currency;
  final VoidCallback onTap;

  const _HistoryEntryCard({
    required this.entry,
    required this.currency,
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
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and profit
                      Row(
                        children: [
                          Text(
                            DateFormat('MMM d').format(entry.entryDate),
                            style: textTheme.titleSmall?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Text(
                            '•',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space2),
                          Icon(
                            isProfit ? Iconsax.trend_up : Iconsax.trend_down,
                            size: 14,
                            color: profitColor,
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Text(
                            CurrencyFormatter.format(
                              entry.profit,
                              currencyCode: currency,
                            ),
                            style: textTheme.titleSmall?.copyWith(
                              color: profitColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space1),
                          Text(
                            isProfit ? 'profit' : 'loss',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GOLSpacing.space1),
                      // Revenue and Spend
                      Row(
                        children: [
                          Text(
                            'Revenue: ',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              entry.totalRevenue,
                              currencyCode: currency,
                            ),
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: GOLSpacing.space3),
                          Text(
                            'Spend: ',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              entry.totalSpend,
                              currencyCode: currency,
                            ),
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

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
