import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'spacing.dart';

class DSTextField extends StatelessWidget {
  const DSTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.enabled = true,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}

class DSSearchField extends StatelessWidget {
  const DSSearchField({
    super.key,
    this.hintText = 'Search',
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DSTextField(
      hintText: hintText,
      prefixIcon: Iconsax.search_normal,
      suffixIcon: Iconsax.close_circle,
    );
  }
}

class DSDropdown<T> extends StatelessWidget {
  const DSDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
      ),
      borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      icon: const Icon(Iconsax.arrow_down_1),
    );
  }
}

class DSCheckboxTile extends StatelessWidget {
  const DSCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: DSSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class DSRadioTile<T> extends StatelessWidget {
  const DSRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
        const SizedBox(width: DSSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class DSSwitchTile extends StatelessWidget {
  const DSSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: value, onChanged: onChanged),
        const SizedBox(width: DSSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class DSInputLabel extends StatelessWidget {
  const DSInputLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }
}

class DSFieldGroup extends StatelessWidget {
  const DSFieldGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((child) => [child, const SizedBox(height: DSSpacing.sm)])
          .toList()
        ..removeLast(),
    );
  }
}
