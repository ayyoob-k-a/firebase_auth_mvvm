import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// App-wide typography tokens.
///
/// Heading  → DM Serif Display
/// Subtitle → Outfit
class AppTextStyles {
  AppTextStyles._();

  // ── Headings (DM Serif Display) ────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.dmSerifDisplay(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    height: 1.12,
  );

  static TextStyle displayMedium = GoogleFonts.dmSerifDisplay(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    height: 1.16,
  );

  static TextStyle displaySmall = GoogleFonts.dmSerifDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    height: 1.22,
  );

  static TextStyle headlineLarge = GoogleFonts.dmSerifDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static TextStyle headlineMedium = GoogleFonts.dmSerifDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static TextStyle headlineSmall = GoogleFonts.dmSerifDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  // ── Body / Subtitle (Outfit) ───────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static TextStyle titleSmall = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static TextStyle bodyLarge = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static TextStyle bodyMedium = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static TextStyle bodySmall = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  // ── Subtitle variant (grey) ────────────────────────────────────────────────
  static TextStyle subtitle = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitle,
  );

  static TextStyle subtitleLarge = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.subtitle,
  );

  static TextStyle labelLarge = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    letterSpacing: 0.1,
  );
}
