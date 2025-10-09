import 'package:flutter/material.dart';

/// Text styles using Orbitron font family
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Display Styles (Large titles - Orbitron Black/ExtraBold)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 32,
    fontWeight: FontWeight.w900, // Black
    color: Colors.white,
    letterSpacing: 1.5,
    shadows: [
      Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black45),
    ],
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 28,
    fontWeight: FontWeight.w800, // ExtraBold
    color: Colors.white,
    letterSpacing: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: Colors.white,
    letterSpacing: 1.0,
  );

  // Headline Styles (Section headers - Orbitron SemiBold/Bold)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 22,
    fontWeight: FontWeight.w600, // SemiBold
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white,
  );

  // Title Styles (Component titles - Orbitron Medium/SemiBold)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Body Styles (Readable content - Default font for better readability)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.4,
  );

  // Label Styles (UI elements - Orbitron for consistency)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // Button Style
  static const TextStyle button = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 1.0,
  );
}
