import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboardingapp/core/themes/app_colors.dart';

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading2 => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading3 => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get button => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get caption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}