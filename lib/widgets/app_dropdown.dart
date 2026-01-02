import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Dropdown item model
class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

/// DROPDOWN BUTTON - Custom styled dropdown menu
/// Flat design, no shadow, 16px radius
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? borderColor;

  const AppDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.label,
    this.prefixIcon,
    this.isExpanded = true,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.neutral900 : AppColors.white);
    final bColor = borderColor ??
        (isDark ? AppColors.neutral600 : AppColors.neutral400);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyles.labelMedium(brightness),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16), // 16px radius
            border: Border.all(color: bColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: isExpanded,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: TextStyles.bodyMedium(brightness).copyWith(
                        color: AppColors.secondaryTextColor(brightness),
                      ),
                    )
                  : null,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              style: TextStyles.bodyMedium(brightness),
              dropdownColor: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item.value,
                  enabled: item.enabled,
                  child: Row(
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: 12),
                      ],
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 20,
                          color: item.enabled
                              ? (isDark ? AppColors.white : AppColors.black)
                              : AppColors.secondaryTextColor(brightness),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyles.bodyMedium(brightness).copyWith(
                            color: item.enabled
                                ? AppColors.primaryTextColor(brightness)
                                : AppColors.secondaryTextColor(brightness),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// MULTI-SELECT DROPDOWN - Dropdown allowing multiple selections
/// Flat design, no shadow, 16px radius
class AppDropdownMultiSelect<T> extends StatefulWidget {
  final List<T> selectedValues;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<List<T>>? onChanged;
  final String? hint;
  final String? label;
  final Color? backgroundColor;
  final Color? borderColor;

  const AppDropdownMultiSelect({
    super.key,
    required this.selectedValues,
    required this.items,
    this.onChanged,
    this.hint,
    this.label,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<AppDropdownMultiSelect<T>> createState() =>
      _AppDropdownMultiSelectState<T>();
}

class _AppDropdownMultiSelectState<T>
    extends State<AppDropdownMultiSelect<T>> {
  bool _isOpen = false;

  void _toggleItem(T value) {
    final List<T> newSelection = List.from(widget.selectedValues);
    if (newSelection.contains(value)) {
      newSelection.remove(value);
    } else {
      newSelection.add(value);
    }
    widget.onChanged?.call(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.neutral900 : AppColors.white);
    final bColor = widget.borderColor ??
        (isDark ? AppColors.neutral600 : AppColors.neutral400);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.labelMedium(brightness),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: bColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedValues.isEmpty
                        ? (widget.hint ?? 'Select items')
                        : '${widget.selectedValues.length} selected',
                    style: TextStyles.bodyMedium(brightness).copyWith(
                      color: widget.selectedValues.isEmpty
                          ? AppColors.secondaryTextColor(brightness)
                          : AppColors.primaryTextColor(brightness),
                    ),
                  ),
                ),
                Icon(
                  _isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isOpen) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: bColor, width: 1),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = widget.selectedValues.contains(item.value);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.enabled ? () => _toggleItem(item.value) : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: item.enabled
                                ? (value) => _toggleItem(item.value)
                                : null,
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.teal500;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              size: 20,
                              color: item.enabled
                                  ? (isDark
                                      ? AppColors.white
                                      : AppColors.black)
                                  : AppColors.secondaryTextColor(brightness),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyles.bodyMedium(brightness).copyWith(
                                color: item.enabled
                                    ? AppColors.primaryTextColor(brightness)
                                    : AppColors.secondaryTextColor(brightness),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// SEARCHABLE DROPDOWN - Dropdown with search functionality
/// Flat design, no shadow, 16px radius
class AppDropdownSearchable<T> extends StatefulWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? label;
  final String searchHint;
  final Color? backgroundColor;
  final Color? borderColor;

  const AppDropdownSearchable({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.label,
    this.searchHint = 'Search...',
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<AppDropdownSearchable<T>> createState() =>
      _AppDropdownSearchableState<T>();
}

class _AppDropdownSearchableState<T> extends State<AppDropdownSearchable<T>> {
  bool _isOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<AppDropdownItem<T>> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items
        .where((item) =>
            item.label.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.neutral900 : AppColors.white);
    final bColor = widget.borderColor ??
        (isDark ? AppColors.neutral600 : AppColors.neutral400);

    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => AppDropdownItem<T>(
        value: widget.value as T,
        label: widget.hint ?? '',
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.labelMedium(brightness),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: bColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? selectedItem.label
                        : (widget.hint ?? 'Select'),
                    style: TextStyles.bodyMedium(brightness).copyWith(
                      color: widget.value != null
                          ? AppColors.primaryTextColor(brightness)
                          : AppColors.secondaryTextColor(brightness),
                    ),
                  ),
                ),
                Icon(
                  _isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isOpen) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16), // 16px radius
              border: Border.all(color: bColor, width: 1),
            ),
            child: Column(
              children: [
                // Search field
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: bColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: bColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.teal500),
                      ),
                    ),
                  ),
                ),
                // Results list
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = widget.value == item.value;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: item.enabled
                              ? () {
                                  widget.onChanged?.call(item.value);
                                  setState(() {
                                    _isOpen = false;
                                    _searchQuery = '';
                                    _searchController.clear();
                                  });
                                }
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            color: isSelected
                                ? AppColors.teal500.withValues(alpha: 0.1)
                                : null,
                            child: Row(
                              children: [
                                if (item.icon != null) ...[
                                  Icon(
                                    item.icon,
                                    size: 20,
                                    color: item.enabled
                                        ? (isDark
                                            ? AppColors.white
                                            : AppColors.black)
                                        : AppColors.secondaryTextColor(
                                            brightness),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyles.bodyMedium(brightness)
                                        .copyWith(
                                      color: item.enabled
                                          ? AppColors.primaryTextColor(
                                              brightness)
                                          : AppColors.secondaryTextColor(
                                              brightness),
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.teal500,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
