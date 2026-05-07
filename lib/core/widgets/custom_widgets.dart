import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ─── Primary Action Button ───────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

// ─── Secondary / Outline Button ──────────────────────────────────────────────
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? bgColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgSurface, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
              ),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ─── Workout Card ─────────────────────────────────────────────────────────────
class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String difficulty;
  final Color accentColor;
  final IconData icon;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.difficulty,
    required this.accentColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bgSurface, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Chip(
                          label: duration,
                          icon: Icons.timer_outlined,
                          color: AppColors.secondary),
                      const SizedBox(width: 6),
                      _Chip(
                          label: difficulty,
                          icon: Icons.fitness_center,
                          color: accentColor),
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

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _Chip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineMedium),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Progress Ring ────────────────────────────────────────────────────────────
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color color;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.color = AppColors.primary,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: AppColors.bgSurface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeCap: StrokeCap.round,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Category Pill ────────────────────────────────────────────────────────────
class CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.bgSurface,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─── Exercise List Tile ───────────────────────────────────────────────────────
class ExerciseTile extends StatelessWidget {
  final String name;
  final String sets;
  final String muscleGroup;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ExerciseTile({
    super.key,
    required this.name,
    required this.sets,
    required this.muscleGroup,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.bgSurface, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 3),
                  Text(muscleGroup, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            Text(sets,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
