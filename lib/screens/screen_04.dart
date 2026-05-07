import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

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
    final exercise = ModalRoute.of(context)?.settings.arguments as Exercise?
        ?? AppData.exercises.first;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero app bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.share_outlined, size: 18),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [exercise.color, exercise.color.withOpacity(0.5), AppColors.bgDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Video placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(exercise.icon, color: Colors.white, size: 50),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap to play demo video', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & tags
                  Row(
                    children: [
                      Expanded(
                        child: Text(exercise.name, style: theme.textTheme.displaySmall),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Helpers.difficultyColor(exercise.difficulty).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          exercise.difficulty,
                          style: TextStyle(
                            color: Helpers.difficultyColor(exercise.difficulty),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(exercise.muscleGroup, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      _StatBadge(icon: Icons.timer_outlined, label: exercise.duration, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      _StatBadge(icon: Icons.repeat, label: exercise.sets, color: AppColors.primary),
                      const SizedBox(width: 10),
                      _StatBadge(icon: Icons.local_fire_department, label: '${exercise.calories} kcal', color: Colors.orange),
                      const SizedBox(width: 10),
                      _StatBadge(icon: Icons.refresh, label: exercise.reps, color: const Color(0xFF9C27B0)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Instructions'),
                      Tab(text: 'Tips'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Overview tab
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('About this exercise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 10),
                              Text(exercise.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
                              const SizedBox(height: 20),
                              const Text('Muscles Targeted', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: exercise.muscleGroup.split('•').map((m) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: exercise.color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: exercise.color.withOpacity(0.3)),
                                  ),
                                  child: Text(m.trim(), style: TextStyle(color: exercise.color, fontWeight: FontWeight.w600, fontSize: 12)),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),

                        // Instructions tab
                        ListView.builder(
                          itemCount: exercise.instructions.length,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text('${i + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(exercise.instructions[i],
                                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tips tab
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              _TipCard(
                                icon: Icons.warning_amber_rounded,
                                title: 'Common Mistakes',
                                content: 'Avoid rounding your back or using momentum. Focus on controlled movements throughout the full range of motion.',
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              _TipCard(
                                icon: Icons.lightbulb_outline,
                                title: 'Pro Tip',
                                content: 'Start with lighter weights to perfect your form before adding more load. Quality over quantity.',
                                color: AppColors.secondary,
                              ),
                              const SizedBox(height: 12),
                              _TipCard(
                                icon: Icons.medical_services_outlined,
                                title: 'Safety Note',
                                content: 'Warm up for at least 5 minutes before attempting this exercise. Consult a trainer if you are a beginner.',
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CTA buttons
                  PrimaryButton(
                    label: 'Add to Workout',
                    icon: Icons.add,
                    onPressed: () => Navigator.pushNamed(context, '/active-workout'),
                  ),
                  const SizedBox(height: 10),
                  OutlineButton(
                    label: 'Save to Favorites',
                    icon: Icons.bookmark_border,
                    onPressed: () => setState(() => _isFavorite = true),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _TipCard({required this.icon, required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 6),
                Text(content, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
