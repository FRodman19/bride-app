import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../foundation/gol_colors.dart';
import '../foundation/gol_spacing.dart';
import '../foundation/gol_typography.dart';

class GOLTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Always-visible trailing widget with flexible sizing (like badges).
  /// Unlike suffixIcon, this has no size constraints and is always visible.
  /// Unlike suffix, this doesn't disappear when the field loses focus.
  final Widget? trailingSuffix;
  final TextInputType? keyboardType;
  final int? maxLength;

  const GOLTextField({
    super.key,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.trailingSuffix,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    // Determine the effective suffix icon
    // trailingSuffix takes precedence and removes size constraints
    Widget? effectiveSuffixIcon = suffixIcon;
    BoxConstraints? suffixConstraints;

    if (trailingSuffix != null) {
      effectiveSuffixIcon = Padding(
        padding: const EdgeInsets.only(right: GOLSpacing.space3),
        child: trailingSuffix,
      );
      // Remove default 48x48 constraints for flexible sizing
      suffixConstraints = const BoxConstraints(minHeight: 0, minWidth: 0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: GOLSpacing.inputLabelGap),
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            helperText: helperText,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: prefixIcon,
                  )
                : null,
            prefixIconConstraints: prefixIcon != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: effectiveSuffixIcon,
            suffixIconConstraints: suffixConstraints,
          ),
        ),
      ],
    );
  }
}

class GOLSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? leadingIcon;

  const GOLSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    return TextField(
      controller: controller,
      onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: colors.backgroundTertiary,
          prefixIcon: leadingIcon ??
              Icon(
                Iconsax.search_normal,
                color: colors.textTertiary,
                size: 20,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
    );
  }
}

class GOLCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const GOLCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: GOLSpacing.space3),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

class GOLRadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;

  const GOLRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
        const SizedBox(width: GOLSpacing.space3),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

class GOLSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const GOLSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: value, onChanged: onChanged),
        const SizedBox(width: GOLSpacing.space3),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class GOLHelperText extends StatelessWidget {
  final String text;
  final Color color;

  const GOLHelperText({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GOLTypography.caption(color));
  }
}
