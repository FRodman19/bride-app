import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Tab item model
class AppTabItem {
  final String label;
  final IconData? icon;
  final Widget? badge;

  const AppTabItem({
    required this.label,
    this.icon,
    this.badge,
  });
}

/// TAB BAR - Horizontal tab navigation
/// Flat design, no shadow, rounded active indicator
class AppTabs extends StatelessWidget {
  final List<AppTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final bool showIndicator;

  const AppTabs({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol = inactiveColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);
    final indicatorCol = indicatorColor ?? AppColors.teal500;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isActive = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: showIndicator && isActive
                      ? Border(
                          bottom: BorderSide(
                            color: indicatorCol,
                            width: 3,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tab.icon != null) ...[
                          Icon(
                            tab.icon,
                            size: 20,
                            color: isActive ? activeCol : inactiveCol,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          tab.label,
                          style: TextStyles.labelMedium(brightness).copyWith(
                            color: isActive ? activeCol : inactiveCol,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (tab.badge != null) ...[
                          const SizedBox(width: 6),
                          tab.badge!,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// PILL TABS - Rounded pill-style tabs
/// Flat design, no shadow, 16px radius
class AppTabsPill extends StatelessWidget {
  final List<AppTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const AppTabsPill({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol = inactiveColor ?? Colors.transparent;
    final activeTxtCol = activeTextColor ?? AppColors.black;
    final inactiveTxtCol = inactiveTextColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral200,
        borderRadius: BorderRadius.circular(16), // 16px radius
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isActive = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? activeCol : inactiveCol,
                  borderRadius: BorderRadius.circular(16), // 16px radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 16,
                        color: isActive ? activeTxtCol : inactiveTxtCol,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      tab.label,
                      style: TextStyles.labelMedium(brightness).copyWith(
                        color: isActive ? activeTxtCol : inactiveTxtCol,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (tab.badge != null) ...[
                      const SizedBox(width: 6),
                      tab.badge!,
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// BUTTON TABS - Button-style tabs
/// Flat design, no shadow, 16px radius
class AppTabsButton extends StatelessWidget {
  final List<AppTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final double spacing;

  const AppTabsButton({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol = inactiveColor ??
        (isDark ? AppColors.neutral800 : AppColors.neutral200);
    final activeTxtCol = activeTextColor ?? AppColors.black;
    final inactiveTxtCol = inactiveTextColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);

    return Row(
      children: List.generate(tabs.length, (index) {
        final tab = tabs[index];
        final isActive = index == currentIndex;

        return Padding(
          padding: EdgeInsets.only(right: index < tabs.length - 1 ? spacing : 0),
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? activeCol : inactiveCol,
                borderRadius: BorderRadius.circular(16), // 16px radius
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.icon != null) ...[
                    Icon(
                      tab.icon,
                      size: 16,
                      color: isActive ? activeTxtCol : inactiveTxtCol,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    tab.label,
                    style: TextStyles.labelMedium(brightness).copyWith(
                      color: isActive ? activeTxtCol : inactiveTxtCol,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (tab.badge != null) ...[
                    const SizedBox(width: 6),
                    tab.badge!,
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// VERTICAL TABS - Vertical tab navigation
/// Flat design, no shadow, 16px radius for active indicator
class AppTabsVertical extends StatelessWidget {
  final List<AppTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;

  const AppTabsVertical({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol = inactiveColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);
    final indicatorCol = indicatorColor ?? AppColors.teal500;

    return Column(
      children: List.generate(tabs.length, (index) {
        final tab = tabs[index];
        final isActive = index == currentIndex;

        return GestureDetector(
          onTap: () => onTabChanged(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isActive ? indicatorCol : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                if (tab.icon != null) ...[
                  Icon(
                    tab.icon,
                    size: 20,
                    color: isActive ? activeCol : inactiveCol,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    tab.label,
                    style: TextStyles.labelMedium(brightness).copyWith(
                      color: isActive ? activeCol : inactiveCol,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (tab.badge != null) tab.badge!,
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// SCROLLABLE TABS - Horizontal scrollable tabs for many items
/// Flat design, no shadow, rounded active indicator
class AppTabsScrollable extends StatelessWidget {
  final List<AppTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;

  const AppTabsScrollable({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol = inactiveColor ??
        (isDark ? AppColors.neutral400 : AppColors.neutral600);
    final indicatorCol = indicatorColor ?? AppColors.teal500;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isActive = index == currentIndex;

            return GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: isActive
                      ? Border(
                          bottom: BorderSide(
                            color: indicatorCol,
                            width: 3,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 20,
                        color: isActive ? activeCol : inactiveCol,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      tab.label,
                      style: TextStyles.labelMedium(brightness).copyWith(
                        color: isActive ? activeCol : inactiveCol,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (tab.badge != null) ...[
                      const SizedBox(width: 6),
                      tab.badge!,
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
