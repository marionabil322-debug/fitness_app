import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Helpers.getMotivationalMessage(hour),
              style: theme.textTheme.bodyMedium,
            ),
            Text('FitPulse', style: theme.textTheme.displaySmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('PR',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly progress banner
            _WeeklyBanner(),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Workouts',
                    value: '3',
                    subtitle: 'this week',
                    icon: Icons.fitness_center,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Calories',
                    value: '1.2k',
                    subtitle: 'burned',
                    icon: Icons.local_fire_department,
                    iconColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Active Min',
                    value: '185',
                    subtitle: 'this week',
                    icon: Icons.timer_outlined,
                    iconColor: const Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Steps',
                    value: '7.4k',
                    subtitle: 'today',
                    icon: Icons.directions_walk,
                    iconColor: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Quick start
            SectionHeader(
              title: 'Quick Start',
              actionLabel: 'All workouts',
              onAction: () => Navigator.pushNamed(context, '/categories'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppData.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = AppData.categories[index];
                  return SizedBox(
                    width: 180,
                    child: WorkoutCard(
                      title: cat.name,
                      subtitle: cat.description,
                      duration: '${20 + index * 5} min',
                      difficulty:
                          index < 2 ? 'Medium' : (index < 4 ? 'Hard' : 'Easy'),
                      accentColor: cat.color,
                      icon: cat.icon,
                      onTap: () => Navigator.pushNamed(context, '/exercises',
                          arguments: cat),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Today's plan
            SectionHeader(
              title: "Today's Plan",
              actionLabel: 'Schedule',
              onAction: () => Navigator.pushNamed(context, '/history'),
            ),
            const SizedBox(height: 14),
            _TodayPlanCard(context: context),
            const SizedBox(height: 28),

            // Recent activity
            SectionHeader(
              title: 'Recent Activity',
              actionLabel: 'See all',
              onAction: () => Navigator.pushNamed(context, '/history'),
            ),
            const SizedBox(height: 14),
            ...AppData.workoutHistory
                .take(3)
                .map((h) => _ActivityTile(history: h)),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _WeeklyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Goal',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                const Text(
                  '3 of 5 workouts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white30,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('60% complete',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          ProgressRing(
            progress: 0.6,
            size: 80,
            strokeWidth: 7,
            color: Colors.white,
            child: const Text(
              '60%',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayPlanCard extends StatelessWidget {
  final BuildContext context;
  const _TodayPlanCard({required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fitness_center,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Full Body Strength',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    const SizedBox(height: 3),
                    Text('6 exercises • 55 min',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Scheduled',
                    style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Start Workout',
            icon: Icons.play_arrow_rounded,
            onPressed: () => Navigator.pushNamed(context, '/active-workout'),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final WorkoutHistory history;
  const _ActivityTile({required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(Helpers.categoryEmoji(history.category),
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(history.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(Helpers.formatDate(history.date),
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${history.caloriesBurned} kcal',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 3),
              Text(Helpers.formatDuration(history.durationMinutes),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgSurface)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          const routes = ['/', '/statistics', '/history', '/profile'];
          if (i != currentIndex)
            Navigator.pushReplacementNamed(context, routes[i]);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
