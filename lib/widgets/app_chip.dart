import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Chip/Tag size variants
enum ChipSize { small, medium, large }

/// Get chip specs based on size
class _ChipSpecs {
  final double height;
  final double paddingVertical;
  final double paddingHorizontal;
  final TextStyle textStyle;

  const _ChipSpecs({
    required this.height,
    required this.paddingVertical,
    required this.paddingHorizontal,
    required this.textStyle,
  });

  factory _ChipSpecs.fromSize(ChipSize size, Brightness brightness) {
    switch (size) {
      case ChipSize.small:
        return _ChipSpecs(
          height: 24,
          paddingVertical: 4,
          paddingHorizontal: 12,
          textStyle: TextStyles.labelSmall(brightness),
        );
      case ChipSize.medium:
        return _ChipSpecs(
          height: 32,
          paddingVertical: 8,
          paddingHorizontal: 16,
          textStyle: TextStyles.labelMedium(brightness),
        );
      case ChipSize.large:
        return _ChipSpecs(
          height: 40,
          paddingVertical: 10,
          paddingHorizontal: 20,
          textStyle: TextStyles.labelLarge(brightness),
        );
    }
  }
}

/// PRIMARY CHIP - Teal background + Black text
/// Flat design, no shadow, 16px radius
class AppChip extends StatelessWidget {
  final String label;
  final ChipSize size;
  final Widget? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;

  const AppChip({
    super.key,
    required this.label,
    this.size = ChipSize.medium,
    this.icon,
    this.onDeleted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _ChipSpecs.fromSize(size, brightness);

    return Material(
      color: AppColors.teal500,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: specs.height,
          padding: EdgeInsets.symmetric(
            horizontal: specs.paddingHorizontal,
            vertical: specs.paddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: specs.textStyle.copyWith(color: AppColors.black),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: specs.height * 0.5,
                    color: AppColors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// OUTLINED CHIP - Black outline + Black text
/// Flat design, no shadow, 16px radius
class AppChipOutlined extends StatelessWidget {
  final String label;
  final ChipSize size;
  final Widget? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;

  const AppChipOutlined({
    super.key,
    required this.label,
    this.size = ChipSize.medium,
    this.icon,
    this.onDeleted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _ChipSpecs.fromSize(size, brightness);
    final isDark = brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.white : AppColors.black,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: specs.height,
          padding: EdgeInsets.symmetric(
            horizontal: specs.paddingHorizontal,
            vertical: specs.paddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: specs.textStyle.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: specs.height * 0.5,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// NEUTRAL CHIP - Grey background + Black text
/// Flat design, no shadow, 16px radius
class AppChipNeutral extends StatelessWidget {
  final String label;
  final ChipSize size;
  final Widget? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;

  const AppChipNeutral({
    super.key,
    required this.label,
    this.size = ChipSize.medium,
    this.icon,
    this.onDeleted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _ChipSpecs.fromSize(size, brightness);
    final isDark = brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.neutral200 : AppColors.neutral300,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: specs.height,
          padding: EdgeInsets.symmetric(
            horizontal: specs.paddingHorizontal,
            vertical: specs.paddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: specs.textStyle.copyWith(color: AppColors.black),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: specs.height * 0.5,
                    color: AppColors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// SUCCESS CHIP - Green background + White text
/// Flat design, no shadow, 16px radius
class AppChipSuccess extends StatelessWidget {
  final String label;
  final ChipSize size;
  final Widget? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;

  const AppChipSuccess({
    super.key,
    required this.label,
    this.size = ChipSize.medium,
    this.icon,
    this.onDeleted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _ChipSpecs.fromSize(size, brightness);

    return Material(
      color: AppColors.success500,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: specs.height,
          padding: EdgeInsets.symmetric(
            horizontal: specs.paddingHorizontal,
            vertical: specs.paddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: specs.textStyle.copyWith(color: AppColors.white),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: specs.height * 0.5,
                    color: AppColors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ERROR CHIP - Red background + White text
/// Flat design, no shadow, 16px radius
class AppChipError extends StatelessWidget {
  final String label;
  final ChipSize size;
  final Widget? icon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;

  const AppChipError({
    super.key,
    required this.label,
    this.size = ChipSize.medium,
    this.icon,
    this.onDeleted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _ChipSpecs.fromSize(size, brightness);

    return Material(
      color: AppColors.error500,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: specs.height,
          padding: EdgeInsets.symmetric(
            horizontal: specs.paddingHorizontal,
            vertical: specs.paddingVertical,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: specs.textStyle.copyWith(color: AppColors.white),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: specs.height * 0.5,
                    color: AppColors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
