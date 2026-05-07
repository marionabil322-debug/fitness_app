import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late Map<String, dynamic> _goals;
  int _dailyStepGoal = 10000;
  double _weightGoal = 72.0;
  int _weeklyWorkoutsGoal = 5;
  int _calorieGoal = 2500;
  int _waterGoal = 8;
  double _sleepGoal = 8.0;

  @override
  void initState() {
    super.initState();
    _goals = Map<String, dynamic>.from(AppData.goalsData);
    _dailyStepGoal = _goals['dailySteps'] as int;
    _weightGoal = (_goals['weightGoal'] as num).toDouble();
    _weeklyWorkoutsGoal = _goals['weeklyWorkouts'] as int;
    _calorieGoal = _goals['calorieGoal'] as int;
    _waterGoal = _goals['waterGoal'] as int;
    _sleepGoal = (_goals['sleepGoal'] as num).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goals = AppData.goalsData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Setting'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Goals saved successfully!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's progress overview
            const SectionHeader(title: "Today's Progress"),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ProgressGoalCard(
                    icon: '👟',
                    title: 'Steps',
                    current: goals['currentSteps'] as int,
                    goal: goals['dailySteps'] as int,
                    unit: 'steps',
                    color: AppColors.secondary,
                    formatValue: (v) => Helpers.formatSteps(v.toInt()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressGoalCard(
                    icon: '🔥',
                    title: 'Calories',
                    current: goals['currentCalories'] as int,
                    goal: goals['calorieGoal'] as int,
                    unit: 'kcal',
                    color: Colors.orange,
                    formatValue: (v) => '${v.toInt()}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ProgressGoalCard(
                    icon: '💧',
                    title: 'Water',
                    current: goals['currentWater'] as int,
                    goal: goals['waterGoal'] as int,
                    unit: 'glasses',
                    color: AppColors.info,
                    formatValue: (v) => '${v.toInt()}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressGoalCard(
                    icon: '💤',
                    title: 'Sleep',
                    current: (goals['currentSleep'] as num).toInt(),
                    goal: (goals['sleepGoal'] as num).toInt(),
                    unit: 'hrs',
                    color: const Color(0xFF9C27B0),
                    formatValue: (v) => '${(goals['currentSleep'] as num).toStringAsFixed(1)}h',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Goal editors
            const SectionHeader(title: 'Set Your Goals'),
            const SizedBox(height: 16),

            // Daily steps goal
            _GoalSlider(
              icon: Icons.directions_walk,
              title: 'Daily Steps',
              value: _dailyStepGoal.toDouble(),
              min: 2000,
              max: 20000,
              divisions: 18,
              color: AppColors.secondary,
              displayValue: Helpers.formatSteps(_dailyStepGoal),
              onChanged: (v) => setState(() => _dailyStepGoal = v.toInt()),
            ),
            const SizedBox(height: 16),

            // Weekly workouts
            _GoalSlider(
              icon: Icons.fitness_center,
              title: 'Weekly Workouts',
              value: _weeklyWorkoutsGoal.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              color: AppColors.primary,
              displayValue: '$_weeklyWorkoutsGoal days',
              onChanged: (v) => setState(() => _weeklyWorkoutsGoal = v.toInt()),
            ),
            const SizedBox(height: 16),

            // Weight goal
            _GoalSlider(
              icon: Icons.monitor_weight_outlined,
              title: 'Weight Goal',
              value: _weightGoal,
              min: 40,
              max: 150,
              divisions: 110,
              color: const Color(0xFF9C27B0),
              displayValue: Helpers.formatWeight(_weightGoal),
              onChanged: (v) => setState(() => _weightGoal = (v * 10).round() / 10),
            ),
            const SizedBox(height: 16),

            // Calorie goal
            _GoalSlider(
              icon: Icons.local_fire_department,
              title: 'Daily Calorie Goal',
              value: _calorieGoal.toDouble(),
              min: 1200,
              max: 4000,
              divisions: 28,
              color: Colors.orange,
              displayValue: '$_calorieGoal kcal',
              onChanged: (v) => setState(() => _calorieGoal = (v / 100).round() * 100),
            ),
            const SizedBox(height: 16),

            // Water intake
            _GoalSlider(
              icon: Icons.water_drop_outlined,
              title: 'Daily Water Intake',
              value: _waterGoal.toDouble(),
              min: 4,
              max: 16,
              divisions: 12,
              color: AppColors.info,
              displayValue: '$_waterGoal glasses',
              onChanged: (v) => setState(() => _waterGoal = v.toInt()),
            ),
            const SizedBox(height: 16),

            // Sleep goal
            _GoalSlider(
              icon: Icons.bedtime_outlined,
              title: 'Sleep Goal',
              value: _sleepGoal,
              min: 5,
              max: 10,
              divisions: 10,
              color: const Color(0xFF9C27B0),
              displayValue: '${_sleepGoal.toStringAsFixed(1)}h',
              onChanged: (v) => setState(() => _sleepGoal = (v * 2).round() / 2),
            ),
            const SizedBox(height: 28),

            // Fitness goal type
            const SectionHeader(title: 'Primary Fitness Goal'),
            const SizedBox(height: 14),
            ...[
              ('🏋️', 'Build Muscle', 'Increase strength and muscle mass'),
              ('🏃', 'Lose Weight', 'Burn fat and reduce body weight'),
              ('⚡', 'Improve Endurance', 'Build cardiovascular fitness'),
              ('🧘', 'Stay Healthy', 'Maintain overall wellness'),
            ].map((g) => _GoalOptionTile(
              emoji: g.$1,
              title: g.$2,
              subtitle: g.$3,
              isSelected: g.$2 == AppData.userProfile.goal,
            )),

            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Save All Goals',
              icon: Icons.check_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goals saved successfully! 🎯'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProgressGoalCard extends StatelessWidget {
  final String icon;
  final String title;
  final int current;
  final int goal;
  final String unit;
  final Color color;
  final String Function(double) formatValue;

  const _ProgressGoalCard({
    required this.icon,
    required this.title,
    required this.current,
    required this.goal,
    required this.unit,
    required this.color,
    required this.formatValue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              Text(Helpers.formatPercentage(progress), style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatValue(current.toDouble()), style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text('/ $goal $unit', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgSurface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Color color;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.color,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(displayValue, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              thumbColor: color,
              inactiveTrackColor: AppColors.bgSurface,
              overlayColor: color.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toInt()}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text('${max.toInt()}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalOptionTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;

  const _GoalOptionTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.bgSurface,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isSelected ? AppColors.primary : Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}
