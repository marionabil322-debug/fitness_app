import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _period = 'Week';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxMinutes = AppData.weeklyStats.map((s) => s.minutes).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.bgSurface),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _period,
                isDense: true,
                dropdownColor: AppColors.bgCard,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                items: ['Week', 'Month', 'Year']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _period = v!),
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
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Workouts',
                    value: '142',
                    subtitle: 'all time',
                    icon: Icons.fitness_center,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Total Hours',
                    value: '114h',
                    subtitle: 'all time',
                    icon: Icons.timer_outlined,
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
                    title: 'Calories',
                    value: '58.2k',
                    subtitle: 'all time',
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Streak',
                    value: '12 days',
                    subtitle: 'current',
                    icon: Icons.bolt,
                    iconColor: const Color(0xFFFFC107),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Activity chart
            const SectionHeader(title: 'Activity Overview'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.bgSurface),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Minutes', style: theme.textTheme.titleLarge),
                      Text('This Week', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('300 min total', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),

                  // Bar chart
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: AppData.weeklyStats.map((stat) {
                        final barHeight = maxMinutes > 0 ? (stat.minutes / maxMinutes) * 120 : 0.0;
                        final isToday = stat.day == Helpers.weekdayShort(DateTime.now());
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (stat.minutes > 0)
                              Text(
                                '${stat.minutes.toInt()}',
                                style: TextStyle(
                                  color: isToday ? AppColors.primary : AppColors.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              width: 28,
                              height: barHeight.clamp(4, 120),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isToday
                                      ? [AppColors.primary, AppColors.primaryLight]
                                      : [AppColors.bgSurface, AppColors.bgSurface],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              stat.day,
                              style: TextStyle(
                                color: isToday ? AppColors.primary : AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Calories chart
            const SectionHeader(title: 'Calories Burned'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.bgSurface),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2,540 kcal', style: TextStyle(color: AppColors.secondary, fontSize: 24, fontWeight: FontWeight.w800)),
                  Text('This week', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  _LineChart(stats: AppData.weeklyStats),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category breakdown
            const SectionHeader(title: 'Workout Breakdown'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.bgSurface),
              ),
              child: Column(
                children: [
                  _BreakdownBar(label: 'Strength', percentage: 0.45, color: AppColors.primary),
                  const SizedBox(height: 12),
                  _BreakdownBar(label: 'Cardio', percentage: 0.28, color: AppColors.secondary),
                  const SizedBox(height: 12),
                  _BreakdownBar(label: 'HIIT', percentage: 0.18, color: const Color(0xFFFFC107)),
                  const SizedBox(height: 12),
                  _BreakdownBar(label: 'Yoga', percentage: 0.09, color: const Color(0xFF9C27B0)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal records
            const SectionHeader(title: 'Personal Records'),
            const SizedBox(height: 14),
            ...[
              ('Longest Workout', '85 min', Icons.timer, AppColors.primary),
              ('Most Calories', '680 kcal', Icons.local_fire_department, Colors.orange),
              ('Longest Streak', '21 days', Icons.bolt, const Color(0xFFFFC107)),
              ('Most Exercises', '12', Icons.fitness_center, AppColors.secondary),
            ].map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InfoRow(icon: r.$3, label: r.$1, value: r.$2, iconColor: r.$4),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgSurface)),
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          const routes = ['/', '/statistics', '/history', '/profile'];
          if (i != 1) Navigator.pushReplacementNamed(context, routes[i]);
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

class _BreakdownBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _BreakdownBar({required this.label, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
            Text('${(percentage * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.bgSurface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<WeeklyStats> stats;

  const _LineChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxCal = stats.map((s) => s.calories.toDouble()).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 80,
      child: CustomPaint(
        painter: _LinePainter(stats: stats, maxCal: maxCal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: stats.map((s) => Text(
            s.day,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          )).toList(),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<WeeklyStats> stats;
  final double maxCal;

  _LinePainter({required this.stats, required this.maxCal});

  @override
  void paint(Canvas canvas, Size size) {
    if (maxCal == 0) return;
    final paint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final path = Path();
    const bottomPad = 20.0;
    final availH = size.height - bottomPad;
    final step = size.width / (stats.length - 1);

    for (int i = 0; i < stats.length; i++) {
      final x = i * step;
      final y = availH - (stats[i].calories / maxCal) * (availH - 10);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
