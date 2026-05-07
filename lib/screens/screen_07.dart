import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';
import '../utils/helpers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AppData.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bgSurface, width: 3),
                        ),
                        child: const Center(
                          child: Text('AJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 28)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bgDark, width: 2),
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(user.name, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 4),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${user.fitnessLevel} • ${user.goal}',
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Achievement stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _AchievStat(value: '${user.totalWorkouts}', label: 'Workouts')),
                  const SizedBox(width: 12),
                  Expanded(child: _AchievStat(value: Helpers.formatDuration(user.totalMinutes), label: 'Active')),
                  const SizedBox(width: 12),
                  Expanded(child: _AchievStat(value: Helpers.formatCalories(user.totalCalories), label: 'Calories')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Body stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Body Stats'),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.bgSurface),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(child: _BodyStatItem(label: 'Age', value: '${user.age} yrs', icon: Icons.cake_outlined, color: AppColors.primary)),
                              const SizedBox(width: 12),
                              Expanded(child: _BodyStatItem(label: 'Height', value: Helpers.formatHeight(user.height), icon: Icons.height, color: AppColors.secondary)),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(child: _BodyStatItem(label: 'Weight', value: Helpers.formatWeight(user.weight), icon: Icons.monitor_weight_outlined, color: const Color(0xFF9C27B0))),
                              const SizedBox(width: 12),
                              Expanded(child: _BodyStatItem(label: 'BMI', value: '${Helpers.formatBMI(user.weight, user.height)} • ${Helpers.bmiCategory(user.weight, user.height)}', icon: Icons.analytics_outlined, color: Colors.orange)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Achievements'),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _AchievBadge(icon: '🏆', title: 'First Workout', isUnlocked: true),
                        const SizedBox(width: 12),
                        _AchievBadge(icon: '🔥', title: '7-Day Streak', isUnlocked: true),
                        const SizedBox(width: 12),
                        _AchievBadge(icon: '💪', title: '100 Workouts', isUnlocked: true),
                        const SizedBox(width: 12),
                        _AchievBadge(icon: '⚡', title: 'HIIT Master', isUnlocked: false),
                        const SizedBox(width: 12),
                        _AchievBadge(icon: '🧘', title: 'Zen Master', isUnlocked: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _MenuTile(icon: Icons.flag_outlined, label: 'My Goals', trailing: '3 active', onTap: () => Navigator.pushNamed(context, '/goals')),
                  _MenuTile(icon: Icons.history_outlined, label: 'Workout History', trailing: '142 sessions', onTap: () => Navigator.pushNamed(context, '/history')),
                  _MenuTile(icon: Icons.notifications_outlined, label: 'Notifications', trailing: 'On', onTap: () => Navigator.pushNamed(context, '/settings')),
                  _MenuTile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                  _MenuTile(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
                  _MenuTile(
                    icon: Icons.logout_outlined,
                    label: 'Log Out',
                    onTap: () {},
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
        currentIndex: 3,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          const routes = ['/', '/statistics', '/history', '/profile'];
          if (i != 3) Navigator.pushReplacementNamed(context, routes[i]);
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

  void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            TextField(decoration: const InputDecoration(labelText: 'Full Name', labelStyle: TextStyle(color: AppColors.textMuted))),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: AppColors.textMuted)), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Height (cm)', labelStyle: TextStyle(color: AppColors.textMuted)), keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Save Changes', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

class _AchievStat extends StatelessWidget {
  final String value;
  final String label;
  const _AchievStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _BodyStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _BodyStatItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _AchievBadge extends StatelessWidget {
  final String icon;
  final String title;
  final bool isUnlocked;
  const _AchievBadge({required this.icon, required this.title, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.primary.withOpacity(0.12) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withOpacity(0.3) : AppColors.bgSurface,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isUnlocked ? icon : '🔒', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: isUnlocked ? Colors.white : AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
        title: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
        trailing: trailing != null
            ? Text(trailing!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13))
            : const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
