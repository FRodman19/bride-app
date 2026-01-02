import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';

class GOLListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const GOLListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final content = Row(
      crossAxisAlignment:
          subtitle == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: GOLSpacing.space4),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.textSecondary),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: GOLSpacing.space3),
          trailing!,
        ],
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.listItemPaddingHorizontal,
          vertical: GOLSpacing.listItemPaddingVertical,
        ),
        child: content,
      ),
    );
  }
}
