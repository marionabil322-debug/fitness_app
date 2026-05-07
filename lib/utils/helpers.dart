import 'package:flutter/material.dart';

class Helpers {
  // ─── Date & Time Formatting ─────────────────────────────────────────────────

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  static String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String weekdayShort(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  // ─── Number Formatting ──────────────────────────────────────────────────────

  static String formatCalories(int calories) {
    if (calories >= 1000) {
      return '${(calories / 1000).toStringAsFixed(1)}k';
    }
    return '$calories';
  }

  static String formatWeight(double weight) {
    return '${weight.toStringAsFixed(1)} kg';
  }

  static String formatHeight(double height) {
    return '${height.toStringAsFixed(0)} cm';
  }

  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).toInt()} m';
    return '${km.toStringAsFixed(2)} km';
  }

  static String formatBMI(double weight, double height) {
    final bmi = weight / ((height / 100) * (height / 100));
    return bmi.toStringAsFixed(1);
  }

  static String bmiCategory(double weight, double height) {
    final bmi = weight / ((height / 100) * (height / 100));
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  static String formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return '$steps';
  }

  static String formatPercentage(double value) {
    return '${(value * 100).toInt()}%';
  }

  // ─── Color Helpers ──────────────────────────────────────────────────────────

  static Color difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  static Color progressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }

  // ─── Validation ─────────────────────────────────────────────────────────────

  static bool isValidWeight(String value) {
    final parsed = double.tryParse(value);
    return parsed != null && parsed > 20 && parsed < 400;
  }

  static bool isValidHeight(String value) {
    final parsed = double.tryParse(value);
    return parsed != null && parsed > 50 && parsed < 300;
  }

  static bool isValidAge(String value) {
    final parsed = int.tryParse(value);
    return parsed != null && parsed > 0 && parsed < 120;
  }

  // ─── Motivational Messages ──────────────────────────────────────────────────

  static String getMotivationalMessage(int hour) {
    if (hour < 12) return 'Good morning! Ready to crush it? 💪';
    if (hour < 17) return 'Afternoon energy! Keep pushing! 🔥';
    return 'Evening warrior! Finish strong! ⚡';
  }

  static String getProgressMessage(double progress) {
    if (progress >= 1.0) return 'Goal achieved! Amazing work! 🏆';
    if (progress >= 0.75) return 'Almost there! Keep going! 🔥';
    if (progress >= 0.5) return 'Halfway there! Great progress! 💪';
    if (progress >= 0.25) return 'Good start! Stay consistent! 👊';
    return 'Just getting started! You\'ve got this! 🚀';
  }

  static String categoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'strength':
        return '💪';
      case 'cardio':
        return '🏃';
      case 'yoga':
        return '🧘';
      case 'hiit':
        return '⚡';
      case 'flexibility':
        return '🤸';
      case 'sports':
        return '⚽';
      default:
        return '🏋️';
    }
  }
}
