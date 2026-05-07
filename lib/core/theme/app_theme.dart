import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,

      // 1. الألوان الأساسية - دي أهم حتة
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.bgCard,
      ),

      // 2. الثيم الموحد للزراير (عشان ما تكررش الكود في كل صفحة)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52), // طول موحد
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      // 3. شكل الكروت الموحد
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 4. الخطوط - هنعرف الأحجام الرئيسية بس
      textTheme: const TextTheme(
        displayMedium: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),

      // 5. شكل الـ Inputs (لو عندك فورم أو بحث)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCard,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  // نسخة الـ Light المختصرة جداً
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(primary: AppColors.primary),
      );
}
