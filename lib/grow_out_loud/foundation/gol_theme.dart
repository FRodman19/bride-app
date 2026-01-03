import 'package:flutter/material.dart';

import 'gol_colors.dart';
import 'gol_radius.dart';
import 'gol_spacing.dart';
import 'gol_typography.dart';

class GOLThemeData {
  const GOLThemeData._();

  static ThemeData light() {
    return _baseTheme(GOLSemanticColors.light, Brightness.light);
  }

  static ThemeData dark() {
    return _baseTheme(GOLSemanticColors.dark, Brightness.dark);
  }

  static ThemeData _baseTheme(
    GOLSemanticColors colors,
    Brightness brightness,
  ) {
    final textTheme = GOLTypography.baseTextTheme().apply(
      displayColor: colors.textPrimary,
      bodyColor: colors.textPrimary,
    );

    final colorScheme = brightness == Brightness.light
        ? ColorScheme.light(
            primary: GOLPrimitives.accent500,
            onPrimary: colors.textInverse,
            secondary: colors.textPrimary,
            onSecondary: colors.backgroundPrimary,
            error: colors.stateError,
            onError: colors.textInverse,
            surface: colors.surfaceDefault,
            onSurface: colors.textPrimary,
            surfaceTint: Colors.transparent, // No tint on surfaces
            background: colors.backgroundPrimary,
            onBackground: colors.textPrimary,
            outline: colors.borderDefault,
          )
        : ColorScheme.dark(
            primary: GOLPrimitives.accent500,
            onPrimary: colors.textInverse,
            secondary: colors.textPrimary,
            onSecondary: colors.backgroundPrimary,
            error: colors.stateError,
            onError: colors.textInverse,
            surface: colors.surfaceDefault,
            onSurface: colors.textPrimary,
            surfaceTint: Colors.transparent, // No tint on surfaces
            background: colors.backgroundPrimary,
            onBackground: colors.textPrimary,
            outline: colors.borderDefault,
          );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: colors.backgroundPrimary,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0, // No elevation when scrolled
        backgroundColor: colors.backgroundPrimary,
        surfaceTintColor: Colors.transparent, // Remove orange/yellow tint
        foregroundColor: colors.textPrimary,
        titleTextStyle: textTheme.headlineSmall,
      ),
      dividerColor: colors.borderDefault,
      dividerTheme: DividerThemeData(
        color: colors.borderDefault,
        thickness: 0.5, // Thin divider
        space: 0, // No extra space
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false, // No fill color - outline only
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GOLSpacing.inputPaddingHorizontal,
          vertical: GOLSpacing.inputPaddingVertical,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textTertiary),
        labelStyle: textTheme.labelSmall?.copyWith(color: colors.textSecondary),
        enabledBorder: _outline(colors.borderDefault, 1.5),
        focusedBorder: _outline(colors.borderFocus, 2),
        errorBorder: _outline(colors.stateError, 2),
        focusedErrorBorder: _outline(colors.stateError, 2),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.xs),
        ),
        side: BorderSide(color: colors.borderStrong, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.interactivePrimary
              : colors.borderStrong,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(GOLPrimitives.neutral0),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.interactivePrimary
              : colors.interactivePrimaryDisabled,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.backgroundInverse,
        contentTextStyle:
            textTheme.bodySmall?.copyWith(color: colors.textInverse),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.sm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.modal),
        ),
        titleTextStyle: textTheme.headlineMedium,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(GOLRadius.modal),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent, // Remove the line below tabs
        labelColor: colors.interactivePrimary,
        unselectedLabelColor: colors.textSecondary,
        indicatorColor: colors.interactivePrimary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelLarge,
      ),
      extensions: [colors],
    );
  }

  static OutlineInputBorder _outline(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(GOLRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
