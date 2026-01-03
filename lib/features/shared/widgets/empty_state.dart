import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';

/// A reusable empty state widget.
/// Used for Screens 21-25 (Dashboard, Entries, Posts, Archive, Entry History).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool useCard;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.useCard = false,
  });

  /// Dashboard empty state - no trackers yet.
  factory EmptyState.dashboard({required VoidCallback onCreateTracker}) {
    return EmptyState(
      icon: Iconsax.chart_2,
      title: 'Nothing yet',
      subtitle: 'Create your first tracker to start monitoring your campaign performance',
      actionLabel: 'Create Tracker',
      onAction: onCreateTracker,
      useCard: true,
    );
  }

  /// Entries empty state - no entries for this tracker.
  factory EmptyState.entries({required VoidCallback onLogEntry}) {
    return EmptyState(
      icon: Iconsax.calendar_tick,
      title: 'No entries yet',
      subtitle: 'Log your first daily entry to start tracking revenue and spend',
      actionLabel: 'Log Entry',
      onAction: onLogEntry,
    );
  }

  /// Posts empty state - no posts for this tracker.
  factory EmptyState.posts({required VoidCallback onAddPost}) {
    return EmptyState(
      icon: Iconsax.document_text,
      title: 'No posts yet',
      subtitle: 'Add posts to track your content across platforms',
      actionLabel: 'Add Post',
      onAction: onAddPost,
    );
  }

  /// Archive empty state - no archived trackers.
  factory EmptyState.archive() {
    return const EmptyState(
      icon: Iconsax.archive_1,
      title: 'No archived trackers',
      subtitle: 'Trackers you archive will appear here',
    );
  }

  /// Entry history empty state - no entries found.
  factory EmptyState.entryHistory() {
    return const EmptyState(
      icon: Iconsax.calendar,
      title: 'No entries found',
      subtitle: 'Try adjusting your filters or date range',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      mainAxisSize: useCard ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: useCard ? colors.surfaceDefault : colors.surfaceRaised,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 36,
            color: colors.textTertiary,
          ),
        ),

        const SizedBox(height: GOLSpacing.space6),

        // Title
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: GOLSpacing.space2),

        // Subtitle
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: GOLSpacing.space6),

          // Action button
          GOLButton(
            label: actionLabel!,
            onPressed: onAction,
            size: GOLButtonSize.large,
          ),
        ],
      ],
    );

    if (useCard) {
      return Padding(
        padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
        child: GOLCard(
          variant: GOLCardVariant.elevated,
          padding: const EdgeInsets.symmetric(
            horizontal: GOLSpacing.space6,
            vertical: GOLSpacing.space8,
          ),
          child: content,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.screenPaddingHorizontal * 2,
        ),
        child: content,
      ),
    );
  }
}
