import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_radius.dart';
import '../foundation/gol_spacing.dart';

enum GOLButtonVariant { primary, secondary, tertiary, destructive }

enum GOLButtonSize { small, medium, large }

class GOLButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final GOLButtonVariant variant;
  final GOLButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;

  const GOLButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = GOLButtonVariant.primary,
    this.size = GOLButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final config = _sizeConfig(size);
    final style = _buttonStyle(context, colors, config);

    final child = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0 : 1,
          child: _ButtonContent(
            label: label,
            icon: icon,
            gap: config.iconGap,
          ),
        ),
        if (isLoading)
          SizedBox(
            height: config.spinnerSize,
            width: config.spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _spinnerColor(colors),
              ),
            ),
          ),
      ],
    );

    final button = SizedBox(
      height: config.height,
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
    );

    return button;
  }

  Color _spinnerColor(GOLSemanticColors colors) {
    switch (variant) {
      case GOLButtonVariant.primary:
      case GOLButtonVariant.destructive:
        return colors.textInverse;
      case GOLButtonVariant.secondary:
      case GOLButtonVariant.tertiary:
        return colors.textAccent;
    }
  }

  ButtonStyle _buttonStyle(
    BuildContext context,
    GOLSemanticColors colors,
    _ButtonSizeConfig config,
  ) {
    final textStyle = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(fontSize: config.fontSize);

    final borderSide = variant == GOLButtonVariant.secondary
        ? BorderSide(color: colors.borderDefault, width: 1.5)
        : BorderSide.none;

    Color backgroundFor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (variant == GOLButtonVariant.secondary ||
            variant == GOLButtonVariant.tertiary) {
          return Colors.transparent;
        }
        return colors.interactivePrimaryDisabled;
      }

      switch (variant) {
        case GOLButtonVariant.primary:
          if (states.contains(WidgetState.pressed)) {
            return colors.interactivePrimaryPressed;
          }
          if (states.contains(WidgetState.hovered)) {
            return colors.interactivePrimaryHover;
          }
          return colors.interactivePrimary;
        case GOLButtonVariant.secondary:
          if (states.contains(WidgetState.pressed)) {
            return colors.backgroundTertiary;
          }
          if (states.contains(WidgetState.hovered)) {
            return colors.backgroundSecondary;
          }
          return Colors.transparent;
        case GOLButtonVariant.tertiary:
          return Colors.transparent;
        case GOLButtonVariant.destructive:
          if (states.contains(WidgetState.pressed)) {
            return GOLPrimitives.error600;
          }
          if (states.contains(WidgetState.hovered)) {
            return GOLPrimitives.error600;
          }
          return GOLPrimitives.error500;
      }
    }

    Color foregroundFor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colors.textDisabled;
      }

      switch (variant) {
        case GOLButtonVariant.primary:
        case GOLButtonVariant.destructive:
          return colors.textInverse;
        case GOLButtonVariant.secondary:
          return colors.textPrimary;
        case GOLButtonVariant.tertiary:
          return colors.textAccent;
      }
    }

    return TextButton.styleFrom(
      padding: config.padding,
      backgroundColor: backgroundFor(<WidgetState>{}),
      foregroundColor: colors.textPrimary,
      textStyle: textStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.radius),
        side: borderSide,
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith(backgroundFor),
      foregroundColor: WidgetStateProperty.resolveWith(foregroundFor),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      textStyle: WidgetStateProperty.all(textStyle),
    );
  }
}

class _ButtonSizeConfig {
  final double height;
  final EdgeInsets padding;
  final double fontSize;
  final double radius;
  final double iconGap;
  final double spinnerSize;

  const _ButtonSizeConfig({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.radius,
    required this.iconGap,
    required this.spinnerSize,
  });
}

_ButtonSizeConfig _sizeConfig(GOLButtonSize size) {
  switch (size) {
    case GOLButtonSize.large:
      return const _ButtonSizeConfig(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: GOLSpacing.buttonPaddingHorizontalLg,
          vertical: GOLSpacing.buttonPaddingVerticalLg,
        ),
        fontSize: 16,
        radius: GOLRadius.buttonStandard,
        iconGap: 12,
        spinnerSize: 20,
      );
    case GOLButtonSize.medium:
      return const _ButtonSizeConfig(
        height: 40,
        padding: EdgeInsets.symmetric(
          horizontal: GOLSpacing.buttonPaddingHorizontalMd,
          vertical: GOLSpacing.buttonPaddingVerticalMd,
        ),
        fontSize: 14,
        radius: GOLRadius.buttonStandard,
        iconGap: 12,
        spinnerSize: 20,
      );
    case GOLButtonSize.small:
      return const _ButtonSizeConfig(
        height: 32,
        padding: EdgeInsets.symmetric(
          horizontal: GOLSpacing.buttonPaddingHorizontalSm,
          vertical: GOLSpacing.buttonPaddingVerticalSm,
        ),
        fontSize: 12,
        radius: GOLRadius.buttonSmall,
        iconGap: 8,
        spinnerSize: 16,
      );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final Widget? icon;
  final double gap;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon!,
        SizedBox(width: gap),
        Text(label),
      ],
    );
  }
}
