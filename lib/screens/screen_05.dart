import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _restSeconds = 0;
  bool _isResting = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<Exercise> _exercises = AppData.exercises.take(4).toList();

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_isResting) {
          if (_restSeconds > 0) {
            _restSeconds--;
          } else {
            _isResting = false;
          }
        } else {
          _elapsedSeconds++;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _restSeconds = 60;
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
        _isResting = false;
      });
    } else {
      _finishWorkout();
    }
  }

  void _nextSet() {
    final exercise = _exercises[_currentExerciseIndex];
    final maxSets = int.tryParse(exercise.sets.split(' ').first) ?? 3;
    if (_currentSet < maxSets) {
      setState(() => _currentSet++);
      _startRest();
    } else {
      _nextExercise();
    }
  }

  void _finishWorkout() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _WorkoutCompleteDialog(
        duration: _elapsedSeconds,
        exerciseCount: _exercises.length,
        calories: (_elapsedSeconds / 60 * 8).toInt(),
        onDone: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercise = _exercises[_currentExerciseIndex];
    final totalSets = int.tryParse(exercise.sets.split(' ').first) ?? 3;
    final progress = _currentExerciseIndex / _exercises.length;

    return WillPopScope(
      onWillPop: () async {
        if (_isRunning) {
          _pauseTimer();
          return await _showExitDialog(context) ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Workout'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (_isRunning) _pauseTimer();
              final exit = await _showExitDialog(context);
              if (exit == true && mounted) Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  Helpers.formatSeconds(_elapsedSeconds),
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
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
              // Overall progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
                      style: theme.textTheme.bodyMedium),
                  Text('${(progress * 100).toInt()}% complete',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress +
                      (1 / _exercises.length) * (_currentSet / totalSets),
                  backgroundColor: AppColors.bgSurface,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 28),

              // Current exercise
              if (_isResting)
                _RestCard(
                    restSeconds: _restSeconds,
                    onSkip: () => setState(() => _isResting = false))
              else
                _ExerciseCard(
                  exercise: exercise,
                  currentSet: _currentSet,
                  totalSets: totalSets,
                  isRunning: _isRunning,
                  pulseAnim: _pulseAnim,
                ),
              const SizedBox(height: 24),

              // Timer display
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.bgSurface),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Helpers.formatSeconds(_elapsedSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text('Workout Time', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Controls
              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      label: _isPaused
                          ? 'Resume'
                          : (_isRunning ? 'Pause' : 'Start'),
                      icon: _isPaused
                          ? Icons.play_arrow_rounded
                          : (_isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
                      onPressed: () {
                        if (!_isRunning) {
                          _startTimer();
                        } else if (_isPaused) {
                          _resumeTimer();
                        } else {
                          _pauseTimer();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentSet < totalSets
                          ? 'Done Set $_currentSet'
                          : 'Next Exercise',
                      icon: Icons.check_rounded,
                      onPressed: _isRunning ? _nextSet : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Upcoming exercises
              SectionHeader(title: 'Up Next'),
              const SizedBox(height: 12),
              ..._exercises.skip(_currentExerciseIndex + 1).take(3).map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ExerciseTile(
                        name: e.name,
                        sets: e.sets,
                        muscleGroup: e.muscleGroup,
                        icon: e.icon,
                        color: e.color.withOpacity(0.5),
                      ),
                    ),
                  ),

              const SizedBox(height: 20),
              OutlineButton(
                label: 'Finish Workout',
                icon: Icons.flag_outlined,
                onPressed: _finishWorkout,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title:
            const Text('Exit Workout?', style: TextStyle(color: Colors.white)),
        content: Text('Your progress will be lost.',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () {
                _startTimer();
                Navigator.pop(context, false);
              },
              child: const Text('Continue')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int currentSet;
  final int totalSets;
  final bool isRunning;
  final Animation<double> pulseAnim;

  const _ExerciseCard({
    required this.exercise,
    required this.currentSet,
    required this.totalSets,
    required this.isRunning,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [exercise.color, exercise.color.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, child) => Transform.scale(
              scale: isRunning ? pulseAnim.value : 1.0,
              child: child,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(exercise.icon, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(exercise.muscleGroup,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                Text(
                  'Set $currentSet of $totalSets  •  ${exercise.reps}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestCard extends StatelessWidget {
  final int restSeconds;
  final VoidCallback onSkip;

  const _RestCard({required this.restSeconds, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ProgressRing(
            progress: restSeconds / 60,
            size: 70,
            color: AppColors.secondary,
            child: Text(
              '$restSeconds',
              style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rest Time',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Recover before next set',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          TextButton(
            onPressed: onSkip,
            child: const Text('Skip',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCompleteDialog extends StatelessWidget {
  final int duration;
  final int exerciseCount;
  final int calories;
  final VoidCallback onDone;

  const _WorkoutCompleteDialog({
    required this.duration,
    required this.exerciseCount,
    required this.calories,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Workout Complete!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Great job! You crushed it today.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ResultStat(
                    value: Helpers.formatSeconds(duration), label: 'Duration'),
                _ResultStat(value: '$exerciseCount', label: 'Exercises'),
                _ResultStat(value: '$calories', label: 'Calories'),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Done', onPressed: onDone),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String value;
  final String label;
  const _ResultStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
