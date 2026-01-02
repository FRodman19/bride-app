import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GOLTypography {
  const GOLTypography._();

  static TextTheme baseTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.01,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TextStyle caption(Color color) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle overline(Color color) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 11,
      height: 16 / 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.06,
      color: color,
    );
  }

  static TextStyle micro(Color color) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 10,
      height: 12 / 10,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle mono({
    required double size,
    required FontWeight weight,
    required Color color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      height: (size + 4) / size,
      fontWeight: weight,
      color: color,
    );
  }
}
