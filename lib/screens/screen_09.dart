import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Strength', 'Cardio', 'HIIT', 'Yoga'];

  List<WorkoutHistory> get _filtered {
    if (_selectedFilter == 'All') return AppData.workoutHistory;
    return AppData.workoutHistory.where((h) => h.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group history by month/week label
    final grouped = <String, List<WorkoutHistory>>{};
    for (final h in _filtered) {
      final diff = DateTime.now().difference(h.date).inDays;
      final label = diff < 7 ? 'This Week' : (diff < 14 ? 'Last Week' : 'Earlier');
      grouped.putIfAbsent(label, () => []).add(h);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showSortSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary stats
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(value: '${AppData.workoutHistory.length}', label: 'Sessions'),
                _Divider(),
                _SummaryItem(
                  value: Helpers.formatDuration(
                    AppData.workoutHistory.fold(0, (sum, h) => sum + h.durationMinutes),
                  ),
                  label: 'Total Time',
                ),
                _Divider(),
                _SummaryItem(
                  value: '${AppData.workoutHistory.fold(0, (sum, h) => sum + h.caloriesBurned)}',
                  label: 'Calories',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => CategoryPill(
                label: _filters[i],
                isSelected: _selectedFilter == _filters[i],
                onTap: () => setState(() => _selectedFilter = _filters[i]),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // History list
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyHistory()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, groupIndex) {
                      final groupKey = grouped.keys.elementAt(groupIndex);
                      final items = grouped[groupKey]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              groupKey,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          ...items.map((h) => _HistoryCard(
                            history: h,
                            onTap: () => _showDetail(context, h),
                          )),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/categories'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Workout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  void _showDetail(BuildContext context, WorkoutHistory history) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(Helpers.categoryEmoji(history.category), style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(history.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                      Text(Helpers.formatDate(history.date), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.bgSurface),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DetailStat(icon: Icons.timer_outlined, value: Helpers.formatDuration(history.durationMinutes), label: 'Duration', color: AppColors.secondary),
                _DetailStat(icon: Icons.local_fire_department, value: '${history.caloriesBurned}', label: 'Calories', color: Colors.orange),
                _DetailStat(icon: Icons.fitness_center, value: '${history.exercisesCount}', label: 'Exercises', color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    label: 'Delete',
                    icon: Icons.delete_outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Repeat',
                    icon: Icons.replay,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/active-workout');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ('Date (Newest first)', true),
              ('Date (Oldest first)', false),
              ('Duration (Longest first)', false),
              ('Calories (Most first)', false),
            ].map((opt) => ListTile(
              title: Text(opt.$1, style: const TextStyle(color: Colors.white, fontSize: 14)),
              trailing: opt.$2 ? const Icon(Icons.check, color: AppColors.primary) : null,
              contentPadding: EdgeInsets.zero,
              onTap: () => Navigator.pop(context),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgSurface)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          const routes = ['/', '/statistics', '/history', '/profile'];
          if (i != 2) Navigator.pushReplacementNamed(context, routes[i]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final WorkoutHistory history;
  final VoidCallback? onTap;

  const _HistoryCard({required this.history, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(Helpers.categoryEmoji(history.category), style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(history.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(Helpers.formatDate(history.date), style: theme.textTheme.bodyMedium),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(history.category, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MiniStat(icon: Icons.timer_outlined, value: Helpers.formatDuration(history.durationMinutes), color: AppColors.secondary),
                  _VSep(),
                  _MiniStat(icon: Icons.local_fire_department, value: '${history.caloriesBurned} kcal', color: Colors.orange),
                  _VSep(),
                  _MiniStat(icon: Icons.fitness_center, value: '${history.exercisesCount} ex.', color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MiniStat({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}

class _VSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 16, color: AppColors.bgCard);
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.white24);
  }
}

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DetailStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏋️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('No workouts found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Start your first workout today!', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              label: 'Start Workout',
              onPressed: () => Navigator.pushNamed(context, '/categories'),
            ),
          ),
        ],
      ),
    );
  }
}
