import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class WorkoutCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int workoutCount;

  const WorkoutCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.workoutCount,
  });
}

class Exercise {
  final String id;
  final String name;
  final String categoryId;
  final String muscleGroup;
  final String sets;
  final String reps;
  final String duration;
  final String difficulty;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> instructions;
  final int calories;

  const Exercise({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.icon,
    required this.color,
    required this.instructions,
    required this.calories,
  });
}

class WorkoutHistory {
  final String id;
  final String name;
  final DateTime date;
  final int durationMinutes;
  final int caloriesBurned;
  final int exercisesCount;
  final String category;

  const WorkoutHistory({
    required this.id,
    required this.name,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.exercisesCount,
    required this.category,
  });
}

class WeeklyStats {
  final String day;
  final double minutes;
  final int calories;

  const WeeklyStats({
    required this.day,
    required this.minutes,
    required this.calories,
  });
}

class UserProfile {
  final String name;
  final String email;
  final int age;
  final double height; // cm
  final double weight; // kg
  final String fitnessLevel;
  final String goal;
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;

  const UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.fitnessLevel,
    required this.goal,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
  });
}

// ─── App Data ─────────────────────────────────────────────────────────────────

class AppData {
  // Workout categories
  static const List<WorkoutCategory> categories = [
    WorkoutCategory(
      id: 'strength',
      name: 'Strength',
      description: 'Build muscle & power',
      icon: Icons.fitness_center,
      color: AppColors.primary,
      workoutCount: 24,
    ),
    WorkoutCategory(
      id: 'cardio',
      name: 'Cardio',
      description: 'Boost endurance',
      icon: Icons.directions_run,
      color: AppColors.secondary,
      workoutCount: 18,
    ),
    WorkoutCategory(
      id: 'yoga',
      name: 'Yoga',
      description: 'Flexibility & mindfulness',
      icon: Icons.self_improvement,
      color: Color(0xFF9C27B0),
      workoutCount: 15,
    ),
    WorkoutCategory(
      id: 'hiit',
      name: 'HIIT',
      description: 'High intensity intervals',
      icon: Icons.bolt,
      color: Color(0xFFFFC107),
      workoutCount: 12,
    ),
    WorkoutCategory(
      id: 'flexibility',
      name: 'Flexibility',
      description: 'Stretch & recover',
      icon: Icons.accessibility_new,
      color: Color(0xFF2196F3),
      workoutCount: 10,
    ),
    WorkoutCategory(
      id: 'sports',
      name: 'Sports',
      description: 'Sport-specific training',
      icon: Icons.sports_soccer,
      color: Color(0xFF4CAF50),
      workoutCount: 8,
    ),
  ];

  // Exercises
  static const List<Exercise> exercises = [
    Exercise(
      id: 'e1',
      name: 'Barbell Squat',
      categoryId: 'strength',
      muscleGroup: 'Legs • Glutes',
      sets: '4 sets',
      reps: '8–12 reps',
      duration: '45 min',
      difficulty: 'Hard',
      description:
          'The barbell squat is a compound lower-body exercise that targets the quadriceps, hamstrings, and glutes. It is considered one of the foundational movements for building lower-body strength.',
      icon: Icons.fitness_center,
      color: AppColors.primary,
      calories: 320,
      instructions: [
        'Stand with feet shoulder-width apart, barbell resting on upper traps.',
        'Brace your core and push your hips back as you lower down.',
        'Descend until thighs are parallel to the floor or lower.',
        'Drive through your heels to return to the starting position.',
        'Keep your chest up and knees tracking over your toes throughout.',
      ],
    ),
    Exercise(
      id: 'e2',
      name: 'Bench Press',
      categoryId: 'strength',
      muscleGroup: 'Chest • Triceps',
      sets: '4 sets',
      reps: '6–10 reps',
      duration: '40 min',
      difficulty: 'Medium',
      description:
          'The bench press is a classic upper-body pushing exercise that primarily targets the pectorals, anterior deltoids, and triceps. It is a staple for building chest strength and size.',
      icon: Icons.sports_gymnastics,
      color: AppColors.primary,
      calories: 280,
      instructions: [
        'Lie flat on the bench with eyes under the bar.',
        'Grip the bar slightly wider than shoulder-width.',
        'Unrack and lower the bar to mid-chest with control.',
        'Press the bar up and slightly back to lockout.',
        'Maintain shoulder blades retracted throughout the movement.',
      ],
    ),
    Exercise(
      id: 'e3',
      name: 'Treadmill Run',
      categoryId: 'cardio',
      muscleGroup: 'Full Body',
      sets: '1 session',
      reps: '30 min',
      duration: '30 min',
      difficulty: 'Easy',
      description:
          'Running on the treadmill improves cardiovascular health, burns calories, and increases aerobic capacity. Adjust speed and incline to vary intensity.',
      icon: Icons.directions_run,
      color: AppColors.secondary,
      calories: 350,
      instructions: [
        'Start with a 5-minute warm-up walk at 3–4 mph.',
        'Increase speed to a comfortable jogging pace.',
        'Maintain upright posture with relaxed shoulders.',
        'Engage your core and land mid-foot with each stride.',
        'Cool down with a 5-minute walk at the end.',
      ],
    ),
    Exercise(
      id: 'e4',
      name: 'Warrior Pose',
      categoryId: 'yoga',
      muscleGroup: 'Hips • Core',
      sets: '3 sets',
      reps: '60 sec hold',
      duration: '20 min',
      difficulty: 'Easy',
      description:
          'Warrior I is a foundational yoga pose that strengthens the legs, opens the hips, and improves balance. It is excellent for building lower body stability.',
      icon: Icons.self_improvement,
      color: Color(0xFF9C27B0),
      calories: 90,
      instructions: [
        'Start in mountain pose and step one foot back 3–4 feet.',
        'Bend the front knee to 90 degrees, keeping it over the ankle.',
        'Raise both arms overhead with palms facing each other.',
        'Square your hips toward the front of the mat.',
        'Hold for 30–60 seconds, then switch sides.',
      ],
    ),
    Exercise(
      id: 'e5',
      name: 'Burpees',
      categoryId: 'hiit',
      muscleGroup: 'Full Body',
      sets: '5 rounds',
      reps: '10 reps',
      duration: '25 min',
      difficulty: 'Hard',
      description:
          'Burpees are a full-body exercise combining a squat, push-up, and jump. They are highly effective for cardiovascular conditioning and calorie burning.',
      icon: Icons.bolt,
      color: Color(0xFFFFC107),
      calories: 400,
      instructions: [
        'Start standing, then squat down and place hands on the floor.',
        'Jump or step feet back into a high plank position.',
        'Perform a push-up, keeping your body straight.',
        'Jump or step feet forward toward your hands.',
        'Explosively jump up with arms overhead to complete one rep.',
      ],
    ),
    Exercise(
      id: 'e6',
      name: 'Deadlift',
      categoryId: 'strength',
      muscleGroup: 'Back • Hamstrings',
      sets: '3 sets',
      reps: '5–8 reps',
      duration: '35 min',
      difficulty: 'Hard',
      description:
          'The deadlift is a fundamental compound movement that targets the entire posterior chain. It is one of the best exercises for overall strength development.',
      icon: Icons.fitness_center,
      color: AppColors.primary,
      calories: 360,
      instructions: [
        'Stand with feet hip-width apart, bar over mid-foot.',
        'Hinge at the hips and grip the bar just outside your legs.',
        'Take a deep breath and brace your core before lifting.',
        'Drive through the floor, keeping the bar close to your body.',
        'Lock out hips and knees at the top, then lower with control.',
      ],
    ),
  ];

  // Weekly stats
  static const List<WeeklyStats> weeklyStats = [
    WeeklyStats(day: 'Mon', minutes: 45, calories: 380),
    WeeklyStats(day: 'Tue', minutes: 30, calories: 260),
    WeeklyStats(day: 'Wed', minutes: 60, calories: 510),
    WeeklyStats(day: 'Thu', minutes: 0, calories: 0),
    WeeklyStats(day: 'Fri', minutes: 50, calories: 430),
    WeeklyStats(day: 'Sat', minutes: 75, calories: 620),
    WeeklyStats(day: 'Sun', minutes: 40, calories: 340),
  ];

  // Workout history
  static final List<WorkoutHistory> workoutHistory = [
    WorkoutHistory(
      id: 'h1',
      name: 'Full Body Strength',
      date: DateTime.now().subtract(const Duration(days: 1)),
      durationMinutes: 55,
      caloriesBurned: 420,
      exercisesCount: 6,
      category: 'Strength',
    ),
    WorkoutHistory(
      id: 'h2',
      name: 'Morning Cardio Blast',
      date: DateTime.now().subtract(const Duration(days: 2)),
      durationMinutes: 35,
      caloriesBurned: 310,
      exercisesCount: 4,
      category: 'Cardio',
    ),
    WorkoutHistory(
      id: 'h3',
      name: 'HIIT Circuit',
      date: DateTime.now().subtract(const Duration(days: 4)),
      durationMinutes: 28,
      caloriesBurned: 380,
      exercisesCount: 8,
      category: 'HIIT',
    ),
    WorkoutHistory(
      id: 'h4',
      name: 'Upper Body Push',
      date: DateTime.now().subtract(const Duration(days: 5)),
      durationMinutes: 48,
      caloriesBurned: 350,
      exercisesCount: 5,
      category: 'Strength',
    ),
    WorkoutHistory(
      id: 'h5',
      name: 'Yoga Flow',
      date: DateTime.now().subtract(const Duration(days: 7)),
      durationMinutes: 40,
      caloriesBurned: 180,
      exercisesCount: 10,
      category: 'Yoga',
    ),
    WorkoutHistory(
      id: 'h6',
      name: 'Leg Day Destroyer',
      date: DateTime.now().subtract(const Duration(days: 9)),
      durationMinutes: 62,
      caloriesBurned: 490,
      exercisesCount: 7,
      category: 'Strength',
    ),
  ];

  // User profile
  static const UserProfile userProfile = UserProfile(
    name: 'Alex Johnson',
    email: 'alex.johnson@fitpulse.app',
    age: 28,
    height: 178.0,
    weight: 76.5,
    fitnessLevel: 'Intermediate',
    goal: 'Build Muscle',
    totalWorkouts: 142,
    totalMinutes: 6840,
    totalCalories: 58200,
  );

  // Goals data
  static const Map<String, dynamic> goalsData = {
    'dailySteps': 10000,
    'currentSteps': 7432,
    'weeklyWorkouts': 5,
    'completedWorkouts': 3,
    'weightGoal': 72.0,
    'currentWeight': 76.5,
    'calorieGoal': 2500,
    'currentCalories': 1820,
    'waterGoal': 8,
    'currentWater': 5,
    'sleepGoal': 8.0,
    'currentSleep': 6.5,
  };

  // Notification settings
  static const Map<String, bool> notificationDefaults = {
    'workoutReminders': true,
    'goalAchievements': true,
    'weeklyReport': true,
    'hydrationAlerts': false,
    'restDayReminders': true,
    'newWorkouts': false,
  };
}
