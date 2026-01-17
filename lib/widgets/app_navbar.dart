import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Navigation bar item model
class AppNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final Widget? badge;

  const AppNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge,
  });
}

/// BOTTOM NAVIGATION BAR - Standard bottom nav
/// Flat design, no shadow
class AppBottomNavBar extends StatelessWidget {
  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final bool showLabels;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol =
        inactiveColor ?? (isDark ? AppColors.neutral400 : AppColors.neutral600);
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.neutral900 : AppColors.white);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: isActive
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 4,
                                    )
                                  : EdgeInsets.zero,
                              decoration: isActive
                                  ? BoxDecoration(
                                      color: activeCol,
                                      borderRadius: BorderRadius.circular(16),
                                    )
                                  : null,
                              child: Icon(
                                isActive && item.activeIcon != null
                                    ? item.activeIcon
                                    : item.icon,
                                color: isActive ? AppColors.black : inactiveCol,
                                size: 24,
                              ),
                            ),
                            if (item.badge != null)
                              Positioned(
                                right: -8,
                                top: -4,
                                child: item.badge!,
                              ),
                          ],
                        ),
                        if (showLabels) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyles.labelSmall(brightness).copyWith(
                              color: isActive
                                  ? (isDark ? AppColors.white : AppColors.black)
                                  : inactiveCol,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// FLOATING BOTTOM NAV BAR - Elevated bottom nav with rounded corners
/// Flat design, no shadow, 16px radius
class AppBottomNavBarFloating extends StatelessWidget {
  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;

  const AppBottomNavBarFloating({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTabChanged,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final activeCol = activeColor ?? AppColors.teal500;
    final inactiveCol =
        inactiveColor ?? (isDark ? AppColors.neutral400 : AppColors.neutral600);
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.neutral800 : AppColors.white);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16), // 16px radius
          border: Border.all(
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(index),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: isActive
                                ? const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  )
                                : EdgeInsets.zero,
                            decoration: isActive
                                ? BoxDecoration(
                                    color: activeCol,
                                    borderRadius: BorderRadius.circular(16),
                                  )
                                : null,
                            child: Icon(
                              isActive && item.activeIcon != null
                                  ? item.activeIcon
                                  : item.icon,
                              color: isActive ? AppColors.black : inactiveCol,
                              size: 24,
                            ),
                          ),
                          if (item.badge != null)
                            Positioned(right: -8, top: -4, child: item.badge!),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyles.labelSmall(brightness).copyWith(
                          color: isActive
                              ? (isDark ? AppColors.white : AppColors.black)
                              : inactiveCol,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// TOP APP BAR - Standard app bar with actions
/// Flat design, no shadow
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final double? elevation;

  const AppTopBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = false,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.neutral900 : AppColors.white);
    final fgColor =
        foregroundColor ?? (isDark ? AppColors.white : AppColors.black);

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyles.titleLarge(brightness).copyWith(color: fgColor),
            )
          : null,
      leading: leading,
      actions: actions,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      centerTitle: centerTitle,
      elevation: elevation ?? 0, // Flat design - no shadow
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// SEARCH APP BAR - App bar with integrated search field
/// Flat design, no shadow, 16px radius for search field
class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSearchPressed,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.neutral900 : AppColors.white);

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0, // Flat design
      surfaceTintColor: Colors.transparent,
      leading: leading,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? AppColors.neutral800 : AppColors.neutral200,
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyles.bodyMedium(brightness),
          decoration: InputDecoration(
            hintText: hintText ?? 'Search...',
            hintStyle: TextStyles.bodyMedium(
              brightness,
            ).copyWith(color: AppColors.secondaryTextColor(brightness)),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.secondaryTextColor(brightness),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// NAVIGATION DRAWER - Side navigation drawer
/// Flat design, no shadow
class AppNavDrawer extends StatelessWidget {
  final Widget? header;
  final List<AppNavDrawerItem> items;
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final Widget? footer;

  const AppNavDrawer({
    super.key,
    this.header,
    required this.items,
    this.selectedIndex,
    this.onItemSelected,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.neutral900 : AppColors.white,
      child: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Material(
                    color: isSelected
                        ? AppColors.teal500.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16), // 16px radius
                    child: InkWell(
                      onTap: () => onItemSelected?.call(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected
                                  ? AppColors.teal500
                                  : (isDark
                                        ? AppColors.neutral400
                                        : AppColors.neutral600),
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyles.bodyMedium(brightness)
                                    .copyWith(
                                      color: isSelected
                                          ? AppColors.teal500
                                          : AppColors.primaryTextColor(
                                              brightness,
                                            ),
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                              ),
                            ),
                            if (item.badge != null) item.badge!,
                            if (item.trailing != null) item.trailing!,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Navigation drawer item model
class AppNavDrawerItem {
  final String label;
  final IconData icon;
  final Widget? badge;
  final Widget? trailing;

  const AppNavDrawerItem({
    required this.label,
    required this.icon,
    this.badge,
    this.trailing,
  });
}
