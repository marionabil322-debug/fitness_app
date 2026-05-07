import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';

class WorkoutCategoriesScreen extends StatefulWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  State<WorkoutCategoriesScreen> createState() =>
      _WorkoutCategoriesScreenState();
}

class _WorkoutCategoriesScreenState extends State<WorkoutCategoriesScreen> {
  String _selected = 'All';
  final List<String> _filters = [
    'All',
    'Popular',
    'Beginner',
    'Advanced',
    'Short'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.bgSurface),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('🔥 Featured',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 10),
                        const Text('Full Body\nBlast',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.1)),
                        const SizedBox(height: 8),
                        Text('6 exercises • 45 min • Hard',
                            style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: 140,
                          child: PrimaryButton(
                            label: 'Start Now',
                            onPressed: () =>
                                Navigator.pushNamed(context, '/active-workout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        const Icon(Icons.bolt, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Filter pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Explore'),
            ),

            const SizedBox(height: 18),

            // Category grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: AppData.categories.length,
                itemBuilder: (context, index) {
                  final cat = AppData.categories[index];
                  return _CategoryCard(category: cat);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Popular workouts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                title: 'Popular Workouts',
                actionLabel: 'See all',
              ),
            ),
            const SizedBox(height: 14),
            ...AppData.exercises.take(4).map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: ExerciseTile(
                    name: e.name,
                    sets: e.sets,
                    muscleGroup: e.muscleGroup,
                    icon: e.icon,
                    color: e.color,
                    onTap: () => Navigator.pushNamed(
                        context, '/exercise-detail',
                        arguments: e),
                  ),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final WorkoutCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/exercises', arguments: category),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.bgSurface),
        ),
        child: Stack(
          children: [
            // Background accent
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: category.color, size: 24),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${category.workoutCount} workouts',
                        style: TextStyle(
                            color: category.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Text(category.description,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
