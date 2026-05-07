import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C5A);
  static const Color primaryDark = Color(0xFFE54E1B);

  // Secondary palette
  static const Color secondary = Color(0xFF00D4AA);
  static const Color secondaryLight = Color(0xFF33DDBB);
  static const Color secondaryDark = Color(0xFF00A882);

  // Dark theme backgrounds
  static const Color bgDark = Color(0xFF0D0D0D);
  static const Color bgCard = Color(0xFF1A1A1A);
  static const Color bgCardLight = Color(0xFF242424);
  static const Color bgSurface = Color(0xFF2E2E2E);

  // Light theme backgrounds
  static const Color bgLight = Color(0xFFF5F5F5);
  static const Color bgCardWhite = Color(0xFFFFFFFF);
  static const Color bgSurfaceLight = Color(0xFFEEEEEE);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF666666);
  static const Color textDark = Color(0xFF1A1A1A);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Chart colors
  static const Color chart1 = Color(0xFFFF6B35);
  static const Color chart2 = Color(0xFF00D4AA);
  static const Color chart3 = Color(0xFF9C27B0);
  static const Color chart4 = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [bgDark, bgCard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [bgCard, bgCardLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
