import 'package:flutter/material.dart';

/// Singleton class for application colors
/// Access colors directly: AppColors.primary, AppColors.background, etc.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF00FFFF); // Cyan
  static const Color background = Colors.black;
  static const Color surface = Color(0xFF1A1A1A);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xCCFFFFFF); // white with 80% opacity
  static const Color textMuted = Color(0x66FFFFFF); // white with 40% opacity

  // Status Colors
  static const Color success = Color(0xFF00FF00);
  static const Color error = Colors.red;
  static const Color warning = Colors.yellow;

  // Transparent Colors (Helper methods)
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color textPrimaryWithOpacity(double opacity) => textPrimary.withValues(alpha: opacity);
  static Color textSecondaryWithOpacity(double opacity) => textSecondary.withValues(alpha: opacity);
  static Color surfaceWithOpacity(double opacity) => surface.withValues(alpha: opacity);
  static Color backgroundWithOpacity(double opacity) => background.withValues(alpha: opacity);
  static Color successWithOpacity(double opacity) => success.withValues(alpha: opacity);
  static Color errorWithOpacity(double opacity) => error.withValues(alpha: opacity);
  static Color warningWithOpacity(double opacity) => warning.withValues(alpha: opacity);
}
