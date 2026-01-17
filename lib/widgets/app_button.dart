import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Button size variants
enum ButtonSize { small, medium, large }

/// Get button specs based on size
class _ButtonSpecs {
  final double height;
  final double paddingVertical;
  final double paddingHorizontal;
  final TextStyle textStyle;

  const _ButtonSpecs({
    required this.height,
    required this.paddingVertical,
    required this.paddingHorizontal,
    required this.textStyle,
  });

  factory _ButtonSpecs.fromSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSpecs(
          height: 36,
          paddingVertical: 8,
          paddingHorizontal: 16,
          textStyle: TextStyles.buttonTextSmall(),
        );
      case ButtonSize.medium:
        return _ButtonSpecs(
          height: 48,
          paddingVertical: 8,
          paddingHorizontal: 16,
          textStyle: TextStyles.buttonText(),
        );
      case ButtonSize.large:
        return _ButtonSpecs(
          height: 56,
          paddingVertical: 16,
          paddingHorizontal: 24,
          textStyle: TextStyles.buttonTextLarge(),
        );
    }
  }
}

/// PRIMARY BUTTON - Teal background + Black text
/// Flat design, no shadow, 16px radius
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final specs = _ButtonSpecs.fromSize(size);

    return SizedBox(
      height: specs.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.teal700; // Darker teal when pressed
            }
            if (states.contains(WidgetState.disabled)) {
              return AppColors.teal500.withValues(alpha: 0.5);
            }
            return AppColors.teal500;
          }),
          foregroundColor: const WidgetStatePropertyAll(AppColors.black),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: specs.paddingVertical,
              horizontal: specs.paddingHorizontal,
            ),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          textStyle: WidgetStatePropertyAll(specs.textStyle),
        ),
        child: isLoading
            ? SizedBox(
                height: specs.height * 0.5,
                width: specs.height * 0.5,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(text)],
              )
            : Text(text),
      ),
    );
  }
}

/// SECONDARY BUTTON - Outline button with black text (white in dark mode)
/// Flat design, no shadow, 16px radius
class AppButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final Widget? icon;

  const AppButtonSecondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final specs = _ButtonSpecs.fromSize(size);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: specs.height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.white : AppColors.black,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: specs.paddingVertical,
            horizontal: specs.paddingHorizontal,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          side: BorderSide(
            color: isDark ? AppColors.white : AppColors.black,
            width: 1,
          ),
          elevation: 0,
          textStyle: specs.textStyle.copyWith(
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(text)],
              )
            : Text(text),
      ),
    );
  }
}

/// TERTIARY BUTTON - Grey background + Black text
/// Flat design, no shadow, 16px radius
class AppButtonTertiary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final Widget? icon;

  const AppButtonTertiary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final specs = _ButtonSpecs.fromSize(size);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: specs.height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.black,
          backgroundColor: isDark ? AppColors.neutral200 : AppColors.neutral300,
          padding: EdgeInsets.symmetric(
            vertical: specs.paddingVertical,
            horizontal: specs.paddingHorizontal,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 0,
          textStyle: specs.textStyle,
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(text)],
              )
            : Text(text),
      ),
    );
  }
}

/// DESTRUCTIVE BUTTON - Red background + White text
/// Flat design, no shadow, 16px radius
class AppButtonDestructive extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final Widget? icon;

  const AppButtonDestructive({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final specs = _ButtonSpecs.fromSize(size);

    return SizedBox(
      height: specs.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error500,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(
            vertical: specs.paddingVertical,
            horizontal: specs.paddingHorizontal,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: specs.textStyle.copyWith(color: AppColors.white),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(text)],
              )
            : Text(text),
      ),
    );
  }
}
