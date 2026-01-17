import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Badge size variants
enum BadgeSize { small, medium, large }

/// Badge type for different use cases
enum BadgeType {
  dot, // Small colored dot (no text)
  count, // Number badge
  label, // Text badge
}

/// Get badge specs based on size and type
class _BadgeSpecs {
  final double height;
  final double? width; // null for flexible width
  final double paddingHorizontal;
  final double paddingVertical;
  final TextStyle? textStyle;

  const _BadgeSpecs({
    required this.height,
    this.width,
    required this.paddingHorizontal,
    required this.paddingVertical,
    this.textStyle,
  });

  factory _BadgeSpecs.fromSize(
    BadgeSize size,
    BadgeType type,
    Brightness brightness,
  ) {
    switch (type) {
      case BadgeType.dot:
        switch (size) {
          case BadgeSize.small:
            return const _BadgeSpecs(
              height: 8,
              width: 8,
              paddingHorizontal: 0,
              paddingVertical: 0,
            );
          case BadgeSize.medium:
            return const _BadgeSpecs(
              height: 12,
              width: 12,
              paddingHorizontal: 0,
              paddingVertical: 0,
            );
          case BadgeSize.large:
            return const _BadgeSpecs(
              height: 16,
              width: 16,
              paddingHorizontal: 0,
              paddingVertical: 0,
            );
        }
      case BadgeType.count:
        switch (size) {
          case BadgeSize.small:
            return _BadgeSpecs(
              height: 16,
              paddingHorizontal: 4,
              paddingVertical: 2,
              textStyle: TextStyles.labelSmall(
                brightness,
              ).copyWith(fontSize: 10, height: 1.2),
            );
          case BadgeSize.medium:
            return _BadgeSpecs(
              height: 20,
              paddingHorizontal: 6,
              paddingVertical: 3,
              textStyle: TextStyles.labelSmall(
                brightness,
              ).copyWith(fontSize: 11, height: 1.2),
            );
          case BadgeSize.large:
            return _BadgeSpecs(
              height: 24,
              paddingHorizontal: 8,
              paddingVertical: 4,
              textStyle: TextStyles.labelMedium(
                brightness,
              ).copyWith(height: 1.2),
            );
        }
      case BadgeType.label:
        switch (size) {
          case BadgeSize.small:
            return _BadgeSpecs(
              height: 20,
              paddingHorizontal: 8,
              paddingVertical: 4,
              textStyle: TextStyles.labelSmall(brightness),
            );
          case BadgeSize.medium:
            return _BadgeSpecs(
              height: 24,
              paddingHorizontal: 10,
              paddingVertical: 5,
              textStyle: TextStyles.labelMedium(brightness),
            );
          case BadgeSize.large:
            return _BadgeSpecs(
              height: 28,
              paddingHorizontal: 12,
              paddingVertical: 6,
              textStyle: TextStyles.labelLarge(brightness),
            );
        }
    }
  }
}

/// SUCCESS BADGE - Elegant green for positive status
/// Flat design, no shadow, fully rounded
class AppBadgeSuccess extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgeSuccess({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: const BoxDecoration(
          color: AppColors.success500,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.success500,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.white, height: 1.0),
        ),
      ),
    );
  }
}

/// ERROR BADGE - Elegant red for negative status/alerts
/// Flat design, no shadow, fully rounded
class AppBadgeError extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgeError({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: const BoxDecoration(
          color: AppColors.error500,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.error500,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.white, height: 1.0),
        ),
      ),
    );
  }
}

/// WARNING BADGE - Elegant amber for warnings
/// Flat design, no shadow, fully rounded
class AppBadgeWarning extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgeWarning({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: const BoxDecoration(
          color: AppColors.warning500,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning500,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.black, height: 1.0),
        ),
      ),
    );
  }
}

/// INFO BADGE - Elegant blue for information
/// Flat design, no shadow, fully rounded
class AppBadgeInfo extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgeInfo({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: const BoxDecoration(
          color: AppColors.info500,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.info500,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.white, height: 1.0),
        ),
      ),
    );
  }
}

/// PRIMARY BADGE - Elegant teal for primary actions/status
/// Flat design, no shadow, fully rounded
class AppBadgePrimary extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgePrimary({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: const BoxDecoration(
          color: AppColors.teal500,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.teal500,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.black, height: 1.0),
        ),
      ),
    );
  }
}

/// NEUTRAL BADGE - Elegant grey for neutral/inactive status
/// Flat design, no shadow, fully rounded
class AppBadgeNeutral extends StatelessWidget {
  final String? label;
  final BadgeSize size;
  final BadgeType type;

  const AppBadgeNeutral({
    super.key,
    this.label,
    this.size = BadgeSize.medium,
    this.type = BadgeType.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final specs = _BadgeSpecs.fromSize(size, type, brightness);
    final isDark = brightness == Brightness.dark;

    if (type == BadgeType.dot) {
      return Container(
        width: specs.width,
        height: specs.height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral200 : AppColors.neutral400,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      height: specs.height,
      padding: EdgeInsets.symmetric(
        horizontal: specs.paddingHorizontal,
        vertical: specs.paddingVertical,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral200 : AppColors.neutral400,
        borderRadius: BorderRadius.circular(999), // Fully rounded
      ),
      child: Center(
        child: Text(
          label ?? '',
          style: specs.textStyle?.copyWith(color: AppColors.black, height: 1.0),
        ),
      ),
    );
  }
}
