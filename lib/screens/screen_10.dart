import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_widgets.dart';
import '../data/app_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, bool> _notifications;
  bool _darkMode = true;
  bool _metricUnits = true;
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  String _reminderTime = '07:00 AM';
  String _language = 'English';
  String _fitnessLevel = 'Intermediate';

  @override
  void initState() {
    super.initState();
    _notifications = Map<String, bool>.from(AppData.notificationDefaults);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Notifications Section ─────────────────────────────────────────
          _SectionLabel(label: 'NOTIFICATIONS'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.fitness_center,
                iconColor: AppColors.primary,
                title: 'Workout Reminders',
                subtitle: 'Get reminded to work out',
                value: _notifications['workoutReminders']!,
                onChanged: (v) => setState(() => _notifications['workoutReminders'] = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.emoji_events_outlined,
                iconColor: const Color(0xFFFFC107),
                title: 'Goal Achievements',
                subtitle: 'Celebrate your milestones',
                value: _notifications['goalAchievements']!,
                onChanged: (v) => setState(() => _notifications['goalAchievements'] = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.bar_chart_outlined,
                iconColor: AppColors.secondary,
                title: 'Weekly Report',
                subtitle: 'Summary of your progress',
                value: _notifications['weeklyReport']!,
                onChanged: (v) => setState(() => _notifications['weeklyReport'] = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.water_drop_outlined,
                iconColor: AppColors.info,
                title: 'Hydration Alerts',
                subtitle: 'Reminders to drink water',
                value: _notifications['hydrationAlerts']!,
                onChanged: (v) => setState(() => _notifications['hydrationAlerts'] = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.self_improvement,
                iconColor: const Color(0xFF9C27B0),
                title: 'Rest Day Reminders',
                subtitle: 'Know when to take a break',
                value: _notifications['restDayReminders']!,
                onChanged: (v) => setState(() => _notifications['restDayReminders'] = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.new_releases_outlined,
                iconColor: Colors.teal,
                title: 'New Workouts',
                subtitle: 'Be notified of new content',
                value: _notifications['newWorkouts']!,
                onChanged: (v) => setState(() => _notifications['newWorkouts'] = v),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Reminder time
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.alarm_outlined,
                iconColor: AppColors.primary,
                title: 'Reminder Time',
                trailing: _reminderTime,
                onTap: () => _pickTime(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Appearance Section ────────────────────────────────────────────
          _SectionLabel(label: 'APPEARANCE'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_outlined,
                iconColor: const Color(0xFF9C27B0),
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.language_outlined,
                iconColor: AppColors.secondary,
                title: 'Language',
                trailing: _language,
                onTap: () => _showLanguagePicker(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Preferences Section ───────────────────────────────────────────
          _SectionLabel(label: 'PREFERENCES'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.straighten_outlined,
                iconColor: AppColors.primary,
                title: 'Metric Units',
                subtitle: 'Use kg, cm instead of lbs, ft',
                value: _metricUnits,
                onChanged: (v) => setState(() => _metricUnits = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.volume_up_outlined,
                iconColor: Colors.orange,
                title: 'Sound Effects',
                subtitle: 'Play sounds during workout',
                value: _soundEffects,
                onChanged: (v) => setState(() => _soundEffects = v),
              ),
              _Separator(),
              _SwitchTile(
                icon: Icons.vibration_outlined,
                iconColor: const Color(0xFFFFC107),
                title: 'Haptic Feedback',
                subtitle: 'Vibrate on interactions',
                value: _hapticFeedback,
                onChanged: (v) => setState(() => _hapticFeedback = v),
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.fitness_center,
                iconColor: AppColors.primary,
                title: 'Fitness Level',
                trailing: _fitnessLevel,
                onTap: () => _showFitnessLevelPicker(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Account Section ───────────────────────────────────────────────
          _SectionLabel(label: 'ACCOUNT'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.person_outline,
                iconColor: AppColors.secondary,
                title: 'Edit Profile',
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.flag_outlined,
                iconColor: AppColors.primary,
                title: 'Set Goals',
                onTap: () => Navigator.pushNamed(context, '/goals'),
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.lock_outline,
                iconColor: Colors.grey,
                title: 'Change Password',
                onTap: () {},
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.cloud_upload_outlined,
                iconColor: AppColors.info,
                title: 'Backup & Sync',
                trailing: 'Enabled',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Support Section ───────────────────────────────────────────────
          _SectionLabel(label: 'SUPPORT'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _NavigationTile(icon: Icons.help_outline, iconColor: AppColors.secondary, title: 'Help Center', onTap: () {}),
              _Separator(),
              _NavigationTile(icon: Icons.feedback_outlined, iconColor: Colors.orange, title: 'Send Feedback', onTap: () {}),
              _Separator(),
              _NavigationTile(icon: Icons.star_outline, iconColor: const Color(0xFFFFC107), title: 'Rate the App', onTap: () {}),
              _Separator(),
              _NavigationTile(icon: Icons.privacy_tip_outlined, iconColor: Colors.grey, title: 'Privacy Policy', onTap: () {}),
              _Separator(),
              _NavigationTile(icon: Icons.description_outlined, iconColor: Colors.grey, title: 'Terms of Service', onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),

          // App version
          Center(
            child: Column(
              children: [
                Text('FitPulse', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Version 1.0.0 (Build 42)', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Danger zone
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Icons.logout_outlined,
                iconColor: AppColors.error,
                title: 'Log Out',
                textColor: AppColors.error,
                onTap: () => _showLogoutDialog(context),
              ),
              _Separator(),
              _NavigationTile(
                icon: Icons.delete_forever_outlined,
                iconColor: AppColors.error,
                title: 'Delete Account',
                textColor: AppColors.error,
                onTap: () => _showDeleteDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked.format(context));
    }
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Language', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...['English', 'Spanish', 'French', 'German', 'Arabic', 'Japanese'].map(
              (lang) => ListTile(
                title: Text(lang, style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: lang == _language ? const Icon(Icons.check, color: AppColors.primary) : null,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  setState(() => _language = lang);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFitnessLevelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fitness Level', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ('Beginner', 'New to working out', '🌱'),
              ('Intermediate', '1–3 years of training', '💪'),
              ('Advanced', '3+ years, high intensity', '🔥'),
              ('Elite', 'Competitive athlete', '🏆'),
            ].map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: item.$1 == _fitnessLevel ? AppColors.primary.withOpacity(0.1) : AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.$1 == _fitnessLevel ? AppColors.primary : Colors.transparent,
                  ),
                ),
                child: ListTile(
                  leading: Text(item.$3, style: const TextStyle(fontSize: 20)),
                  title: Text(item.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(item.$2, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  trailing: item.$1 == _fitnessLevel ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() => _fitnessLevel = item.$1);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Log Out', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to log out?', style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Delete Account', style: TextStyle(color: AppColors.error)),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgSurface),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12))
          : null,
      trailing: Switch(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _NavigationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: textColor ?? AppColors.textMuted, size: 18),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 64,
      endIndent: 0,
      color: AppColors.bgSurface,
    );
  }
}
