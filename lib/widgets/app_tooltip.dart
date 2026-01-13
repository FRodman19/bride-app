import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Tooltip position relative to the child widget
enum TooltipPosition { top, bottom, left, right }

/// APP TOOLTIP - Custom tooltip with design system styling
/// Flat design, no shadow, 16px radius
class AppTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final TooltipPosition position;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration showDuration;
  final Duration waitDuration;

  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
    this.position = TooltipPosition.top,
    this.backgroundColor,
    this.textColor,
    this.showDuration = const Duration(seconds: 2),
    this.waitDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  bool _isVisible = false;

  void _showTooltip() {
    setState(() => _isVisible = true);
    Future.delayed(widget.showDuration, () {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  void _hideTooltip() {
    setState(() => _isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor =
        widget.backgroundColor ??
        (isDark ? AppColors.neutral800 : AppColors.neutral900);
    final txtColor = widget.textColor ?? AppColors.white;

    return GestureDetector(
      onLongPress: _showTooltip,
      onTap: _hideTooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_isVisible)
            Positioned(
              top: widget.position == TooltipPosition.top ? null : null,
              bottom: widget.position == TooltipPosition.bottom ? null : null,
              left: widget.position == TooltipPosition.left ? null : 0,
              right: widget.position == TooltipPosition.right ? null : 0,
              child: _TooltipContent(
                message: widget.message,
                backgroundColor: bgColor,
                textColor: txtColor,
                brightness: brightness,
              ),
            ),
        ],
      ),
    );
  }
}

/// Tooltip content with arrow
class _TooltipContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Brightness brightness;

  const _TooltipContent({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16), // 16px radius
      ),
      child: Text(
        message,
        style: TextStyles.bodySmall(brightness).copyWith(color: textColor),
      ),
    );
  }
}

/// SIMPLE TOOLTIP WRAPPER - Uses Material Tooltip with custom styling
/// Flat design, no shadow, 16px radius
class AppTooltipSimple extends StatelessWidget {
  final Widget child;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const AppTooltipSimple({
    super.key,
    required this.child,
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.neutral800 : AppColors.neutral900);
    final txtColor = textColor ?? AppColors.white;

    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16), // 16px radius
      ),
      textStyle: TextStyles.bodySmall(brightness).copyWith(color: txtColor),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 2),
      child: child,
    );
  }
}

/// RICH TOOLTIP - Tooltip with icon and optional action
/// Flat design, no shadow, 16px radius
class AppTooltipRich extends StatelessWidget {
  final Widget child;
  final String title;
  final String? description;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const AppTooltipRich({
    super.key,
    required this.child,
    required this.title,
    this.description,
    this.icon,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.neutral800 : AppColors.neutral900;

    return Tooltip(
      richMessage: WidgetSpan(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.teal500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyles.labelMedium(
                          brightness,
                        ).copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  title,
                  style: TextStyles.labelMedium(
                    brightness,
                  ).copyWith(color: AppColors.white),
                ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  style: TextStyles.bodySmall(
                    brightness,
                  ).copyWith(color: AppColors.white),
                ),
              ],
              if (onActionPressed != null && actionLabel != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onActionPressed,
                  child: Text(
                    actionLabel!,
                    style: TextStyles.labelSmall(brightness).copyWith(
                      color: AppColors.teal500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16), // 16px radius
      ),
      padding: const EdgeInsets.all(12),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 3),
      child: child,
    );
  }
}

/// INFO TOOLTIP - Tooltip with info icon trigger
/// Flat design, no shadow, 16px radius
class AppTooltipInfo extends StatelessWidget {
  final String message;
  final Color? iconColor;
  final double iconSize;

  const AppTooltipInfo({
    super.key,
    required this.message,
    this.iconColor,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final color =
        iconColor ?? (isDark ? AppColors.neutral400 : AppColors.neutral600);

    return AppTooltipSimple(
      message: message,
      child: Icon(Icons.info_outline, size: iconSize, color: color),
    );
  }
}
