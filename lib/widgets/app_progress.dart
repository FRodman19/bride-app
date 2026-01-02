import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Progress bar size variants
enum ProgressSize {
  small,
  medium,
  large,
}

/// LINEAR PROGRESS BAR - Teal colored with rounded ends
/// Flat design, no shadow, fully rounded
class AppProgressLinear extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final ProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final bool showLabel;
  final String? customLabel;

  const AppProgressLinear({
    super.key,
    required this.value,
    this.size = ProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
    this.customLabel,
  });

  double get _height {
    switch (size) {
      case ProgressSize.small:
        return 4.0;
      case ProgressSize.medium:
        return 8.0;
      case ProgressSize.large:
        return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final progressColor = color ?? AppColors.teal500;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customLabel ?? 'Progress',
                style: TextStyles.bodySmall(brightness),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyles.bodySmall(brightness)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: _height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(999), // Fully rounded
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(999), // Fully rounded
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// CIRCULAR PROGRESS INDICATOR - Teal colored
/// Flat design, no shadow
class AppProgressCircular extends StatelessWidget {
  final double? value; // null for indeterminate
  final ProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final bool showLabel;

  const AppProgressCircular({
    super.key,
    this.value,
    this.size = ProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
  });

  double get _size {
    switch (size) {
      case ProgressSize.small:
        return 32.0;
      case ProgressSize.medium:
        return 48.0;
      case ProgressSize.large:
        return 64.0;
    }
  }

  double get _strokeWidth {
    switch (size) {
      case ProgressSize.small:
        return 3.0;
      case ProgressSize.medium:
        return 4.0;
      case ProgressSize.large:
        return 5.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final progressColor = color ?? AppColors.teal500;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);

    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: _strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(bgColor),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: value,
            strokeWidth: _strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          // Label
          if (showLabel && value != null)
            Text(
              '${(value! * 100).toInt()}%',
              style: TextStyles.labelSmall(brightness).copyWith(
                fontSize: size == ProgressSize.small ? 8 : 10,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

/// STEP PROGRESS INDICATOR - Shows progress through multiple steps
/// Flat design, no shadow, 16px radius on active step
class AppProgressSteps extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 0-indexed
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final List<String>? stepLabels;

  const AppProgressSteps({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final completedCol = completedColor ?? AppColors.success500;
    final inactiveCol = inactiveColor ??
        (isDark ? AppColors.neutral700 : AppColors.neutral300);

    return Column(
      children: [
        Row(
          children: List.generate(
            totalSteps,
            (index) {
              final isCompleted = index < currentStep;
              final isActive = index == currentStep;
              final color = isCompleted
                  ? completedCol
                  : isActive
                      ? activeCol
                      : inactiveCol;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    if (index < totalSteps - 1) const SizedBox(width: 4),
                  ],
                ),
              );
            },
          ),
        ),
        if (stepLabels != null && stepLabels!.length == totalSteps) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Text(
                  stepLabels![index],
                  style: TextStyles.bodySmall(brightness).copyWith(
                    fontWeight:
                        index == currentStep ? FontWeight.w600 : FontWeight.w400,
                    color: index <= currentStep
                        ? AppColors.primaryTextColor(brightness)
                        : AppColors.secondaryTextColor(brightness),
                  ),
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == totalSteps - 1
                          ? TextAlign.right
                          : TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// ANIMATED PROGRESS BAR - Linear progress with smooth animation
/// Flat design, no shadow, fully rounded
class AppProgressAnimated extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final ProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final Duration duration;
  final bool showLabel;
  final String? customLabel;

  const AppProgressAnimated({
    super.key,
    required this.value,
    this.size = ProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 300),
    this.showLabel = false,
    this.customLabel,
  });

  @override
  State<AppProgressAnimated> createState() => _AppProgressAnimatedState();
}

class _AppProgressAnimatedState extends State<AppProgressAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AppProgressAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return AppProgressLinear(
          value: _animation.value,
          size: widget.size,
          color: widget.color,
          backgroundColor: widget.backgroundColor,
          showLabel: widget.showLabel,
          customLabel: widget.customLabel,
        );
      },
    );
  }
}
