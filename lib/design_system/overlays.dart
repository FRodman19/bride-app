import 'package:flutter/material.dart';

import 'buttons.dart';
import 'spacing.dart';
import 'theme.dart';

class DSModal {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(DSSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: DSSpacing.md),
                content,
                if (actions != null) ...[
                  const SizedBox(height: DSSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions
                        .expand((widget) => [widget, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class DSBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget content,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      builder: (context) {
        final background = Theme.of(context).cardColor;
        return Container(
          margin: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(DSSpacing.componentRadius),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DSSpacing.lg,
                vertical: DSSpacing.lg,
              ),
              child: content,
            ),
          ),
        );
      },
    );
  }
}

class DSToast {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: DSColors.teal500),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class DSInlineModal extends StatelessWidget {
  const DSInlineModal({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: DSSpacing.md),
          Row(
            children: [
              DSButton(
                label: 'Cancel',
                variant: DSButtonVariant.tertiary,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              DSButton(
                label: 'Confirm',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
