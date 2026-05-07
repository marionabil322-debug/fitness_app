import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/screen_01.dart';
import 'screens/screen_02.dart';
import 'screens/screen_03.dart';
import 'screens/screen_04.dart';
import 'screens/screen_05.dart';
import 'screens/screen_06.dart';
import 'screens/screen_07.dart';
import 'screens/screen_08.dart';
import 'screens/screen_09.dart';
import 'screens/screen_10.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/categories': (context) => const WorkoutCategoriesScreen(),
        '/exercises': (context) => const ExerciseListScreen(),
        '/exercise-detail': (context) => const ExerciseDetailScreen(),
        '/active-workout': (context) => const ActiveWorkoutScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/goals': (context) => const GoalSettingScreen(),
        '/history': (context) => const WorkoutHistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
