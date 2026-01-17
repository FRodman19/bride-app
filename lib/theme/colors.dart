import 'package:flutter/material.dart';

/// Premium color system for Grow Out Loud app
/// Design Direction: Modern Premium with Vibrant Energy
/// Primary: Vibrant Teal - Visible, energetic, growth-focused
/// NO GRADIENTS - Solid colors only
class AppColors {
  // ========== PRIMARY TEAL (Premium, Vibrant, Visible) ==========
  // Modern teal/cyan - perfect mobile visibility, growth-oriented
  static const Color teal50 = Color(0xFFECFEFF); // Lightest tint
  static const Color teal100 = Color(0xFFCFFAFE);
  static const Color teal200 = Color(0xFFA5F3FC); // Light accent
  static const Color teal300 = Color(0xFF67E8F9);
  static const Color teal400 = Color(0xFF22D3EE); // Bright highlight
  static const Color teal500 = Color(
    0xFF06B6D4,
  ); // PRIMARY BRAND COLOR ⭐ (vibrant teal)
  static const Color teal600 = Color(0xFF0891B2); // Primary dark variant
  static const Color teal700 = Color(0xFF0E7490); // Deep teal
  static const Color teal800 = Color(0xFF155E75);
  static const Color teal900 = Color(0xFF164E63); // Darkest
  static const Color teal950 = Color(0xFF083344);

  // ========== WARM NEUTRAL PALETTE (Modern, Professional) ==========
  // Dark Mode Dominant
  static const Color neutral0 = Color(0xFF000000); // Pure black (OLED)
  static const Color neutral50 = Color(0xFF0A0A0A); // Near black
  static const Color neutral100 = Color(
    0xFF000000,
  ); // PRIMARY DARK BACKGROUND ⭐ PURE BLACK
  static const Color neutral200 = Color(0xFF1C1C1C); // Elevated surfaces
  static const Color neutral300 = Color(0xFF2E2E2E); // Borders, dividers
  static const Color neutral400 = Color(0xFF525252); // Disabled text
  static const Color neutral500 = Color(0xFF737373); // Secondary text
  static const Color neutral600 = Color(0xFFA3A3A3); // Body text (dark mode)
  static const Color neutral700 = Color(0xFFD4D4D4); // Primary text (dark mode)
  static const Color neutral800 = Color(0xFFE5E5E5); // Emphasized text
  static const Color neutral900 = Color(0xFFF5F5F5); // Highest contrast

  // Light Mode Dominant
  static const Color neutral1000 = Color(0xFFFFFFFF); // Pure white
  static const Color neutral950 = Color(
    0xFFFAFAFA,
  ); // PRIMARY LIGHT BACKGROUND ⭐

  // ========== SEMANTIC COLORS (Vibrant, Clear) ==========
  // Success (Vibrant Green)
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success500 = Color(0xFF22C55E); // Vibrant green ⭐
  static const Color success600 = Color(0xFF16A34A);
  static const Color success700 = Color(0xFF15803D);
  static const Color success900 = Color(0xFF14532D);

  // Error (Vibrant Red)
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error500 = Color(0xFFEF4444); // Vibrant red ⭐
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);
  static const Color error900 = Color(0xFF7F1D1D);

  // Warning (Vibrant Amber)
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning500 = Color(0xFFF59E0B); // Vibrant amber ⭐
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning900 = Color(0xFF78350F);

  // Info (Vibrant Blue)
  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info100 = Color(0xFFDBEAFE);
  static const Color info500 = Color(0xFF3B82F6); // Vibrant blue ⭐
  static const Color info600 = Color(0xFF2563EB);
  static const Color info700 = Color(0xFF1D4ED8);
  static const Color info900 = Color(0xFF1E3A8A);

  // ========== UTILITY COLORS ==========
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ========== ACCENT COLORS FOR LOADER AND HIGHLIGHTS ==========
  static const Color accentPrimary = teal500; // Main accent - vibrant
  static const Color accentSecondary = teal600; // Darker accent
  static const Color accentLight = teal200; // Light accent

  // ========== CONTEXT-BASED COLOR GETTERS ==========
  /// Get primary background color based on brightness
  static Color backgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral100 : neutral950;
  }

  /// Get surface color for cards/elevated elements
  static Color surfaceColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral200 : const Color(0xFFFFFFFF);
  }

  /// Get primary text color
  static Color primaryTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral700 : neutral300;
  }

  /// Get secondary text color
  static Color secondaryTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral500 : neutral500;
  }

  /// Get icon primary color
  static Color iconPrimaryColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral700 : neutral400;
  }

  /// Get icon secondary color
  static Color iconSecondaryColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral500 : neutral500;
  }

  /// Get border color
  static Color borderColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral300 : neutral600;
  }

  /// Get divider color
  static Color dividerColor(Brightness brightness) {
    return brightness == Brightness.dark ? neutral300 : neutral600;
  }
}
