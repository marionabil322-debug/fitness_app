import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  String _searchQuery = '';
  String _selectedMuscle = 'All';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _muscleGroups = ['All', 'Legs', 'Chest', 'Back', 'Arms', 'Core', 'Full Body'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Exercise> get _filtered {
    return AppData.exercises.where((e) {
      final matchesSearch = e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.muscleGroup.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesMuscle = _selectedMuscle == 'All' ||
          e.muscleGroup.toLowerCase().contains(_selectedMuscle.toLowerCase());
      return matchesSearch && matchesMuscle;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as WorkoutCategory?;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'All Exercises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Muscle group filter
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _muscleGroups.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => CategoryPill(
                label: _muscleGroups[i],
                isSelected: _selectedMuscle == _muscleGroups[i],
                onTap: () => setState(() => _selectedMuscle = _muscleGroups[i]),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Result count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} exercises',
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(Icons.sort, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      const Text('Sort', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Exercise list
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final e = _filtered[i];
                      return ExerciseTile(
                        name: e.name,
                        sets: e.sets,
                        muscleGroup: e.muscleGroup,
                        icon: e.icon,
                        color: e.color,
                        onTap: () => Navigator.pushNamed(context, '/exercise-detail', arguments: e),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/active-workout'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text('Start Workout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
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
            const Text('Filter Exercises', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            const Text('Difficulty', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Easy', 'Medium', 'Hard'].map((d) => CategoryPill(label: d)).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Duration', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['< 20 min', '20–40 min', '> 40 min'].map((d) => CategoryPill(label: d)).toList(),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Apply Filters',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: AppColors.textMuted, size: 60),
          const SizedBox(height: 16),
          const Text('No exercises found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Try a different search or filter', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
