import 'package:flutter/material.dart';

import 'spacing.dart';
import 'progress.dart';
import 'theme.dart';

enum DSButtonVariant { primary, secondary, tertiary, text }

enum DSButtonSize { small, medium, large }

enum DSButtonState { normal, hover, pressed, disabled, loading }

class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DSButtonVariant.primary,
    this.size = DSButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.stateOverride,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DSButtonVariant variant;
  final DSButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final DSButtonState? stateOverride;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled =
        onPressed == null ||
        stateOverride == DSButtonState.disabled ||
        isLoading ||
        stateOverride == DSButtonState.loading;
    final visualState = _resolveState(disabled);

    final height = switch (size) {
      DSButtonSize.small => 36.0,
      DSButtonSize.medium => 44.0,
      DSButtonSize.large => 52.0,
    };

    final padding = DSSpacing.buttonPadding;

    final colors = _colorsForState(isDark, visualState);

    final style = ButtonStyle(
      padding: MaterialStateProperty.all(padding),
      minimumSize: MaterialStateProperty.all(
        Size(fullWidth ? double.infinity : 0, height),
      ),
      backgroundColor: MaterialStateProperty.all(colors.background),
      foregroundColor: MaterialStateProperty.all(colors.foreground),
      overlayColor: MaterialStateProperty.all(colors.overlay),
      side: MaterialStateProperty.all(colors.border),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        ),
      ),
      elevation: MaterialStateProperty.all(0),
    );

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: style,
      child: _buildChild(colors.foreground),
    );
  }

  DSButtonState _resolveState(bool disabled) {
    if (isLoading || stateOverride == DSButtonState.loading) {
      return DSButtonState.loading;
    }
    if (disabled) return DSButtonState.disabled;
    return stateOverride ?? DSButtonState.normal;
  }

  _ButtonColors _colorsForState(bool isDark, DSButtonState state) {
    final baseForeground = isDark ? DSColors.white : DSColors.black;

    switch (variant) {
      case DSButtonVariant.primary:
        return _ButtonColors(
          background: _resolveByState(
            state,
            normal: DSColors.orange500,
            hover: DSColors.orange500,
            pressed: DSColors.orange600,
            disabled: DSColors.neutral200,
            loading: DSColors.orange500,
          ),
          foreground: DSColors.black,
          overlay: DSColors.orange600.withOpacity(0.1),
          border: BorderSide.none,
        );
      case DSButtonVariant.secondary:
        return _ButtonColors(
          background: _resolveByState(
            state,
            normal: Colors.transparent,
            hover: DSColors.teal500.withOpacity(0.08),
            pressed: DSColors.teal600.withOpacity(0.12),
            disabled: Colors.transparent,
            loading: Colors.transparent,
          ),
          foreground: isDark ? DSColors.white : DSColors.black,
          overlay: DSColors.teal600.withOpacity(0.08),
          border: BorderSide(
            color: state == DSButtonState.disabled
                ? DSColors.neutral300
                : (isDark ? DSColors.white : DSColors.black),
            width: 1,
          ),
        );
      case DSButtonVariant.tertiary:
        return _ButtonColors(
          background: _resolveByState(
            state,
            normal: DSColors.neutral200,
            hover: DSColors.neutral200,
            pressed: DSColors.neutral300,
            disabled: DSColors.neutral100,
            loading: DSColors.neutral200,
          ),
          foreground: DSColors.black,
          overlay: DSColors.neutral300.withOpacity(0.2),
          border: BorderSide.none,
        );
      case DSButtonVariant.text:
        return _ButtonColors(
          background: _resolveByState(
            state,
            normal: Colors.transparent,
            hover: DSColors.teal500.withOpacity(0.1),
            pressed: DSColors.teal600.withOpacity(0.12),
            disabled: Colors.transparent,
            loading: Colors.transparent,
          ),
          foreground: state == DSButtonState.disabled
              ? DSColors.neutral500
              : (state == DSButtonState.pressed
                    ? DSColors.teal600
                    : DSColors.teal500),
          overlay: DSColors.teal600.withOpacity(0.08),
          border: BorderSide.none,
        );
    }
  }

  Color _resolveByState(
    DSButtonState state, {
    required Color normal,
    required Color hover,
    required Color pressed,
    required Color disabled,
    required Color loading,
  }) {
    switch (state) {
      case DSButtonState.hover:
        return hover;
      case DSButtonState.pressed:
        return pressed;
      case DSButtonState.disabled:
        return disabled;
      case DSButtonState.loading:
        return loading;
      case DSButtonState.normal:
        return normal;
    }
  }

  Widget _buildChild(Color foreground) {
    if (isLoading || stateOverride == DSButtonState.loading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: DSGridLoader(size: 18, color: foreground),
      );
    }

    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
    );
  }
}

class DSIconButton extends StatelessWidget {
  const DSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isActive
        ? DSColors.teal500
        : (isDark ? DSColors.surfaceDark : DSColors.surfaceLight);

    final iconColor = isActive
        ? DSColors.black
        : (isDark ? DSColors.white : DSColors.black);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}

class DSFab extends StatelessWidget {
  const DSFab({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.mini = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final size = mini ? 40.0 : 56.0;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: DSColors.black),
        if (label != null) ...[
          const SizedBox(width: 8),
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
        ],
      ],
    );

    return Material(
      color: DSColors.orange500,
      borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        child: Container(
          padding: label != null
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              : EdgeInsets.zero,
          width: label == null ? size : null,
          height: label == null ? size : null,
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.overlay,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color overlay;
  final BorderSide border;
}
