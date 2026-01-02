import 'package:flutter/material.dart';

import 'spacing.dart';
import 'theme.dart';

class DSSlider extends StatelessWidget {
  const DSSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: DSSpacing.componentRadius,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: DSSpacing.componentRadius * 2,
        ),
        activeTrackColor: DSColors.teal500,
        inactiveTrackColor: DSColors.neutral200,
        thumbColor: DSColors.teal500,
        overlayColor: DSColors.teal500.withOpacity(0.2),
        valueIndicatorColor: DSColors.teal500,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        inactiveColor: DSColors.neutral200,
      ),
    );
  }
}
