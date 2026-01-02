import 'package:flutter/material.dart';

import '../foundation/gol_colors.dart';

class GOLSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final int? divisions;

  const GOLSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: colors.interactivePrimary,
        inactiveTrackColor: colors.backgroundTertiary,
        thumbColor: colors.interactivePrimary,
        overlayColor: colors.interactivePrimary.withValues(alpha: 0.12),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        divisions: divisions,
      ),
    );
  }
}

class GOLRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const GOLRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: colors.interactivePrimary,
        inactiveTrackColor: colors.backgroundTertiary,
        thumbColor: colors.interactivePrimary,
        overlayColor: colors.interactivePrimary.withValues(alpha: 0.12),
      ),
      child: RangeSlider(
        values: values,
        onChanged: onChanged,
      ),
    );
  }
}
