import 'package:flutter/material.dart';

class GOLPrimitives {
  const GOLPrimitives._();

  // Light mode neutrals.
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE8E8E8);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  static const Color neutral1000 = Color(0xFF0A0A0A);

  // Dark mode neutrals.
  static const Color dark0 = Color(0xFF0A0A0A);
  static const Color dark50 = Color(0xFF141414);
  static const Color dark100 = Color(0xFF1A1A1A);
  static const Color dark150 = Color(0xFF212121);
  static const Color dark200 = Color(0xFF262626);
  static const Color dark250 = Color(0xFF2E2E2E);
  static const Color dark300 = Color(0xFF383838);
  static const Color dark400 = Color(0xFF525252);
  static const Color dark500 = Color(0xFF737373);
  static const Color dark600 = Color(0xFFA3A3A3);
  static const Color dark700 = Color(0xFFD4D4D4);
  static const Color dark800 = Color(0xFFE8E8E8);
  static const Color dark900 = Color(0xFFF5F5F5);
  static const Color dark1000 = Color(0xFFFFFFFF);

  // Accent.
  static const Color accent50 = Color(0xFFFFF6E0);
  static const Color accent100 = Color(0xFFFFECB9);
  static const Color accent200 = Color(0xFFFFE08E);
  static const Color accent300 = Color(0xFFFFD35F);
  static const Color accent400 = Color(0xFFFFC12B);
  static const Color accent500 = Color(0xFFFFAB00);
  static const Color accent600 = Color(0xFFE69400);
  static const Color accent700 = Color(0xFFC07F00);
  static const Color accent800 = Color(0xFF9D6500);
  static const Color accent900 = Color(0xFF7B4C00);

  // Semantic.
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success600 = Color(0xFF16A34A);

  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);

  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error600 = Color(0xFFDC2626);

  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info500 = Color(0xFF3B82F6);
  static const Color info600 = Color(0xFF2563EB);
}

@immutable
class GOLSemanticColors extends ThemeExtension<GOLSemanticColors> {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color backgroundElevated;
  final Color backgroundInverse;

  final Color surfaceDefault;
  final Color surfaceRaised;
  final Color surfaceOverlay;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textInverse;
  final Color textAccent;

  final Color borderDefault;
  final Color borderStrong;
  final Color borderFocus;

  final Color interactivePrimary;
  final Color interactivePrimaryHover;
  final Color interactivePrimaryPressed;
  final Color interactivePrimaryDisabled;

  final Color interactiveSecondary;
  final Color interactiveSecondaryHover;

  final Color accentSubtle;
  final Color accentSubtleHover;

  final Color stateSuccess;
  final Color stateWarning;
  final Color stateError;
  final Color stateInfo;

  const GOLSemanticColors({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.backgroundElevated,
    required this.backgroundInverse,
    required this.surfaceDefault,
    required this.surfaceRaised,
    required this.surfaceOverlay,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textInverse,
    required this.textAccent,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.interactivePrimary,
    required this.interactivePrimaryHover,
    required this.interactivePrimaryPressed,
    required this.interactivePrimaryDisabled,
    required this.interactiveSecondary,
    required this.interactiveSecondaryHover,
    required this.accentSubtle,
    required this.accentSubtleHover,
    required this.stateSuccess,
    required this.stateWarning,
    required this.stateError,
    required this.stateInfo,
  });

  static const GOLSemanticColors light = GOLSemanticColors(
    backgroundPrimary: GOLPrimitives.neutral0,
    backgroundSecondary: GOLPrimitives.neutral50,
    backgroundTertiary: GOLPrimitives.neutral100,
    backgroundElevated: GOLPrimitives.neutral0,
    backgroundInverse: GOLPrimitives.neutral900,
    surfaceDefault: GOLPrimitives.neutral0,
    surfaceRaised: GOLPrimitives.neutral0,
    surfaceOverlay: Color(0x80171717),
    textPrimary: GOLPrimitives.neutral900,
    textSecondary: GOLPrimitives.neutral600,
    textTertiary: GOLPrimitives.neutral500,
    textDisabled: GOLPrimitives.neutral400,
    textInverse: GOLPrimitives.neutral0,
    textAccent: GOLPrimitives.accent500,
    borderDefault: GOLPrimitives.neutral200,
    borderStrong: GOLPrimitives.neutral300,
    borderFocus: GOLPrimitives.accent500,
    interactivePrimary: GOLPrimitives.accent500,
    interactivePrimaryHover: GOLPrimitives.accent600,
    interactivePrimaryPressed: GOLPrimitives.accent700,
    interactivePrimaryDisabled: GOLPrimitives.neutral300,
    interactiveSecondary: GOLPrimitives.neutral900,
    interactiveSecondaryHover: GOLPrimitives.neutral800,
    accentSubtle: GOLPrimitives.accent50,
    accentSubtleHover: GOLPrimitives.accent100,
    stateSuccess: GOLPrimitives.success500,
    stateWarning: GOLPrimitives.warning500,
    stateError: GOLPrimitives.error500,
    stateInfo: GOLPrimitives.info500,
  );

  static const GOLSemanticColors dark = GOLSemanticColors(
    backgroundPrimary: GOLPrimitives.dark100,
    backgroundSecondary: GOLPrimitives.dark150,
    backgroundTertiary: GOLPrimitives.dark200,
    backgroundElevated: GOLPrimitives.dark250,
    backgroundInverse: GOLPrimitives.neutral0,
    surfaceDefault: GOLPrimitives.dark200,
    surfaceRaised: GOLPrimitives.dark250,
    surfaceOverlay: Color(0xB3171717),
    textPrimary: GOLPrimitives.dark900,
    textSecondary: GOLPrimitives.dark600,
    textTertiary: GOLPrimitives.dark500,
    textDisabled: GOLPrimitives.dark400,
    textInverse: GOLPrimitives.neutral900,
    textAccent: GOLPrimitives.accent400,
    borderDefault: GOLPrimitives.dark300,
    borderStrong: GOLPrimitives.dark400,
    borderFocus: GOLPrimitives.accent400,
    interactivePrimary: GOLPrimitives.accent500,
    interactivePrimaryHover: GOLPrimitives.accent600,
    interactivePrimaryPressed: GOLPrimitives.accent700,
    interactivePrimaryDisabled: GOLPrimitives.dark400,
    interactiveSecondary: GOLPrimitives.dark900,
    interactiveSecondaryHover: GOLPrimitives.dark800,
    accentSubtle: GOLPrimitives.dark200,
    accentSubtleHover: GOLPrimitives.dark250,
    stateSuccess: GOLPrimitives.success500,
    stateWarning: GOLPrimitives.warning500,
    stateError: GOLPrimitives.error500,
    stateInfo: GOLPrimitives.info500,
  );

  @override
  GOLSemanticColors copyWith({
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? backgroundElevated,
    Color? backgroundInverse,
    Color? surfaceDefault,
    Color? surfaceRaised,
    Color? surfaceOverlay,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textInverse,
    Color? textAccent,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? interactivePrimary,
    Color? interactivePrimaryHover,
    Color? interactivePrimaryPressed,
    Color? interactivePrimaryDisabled,
    Color? interactiveSecondary,
    Color? interactiveSecondaryHover,
    Color? accentSubtle,
    Color? accentSubtleHover,
    Color? stateSuccess,
    Color? stateWarning,
    Color? stateError,
    Color? stateInfo,
  }) {
    return GOLSemanticColors(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      backgroundInverse: backgroundInverse ?? this.backgroundInverse,
      surfaceDefault: surfaceDefault ?? this.surfaceDefault,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverse: textInverse ?? this.textInverse,
      textAccent: textAccent ?? this.textAccent,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      interactivePrimary: interactivePrimary ?? this.interactivePrimary,
      interactivePrimaryHover:
          interactivePrimaryHover ?? this.interactivePrimaryHover,
      interactivePrimaryPressed:
          interactivePrimaryPressed ?? this.interactivePrimaryPressed,
      interactivePrimaryDisabled:
          interactivePrimaryDisabled ?? this.interactivePrimaryDisabled,
      interactiveSecondary: interactiveSecondary ?? this.interactiveSecondary,
      interactiveSecondaryHover:
          interactiveSecondaryHover ?? this.interactiveSecondaryHover,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      accentSubtleHover: accentSubtleHover ?? this.accentSubtleHover,
      stateSuccess: stateSuccess ?? this.stateSuccess,
      stateWarning: stateWarning ?? this.stateWarning,
      stateError: stateError ?? this.stateError,
      stateInfo: stateInfo ?? this.stateInfo,
    );
  }

  @override
  GOLSemanticColors lerp(ThemeExtension<GOLSemanticColors>? other, double t) {
    if (other is! GOLSemanticColors) {
      return this;
    }

    return GOLSemanticColors(
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      backgroundTertiary: Color.lerp(
        backgroundTertiary,
        other.backgroundTertiary,
        t,
      )!,
      backgroundElevated: Color.lerp(
        backgroundElevated,
        other.backgroundElevated,
        t,
      )!,
      backgroundInverse: Color.lerp(
        backgroundInverse,
        other.backgroundInverse,
        t,
      )!,
      surfaceDefault: Color.lerp(surfaceDefault, other.surfaceDefault, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      interactivePrimary: Color.lerp(
        interactivePrimary,
        other.interactivePrimary,
        t,
      )!,
      interactivePrimaryHover: Color.lerp(
        interactivePrimaryHover,
        other.interactivePrimaryHover,
        t,
      )!,
      interactivePrimaryPressed: Color.lerp(
        interactivePrimaryPressed,
        other.interactivePrimaryPressed,
        t,
      )!,
      interactivePrimaryDisabled: Color.lerp(
        interactivePrimaryDisabled,
        other.interactivePrimaryDisabled,
        t,
      )!,
      interactiveSecondary: Color.lerp(
        interactiveSecondary,
        other.interactiveSecondary,
        t,
      )!,
      interactiveSecondaryHover: Color.lerp(
        interactiveSecondaryHover,
        other.interactiveSecondaryHover,
        t,
      )!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      accentSubtleHover: Color.lerp(
        accentSubtleHover,
        other.accentSubtleHover,
        t,
      )!,
      stateSuccess: Color.lerp(stateSuccess, other.stateSuccess, t)!,
      stateWarning: Color.lerp(stateWarning, other.stateWarning, t)!,
      stateError: Color.lerp(stateError, other.stateError, t)!,
      stateInfo: Color.lerp(stateInfo, other.stateInfo, t)!,
    );
  }
}
