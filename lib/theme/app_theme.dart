import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// App theme configuration for Grow Out Loud
///
/// DESIGN SPECIFICATIONS:
/// - Border Radius: 16px on EVERYTHING (buttons, cards, inputs, chips, modals)
/// - Padding: 16px horizontal, 8px vertical
/// - NO shadows anywhere
/// - NO outlines (except secondary buttons)
/// - Fonts: Sora (headings), Open Sans (body/UI/buttons)
///
/// BUTTON SPECIFICATIONS:
/// - Primary: Teal background + Black text + Open Sans
/// - Secondary: Black outline + Black text + Open Sans (light mode)
/// - Tertiary: Grey background + Black text + Open Sans + NO outline
/// - Pressed state: teal700 (slightly darker)
class AppTheme {
  // ========== LIGHT THEME ==========
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Colors
      scaffoldBackgroundColor: AppColors.neutral950,
      colorScheme: ColorScheme.light(
        primary: AppColors.teal500,
        onPrimary: AppColors.black, // Black text on teal
        secondary: AppColors.teal400,
        onSecondary: AppColors.black,
        surface: AppColors.white,
        onSurface: AppColors.neutral300,
        error: AppColors.error500,
        onError: AppColors.white,
        outline: AppColors.black, // Black outline for secondary buttons
      ),

      // Typography - Sora for headings, Open Sans for body/UI
      textTheme: TextTheme(
        // Headings - Sora
        displayLarge: GoogleFonts.sora(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral300,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral300,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral300,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
        // Body & UI - Open Sans
        titleLarge: GoogleFonts.openSans(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral300,
        ),
        titleMedium: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral300,
        ),
        titleSmall: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral300,
        ),
        bodyLarge: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral300,
        ),
        bodyMedium: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral300,
        ),
        bodySmall: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral500,
        ),
        labelLarge: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
        labelMedium: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
        labelSmall: GoogleFonts.openSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
      ),

      // App Bar - No shadow
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutral950,
        foregroundColor: AppColors.neutral300,
        elevation: 0, // NO shadow
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral300,
        ),
      ),

      // PRIMARY BUTTON - Teal background + Black text + Open Sans
      // 16px radius, no shadow, 16px horizontal padding, 8px vertical padding
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.teal700; // Darker when pressed (teal700)
            }
            return AppColors.teal500; // Default teal
          }),
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.black,
          ), // Black text
          elevation: const WidgetStatePropertyAll(0), // NO shadow
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 16px H, 8px V
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              // Open Sans font
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ),

      // SECONDARY BUTTON - Black outline + Black text + Open Sans
      // 16px radius, no shadow, 16px horizontal padding, 8px vertical padding
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.black,
          ), // Black text
          elevation: const WidgetStatePropertyAll(0), // NO shadow
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 16px H, 8px V
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.black, width: 1), // Black outline
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              // Open Sans font
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ),

      // TERTIARY BUTTON - Grey background + Black text + Open Sans + NO outline
      // 16px radius, no shadow, 16px horizontal padding, 8px vertical padding
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.neutral300,
          ), // Grey background
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.black,
          ), // Black text
          elevation: const WidgetStatePropertyAll(0), // NO shadow
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 16px H, 8px V
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              // Open Sans font
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ),

      // FAB - 16px radius, no shadow
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.teal500,
        foregroundColor: AppColors.black,
        elevation: 0, // NO shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
      ),

      // CARDS - 16px radius, no shadow
      cardTheme: CardThemeData(
        color: AppColors.neutral900,
        elevation: 0, // NO shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
        margin: const EdgeInsets.all(16),
      ),

      // INPUT FIELDS - 16px radius, no shadow
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral900,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.neutral600, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.neutral600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.teal500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.error500, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.error500, width: 2),
        ),
      ),

      // CHIPS - 16px radius, no shadow, no outline
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
        side: BorderSide.none, // NO outline
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        elevation: 0, // NO shadow
      ),

      // Bottom Navigation - No shadow
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFD300),
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.black,
        elevation: 0, // NO shadow
        type: BottomNavigationBarType.fixed,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral600,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(color: AppColors.neutral400, size: 24),
    );
  }

  // ========== DARK THEME ==========
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Colors
      scaffoldBackgroundColor: AppColors.neutral100, // Pure black
      colorScheme: ColorScheme.dark(
        primary: AppColors.teal500,
        onPrimary: AppColors.black, // Black text on teal
        secondary: AppColors.teal400,
        onSecondary: AppColors.black,
        surface: AppColors.neutral200,
        onSurface: AppColors.neutral700,
        error: AppColors.error500,
        onError: AppColors.white,
        outline:
            AppColors.white, // White outline for secondary buttons in dark mode
      ),

      // Typography - Sora for headings, Open Sans for body/UI
      textTheme: TextTheme(
        // Headings - Sora
        displayLarge: GoogleFonts.sora(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral700,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral700,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral700,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
        // Body & UI - Open Sans
        titleLarge: GoogleFonts.openSans(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral700,
        ),
        titleMedium: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral700,
        ),
        titleSmall: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral700,
        ),
        bodyLarge: GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral700,
        ),
        bodyMedium: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral700,
        ),
        bodySmall: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.neutral500,
        ),
        labelLarge: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
        labelMedium: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
        labelSmall: GoogleFonts.openSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
      ),

      // App Bar - No shadow
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutral100,
        foregroundColor: AppColors.neutral700,
        elevation: 0, // NO shadow
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.neutral700,
        ),
      ),

      // PRIMARY BUTTON - Teal background + Black text + Open Sans (same in dark mode)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.teal700; // Darker when pressed (teal700)
            }
            return AppColors.teal500; // Default teal
          }),
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.black,
          ), // Black text
          elevation: const WidgetStatePropertyAll(0), // NO shadow
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              // Open Sans font
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ),

      // SECONDARY BUTTON - Black outline + Black text in DARK MODE (but user said black text with black outline for white mode)
      // In dark mode: should be white outline? Let me re-read... "secondary buttons :  black text, with black outline (white mode)"
      // This means in white mode (light mode): black text + black outline
      // What about dark mode? Not specified, but logically it should be white text + white outline
      // Actually, re-reading: "tetiary button : black text , grey background, no outline , (dark mode: black text , grey background, no outline)"
      // Only tertiary specifies dark mode behavior with "black text" - so tertiary uses black text in both modes
      // Secondary doesn't specify dark mode, so I'll assume white text + white outline in dark mode
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.white,
          ), // White text in dark mode
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.white,
              width: 1,
            ), // White outline in dark mode
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),

      // TERTIARY BUTTON - Grey background + Black text + NO outline (dark mode: black text, grey background, no outline)
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.neutral200,
          ), // Grey background in dark mode
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.black,
          ), // Black text (specified for dark mode)
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 16px radius
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ),

      // FAB - 16px radius, no shadow
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.teal500,
        foregroundColor: AppColors.black,
        elevation: 0, // NO shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
      ),

      // CARDS - 16px radius, no shadow
      cardTheme: CardThemeData(
        color: AppColors.neutral200,
        elevation: 0, // NO shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
        margin: const EdgeInsets.all(16),
      ),

      // INPUT FIELDS - 16px radius, no shadow
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.teal500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.error500, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
          borderSide: const BorderSide(color: AppColors.error500, width: 2),
        ),
      ),

      // CHIPS - 16px radius, no shadow, no outline
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 16px radius
        ),
        side: BorderSide.none, // NO outline
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        elevation: 0, // NO shadow
      ),

      // Bottom Navigation - No shadow
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.neutral100.withValues(alpha: 0.95),
        selectedItemColor: AppColors.teal500,
        unselectedItemColor: AppColors.neutral500,
        elevation: 0, // NO shadow
        type: BottomNavigationBarType.fixed,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral300,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(color: AppColors.neutral700, size: 24),
    );
  }
}
