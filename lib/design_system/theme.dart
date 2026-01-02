import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'spacing.dart';

class DSColors {
  DSColors._();

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color surfaceLight = Color(0xFFF6F6F4);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);

  static const Color neutral100 = Color(0xFFF2F2F2);
  static const Color neutral200 = Color(0xFFE2E2E2);
  static const Color neutral300 = Color(0xFFC8C8C8);
  static const Color neutral500 = Color(0xFF8C8C8C);

  static const Color orange50 = Color(0xFFFFF4E5);
  static const Color orange100 = Color(0xFFFFE6C7);
  static const Color orange200 = Color(0xFFFFD29A);
  static const Color orange300 = Color(0xFFFFBE6E);
  static const Color orange400 = Color(0xFFFFAA42);
  static const Color orange500 = Color(0xFFFF9A1F);
  static const Color orange600 = Color(0xFFE88700);

  static const Color teal50 = Color(0xFFE6FAF7);
  static const Color teal100 = Color(0xFFC9F2EC);
  static const Color teal200 = Color(0xFF9FE3D9);
  static const Color teal300 = Color(0xFF73D4C7);
  static const Color teal400 = Color(0xFF3EC4B3);
  static const Color teal500 = Color(0xFF18B4A7);
  static const Color teal600 = Color(0xFF109184);

  static const Color premiumGreen = Color(0xFF1F7A4C);
  static const Color premiumGreenSoft = Color(0xFFE6F4ED);
  static const Color premiumRed = Color(0xFFB23A2A);
  static const Color premiumRedSoft = Color(0xFFF8E8E6);
  static const Color premiumBlue = Color(0xFF2B7BBB);
  static const Color premiumBlueSoft = Color(0xFFE7F0FA);
  static const Color premiumAmber = Color(0xFFD87A2E);
  static const Color premiumAmberSoft = Color(0xFFFBEFDF);

  static const List<Color> orangePalette = [
    orange50,
    orange100,
    orange200,
    orange300,
    orange400,
    orange500,
    orange600,
  ];

  static const List<Color> tealPalette = [
    teal50,
    teal100,
    teal200,
    teal300,
    teal400,
    teal500,
    teal600,
  ];

  static const List<Color> neutralPalette = [
    white,
    surfaceLight,
    neutral100,
    neutral200,
    neutral300,
    neutral500,
    black,
  ];
}

class DSTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: DSColors.orange500,
        secondary: DSColors.teal500,
        surface: DSColors.surfaceLight,
        background: DSColors.white,
        error: DSColors.premiumRed,
      ),
      scaffoldBackgroundColor: DSColors.white,
      textTheme: _textTheme(DSColors.black),
      iconTheme: const IconThemeData(color: DSColors.black),
      cardTheme: CardThemeData(
        color: DSColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.cardRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DSColors.neutral200,
        thickness: 1,
      ),
      inputDecorationTheme: _inputTheme(
        borderColor: DSColors.neutral200,
        fillColor: DSColors.surfaceLight,
        textColor: DSColors.black,
      ),
      checkboxTheme: _checkboxTheme(
        activeColor: DSColors.teal500,
        checkColor: DSColors.black,
      ),
      radioTheme: _radioTheme(
        activeColor: DSColors.teal500,
        inactiveColor: DSColors.neutral500,
      ),
      switchTheme: _switchTheme(
        activeColor: DSColors.teal500,
        inactiveColor: DSColors.neutral200,
      ),
      tabBarTheme: _tabBarTheme(
        labelColor: DSColors.black,
        indicatorColor: DSColors.teal500,
      ),
      snackBarTheme: _snackBarTheme(
        background: DSColors.black,
        textColor: DSColors.white,
      ),
      dialogTheme: _dialogTheme(DSColors.surfaceLight),
      bottomSheetTheme: _bottomSheetTheme(DSColors.surfaceLight),
      tooltipTheme: _tooltipTheme(
        background: DSColors.black,
        textColor: DSColors.white,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: DSColors.orange500,
        secondary: DSColors.teal500,
        surface: DSColors.surfaceDark,
        background: DSColors.darkBackground,
        error: DSColors.premiumRed,
      ),
      scaffoldBackgroundColor: DSColors.darkBackground,
      textTheme: _textTheme(DSColors.white),
      iconTheme: const IconThemeData(color: DSColors.white),
      cardTheme: CardThemeData(
        color: DSColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.cardRadius),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DSColors.neutral500,
        thickness: 1,
      ),
      inputDecorationTheme: _inputTheme(
        borderColor: DSColors.neutral500,
        fillColor: DSColors.surfaceDark,
        textColor: DSColors.white,
      ),
      checkboxTheme: _checkboxTheme(
        activeColor: DSColors.teal500,
        checkColor: DSColors.black,
      ),
      radioTheme: _radioTheme(
        activeColor: DSColors.teal500,
        inactiveColor: DSColors.neutral300,
      ),
      switchTheme: _switchTheme(
        activeColor: DSColors.teal500,
        inactiveColor: DSColors.neutral500,
      ),
      tabBarTheme: _tabBarTheme(
        labelColor: DSColors.white,
        indicatorColor: DSColors.teal500,
      ),
      snackBarTheme: _snackBarTheme(
        background: DSColors.white,
        textColor: DSColors.black,
      ),
      dialogTheme: _dialogTheme(DSColors.surfaceDark),
      bottomSheetTheme: _bottomSheetTheme(DSColors.surfaceDark),
      tooltipTheme: _tooltipTheme(
        background: DSColors.white,
        textColor: DSColors.black,
      ),
    );
  }

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      // Use Roboto for display headings - all 24px (3 × 8)
      displayLarge: GoogleFonts.roboto(
        fontSize: 24, // 3 × 8
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 24, // 3 × 8
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24, // 3 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      // Use Roboto for headlines - simple sizing
      headlineLarge: GoogleFonts.roboto(
        fontSize: 24, // 3 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 16, // 2 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 16, // 2 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      // Use Inter for body text - all 16px (2 × 8)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      // Use Inter for labels - all 16px (2 × 8)
      labelLarge: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 16, // 2 × 8
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color borderColor,
    required Color fillColor,
    required Color textColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.horizontalPadding,
        vertical: DSSpacing.verticalPadding,
      ),
      hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        borderSide: const BorderSide(color: DSColors.teal500, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        borderSide: const BorderSide(color: DSColors.premiumRed, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
        borderSide: const BorderSide(color: DSColors.premiumRed, width: 1.5),
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme({
    required Color activeColor,
    required Color checkColor,
  }) {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return activeColor;
        return null;
      }),
      checkColor: MaterialStateProperty.all(checkColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: const BorderSide(color: DSColors.neutral300),
    );
  }

  static RadioThemeData _radioTheme({
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return activeColor;
        return inactiveColor;
      }),
    );
  }

  static SwitchThemeData _switchTheme({
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return activeColor.withOpacity(0.4);
        }
        return inactiveColor;
      }),
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return activeColor;
        return DSColors.neutral300;
      }),
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  static TabBarThemeData _tabBarTheme({
    required Color labelColor,
    required Color indicatorColor,
  }) {
    return TabBarThemeData(
      labelColor: labelColor,
      unselectedLabelColor: labelColor.withOpacity(0.5),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: indicatorColor, width: 2),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme({
    required Color background,
    required Color textColor,
  }) {
    return SnackBarThemeData(
      backgroundColor: background,
      contentTextStyle: TextStyle(color: textColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    );
  }

  static DialogThemeData _dialogTheme(Color background) {
    return DialogThemeData(
      backgroundColor: background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(Color background) {
    return BottomSheetThemeData(
      backgroundColor: background,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DSSpacing.componentRadius),
        ),
      ),
    );
  }

  static TooltipThemeData _tooltipTheme({
    required Color background,
    required Color textColor,
  }) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DSSpacing.componentRadius),
      ),
      textStyle: TextStyle(color: textColor),
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.horizontalPadding,
        vertical: DSSpacing.verticalPadding,
      ),
    );
  }
}
