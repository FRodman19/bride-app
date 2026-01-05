import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Feature item for empty state bullet list.
class EmptyStateFeature {
  final IconData icon;
  final String text;

  const EmptyStateFeature({required this.icon, required this.text});
}

/// A reusable empty state widget.
/// Used for Screens 21-25 (Dashboard, Entries, Posts, Archive, Entry History).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool useCard;
  final List<EmptyStateFeature>? features;
  final String? whatYouCanTrackLabel;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.useCard = false,
    this.features,
    this.whatYouCanTrackLabel,
  });

  /// Dashboard/Projects empty state - no projects yet.
  factory EmptyState.dashboard({required VoidCallback onCreateProject, required AppLocalizations l10n}) {
    return EmptyState(
      icon: Iconsax.folder_add,
      title: l10n.nothingYet,
      subtitle: l10n.startFirstProject,
      actionLabel: l10n.startNewProject,
      onAction: onCreateProject,
      useCard: true,
      features: [
        EmptyStateFeature(icon: Iconsax.money_recive, text: l10n.trackRevenueSpending),
        EmptyStateFeature(icon: Iconsax.chart_success, text: l10n.monitorGrowthMetrics),
        EmptyStateFeature(icon: Iconsax.document_text, text: l10n.logPostsContent),
        EmptyStateFeature(icon: Iconsax.status_up, text: l10n.seePerformanceTrends),
      ],
      whatYouCanTrackLabel: l10n.whatYouCanTrack,
    );
  }

  /// Entries empty state - no entries for this project.
  factory EmptyState.entries({required VoidCallback onLogEntry, required AppLocalizations l10n}) {
    return EmptyState(
      icon: Iconsax.calendar_tick,
      title: l10n.noEntriesYet,
      subtitle: l10n.noEntriesYetSubtitle,
      actionLabel: l10n.logEntry,
      onAction: onLogEntry,
    );
  }

  /// Posts empty state - no posts for this project.
  factory EmptyState.posts({required VoidCallback onAddPost, required AppLocalizations l10n}) {
    return EmptyState(
      icon: Iconsax.document_text,
      title: l10n.noPostsYet,
      subtitle: l10n.noPostsYetSubtitle,
      actionLabel: l10n.addPost,
      onAction: onAddPost,
    );
  }

  /// Archive empty state - no archived projects.
  factory EmptyState.archive({required AppLocalizations l10n}) {
    return EmptyState(
      icon: Iconsax.archive_1,
      title: l10n.noArchivedProjects,
      subtitle: l10n.archivedProjectsAppearHere,
    );
  }

  /// Entry history empty state - no entries found.
  factory EmptyState.entryHistory({required AppLocalizations l10n}) {
    return EmptyState(
      icon: Iconsax.calendar,
      title: l10n.noEntriesFound,
      subtitle: l10n.tryAdjustingFilters,
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
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: useCard ? colors.surfaceDefault : colors.surfaceRaised,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 32,
            color: colors.textTertiary,
          ),
        ),

        const SizedBox(height: GOLSpacing.space4),

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
          const SizedBox(height: GOLSpacing.space5),

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
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Centered card
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: GOLCard(
                variant: GOLCardVariant.elevated,
                padding: const EdgeInsets.symmetric(
                  horizontal: GOLSpacing.space5,
                  vertical: GOLSpacing.space6,
                ),
                child: content,
              ),
            ),
          ),

          // Feature bullets below the card
          if (features != null && features!.isNotEmpty) ...[
            const SizedBox(height: GOLSpacing.space6),
            _FeatureList(
              features: features!,
              colors: colors,
              textTheme: textTheme,
              whatYouCanTrackLabel: whatYouCanTrackLabel,
            ),
          ],
        ],
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

class _FeatureList extends StatelessWidget {
  final List<EmptyStateFeature> features;
  final GOLSemanticColors colors;
  final TextTheme textTheme;
  final String? whatYouCanTrackLabel;

  const _FeatureList({
    required this.features,
    required this.colors,
    required this.textTheme,
    this.whatYouCanTrackLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: GOLSpacing.space2),
          child: Text(
            whatYouCanTrackLabel ?? 'What you can track:',
            style: textTheme.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: GOLSpacing.space3),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
              child: Row(
                children: [
                  Icon(
                    feature.icon,
                    size: 18,
                    color: colors.interactivePrimary,
                  ),
                  const SizedBox(width: GOLSpacing.space3),
                  Text(
                    feature.text,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
