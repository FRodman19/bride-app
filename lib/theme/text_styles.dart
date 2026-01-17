import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typography system for Grow Out Loud
/// Headings: Sora (bold, modern, impactful)
/// Body/UI: Open Sans (clean, readable, professional)
class TextStyles {
  // ========== DISPLAY TEXT (Sora - Bold & Modern) ==========

  /// Display Large - Hero text, main headlines
  /// Sora, 57sp, Bold
  static TextStyle displayLarge(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -0.25,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Display Medium - Section headers
  /// Sora, 45sp, Bold
  static TextStyle displayMedium(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      height: 1.16,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Display Small - Card headers, modal titles
  /// Sora, 36sp, Bold
  static TextStyle displaySmall(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.22,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  // ========== HEADINGS (Sora - Semibold) ==========

  /// Heading Large - Page titles
  /// Sora, 32sp, SemiBold
  static TextStyle headlineLarge(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Heading Medium - Section titles
  /// Sora, 28sp, SemiBold
  static TextStyle headlineMedium(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Heading Small - Subsection titles
  /// Sora, 24sp, SemiBold
  static TextStyle headlineSmall(Brightness brightness) {
    return GoogleFonts.sora(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.33,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  // ========== TITLES (Open Sans - UI Text) ==========

  /// Title Large - List item headers
  /// Open Sans, 22sp, Medium
  static TextStyle titleLarge(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      height: 1.27,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Title Medium - Card titles
  /// Open Sans, 16sp, Medium
  static TextStyle titleMedium(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Title Small - Compact headers
  /// Open Sans, 14sp, Medium
  static TextStyle titleSmall(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  // ========== LABELS (Open Sans - Buttons, Tabs, UI Controls) ==========

  /// Label Large - Primary buttons
  /// Open Sans, 14sp, SemiBold
  static TextStyle labelLarge(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Label Medium - Secondary buttons, tabs
  /// Open Sans, 12sp, SemiBold
  static TextStyle labelMedium(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0.5,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Label Small - Chips, badges, small UI
  /// Open Sans, 11sp, SemiBold
  static TextStyle labelSmall(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.45,
      letterSpacing: 0.5,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  // ========== BODY TEXT (Open Sans - Paragraphs, Descriptions) ==========

  /// Body Large - Main content
  /// Open Sans, 16sp, Regular
  static TextStyle bodyLarge(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.5,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Body Medium - Standard text
  /// Open Sans, 14sp, Regular
  static TextStyle bodyMedium(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
      color: AppColors.primaryTextColor(brightness),
    );
  }

  /// Body Small - Captions, helper text
  /// Open Sans, 12sp, Regular
  static TextStyle bodySmall(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
      color: AppColors.secondaryTextColor(brightness),
    );
  }

  // ========== SPECIALIZED TEXT STYLES ==========

  /// Link text - Teal colored, underlined
  /// Open Sans, 14sp, Medium
  static TextStyle linkText(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.43,
      letterSpacing: 0.25,
      color: AppColors.teal500,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.teal500,
    );
  }

  /// Code text - Monospace for technical content
  /// Monospace, 13sp, Medium
  static TextStyle codeText(Brightness brightness) {
    return TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: brightness == Brightness.dark
          ? const Color(0xFFE0E0E0)
          : const Color(0xFF2E2E2E),
    );
  }

  /// Overline - Small caps, labels
  /// Open Sans, 10sp, SemiBold, Uppercase
  static TextStyle overline(Brightness brightness) {
    return GoogleFonts.openSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 1.6,
      letterSpacing: 1.5,
      color: AppColors.secondaryTextColor(brightness),
    ).copyWith(fontFeatures: [const FontFeature.enable('smcp')]);
  }

  // ========== BUTTON TEXT STYLES ==========

  /// Button text - Black on teal background
  /// Open Sans, 14sp, SemiBold
  static TextStyle buttonText() {
    return GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.43,
      letterSpacing: 0.1,
      color: AppColors.black, // Black text on teal
    );
  }

  /// Small button text
  /// Open Sans, 12sp, SemiBold
  static TextStyle buttonTextSmall() {
    return GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: 0.1,
      color: AppColors.black,
    );
  }

  /// Large button text
  /// Open Sans, 16sp, SemiBold
  static TextStyle buttonTextLarge() {
    return GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.1,
      color: AppColors.black,
    );
  }
}
