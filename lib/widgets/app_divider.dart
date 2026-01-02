import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Divider thickness variants
enum DividerThickness {
  thin, // 1px
  medium, // 2px
  thick, // 4px
}

/// HORIZONTAL DIVIDER - Clean separator for content sections
/// Flat design
class AppDivider extends StatelessWidget {
  final DividerThickness thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final double? height; // Total height including margins

  const AppDivider({
    super.key,
    this.thickness = DividerThickness.thin,
    this.color,
    this.indent,
    this.endIndent,
    this.height,
  });

  double get _thickness {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final dividerColor = color ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);

    return Divider(
      thickness: _thickness,
      color: dividerColor,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}

/// VERTICAL DIVIDER - Clean separator for horizontal layouts
/// Flat design
class AppDividerVertical extends StatelessWidget {
  final DividerThickness thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final double? width; // Total width including margins

  const AppDividerVertical({
    super.key,
    this.thickness = DividerThickness.thin,
    this.color,
    this.indent,
    this.endIndent,
    this.width,
  });

  double get _thickness {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final dividerColor = color ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);

    return VerticalDivider(
      thickness: _thickness,
      color: dividerColor,
      indent: indent,
      endIndent: endIndent,
      width: width,
    );
  }
}

/// DIVIDER WITH LABEL - Divider with centered text
/// Flat design
class AppDividerWithLabel extends StatelessWidget {
  final String label;
  final DividerThickness thickness;
  final Color? color;
  final Color? labelColor;

  const AppDividerWithLabel({
    super.key,
    required this.label,
    this.thickness = DividerThickness.thin,
    this.color,
    this.labelColor,
  });

  double get _thickness {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final dividerColor = color ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);
    final txtColor = labelColor ?? AppColors.secondaryTextColor(brightness);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: _thickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyles.bodySmall(brightness).copyWith(
              color: txtColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: _thickness,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}

/// DIVIDER WITH ICON - Divider with centered icon
/// Flat design
class AppDividerWithIcon extends StatelessWidget {
  final IconData icon;
  final DividerThickness thickness;
  final Color? color;
  final Color? iconColor;
  final double iconSize;

  const AppDividerWithIcon({
    super.key,
    required this.icon,
    this.thickness = DividerThickness.thin,
    this.color,
    this.iconColor,
    this.iconSize = 16,
  });

  double get _thickness {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final dividerColor = color ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);
    final iColor = iconColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: _thickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            icon,
            size: iconSize,
            color: iColor,
          ),
        ),
        Expanded(
          child: Container(
            height: _thickness,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}

/// SECTION DIVIDER - Bold divider for major section breaks
/// Flat design with optional label
class AppSectionDivider extends StatelessWidget {
  final String? label;
  final Color? color;
  final Color? labelColor;

  const AppSectionDivider({
    super.key,
    this.label,
    this.color,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final dividerColor = color ??
        (isDark ? AppColors.neutral600 : AppColors.neutral400);
    final txtColor = labelColor ?? AppColors.primaryTextColor(brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyles.labelLarge(brightness).copyWith(
              color: txtColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: dividerColor,
            borderRadius: BorderRadius.circular(999), // Fully rounded
          ),
        ),
      ],
    );
  }
}

/// GRADIENT DIVIDER - Divider with gradient effect
/// Flat design
class AppDividerGradient extends StatelessWidget {
  final DividerThickness thickness;
  final List<Color>? colors;
  final double? height;

  const AppDividerGradient({
    super.key,
    this.thickness = DividerThickness.thin,
    this.colors,
    this.height,
  });

  double get _thickness {
    switch (thickness) {
      case DividerThickness.thin:
        return 1.0;
      case DividerThickness.medium:
        return 2.0;
      case DividerThickness.thick:
        return 4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final gradientColors = colors ??
        (isDark
            ? [
                AppColors.neutral800,
                AppColors.neutral600,
                AppColors.neutral800,
              ]
            : [
                AppColors.neutral200,
                AppColors.neutral400,
                AppColors.neutral200,
              ]);

    return Container(
      height: height ?? _thickness,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
