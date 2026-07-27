import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../config/themes.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import 'key_activation_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().themeData;
    final themeProvider = context.watch<ThemeProvider>();
    final appProvider = context.watch<AppProvider>();
    final auth = appProvider.authState;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account card
          _Card(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_rounded,
                          color: theme.primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.status == AuthStatus.active
                                ? 'Licensed User'
                                : auth.status == AuthStatus.trial
                                    ? 'Trial Mode'
                                    : 'Not Logged In',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            auth.status == AuthStatus.active
                                ? auth.activeKey ?? 'Key activated'
                                : auth.status == AuthStatus.trial
                                    ? '${auth.trialMoviesLeft} movies left today'
                                    : 'Tap to activate',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (auth.status == AuthStatus.active ||
                        auth.status == AuthStatus.trial)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: auth.status == AuthStatus.active
                              ? Colors.green.withOpacity(0.2)
                              : theme.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          auth.status == AuthStatus.active ? 'ACTIVE' : 'TRIAL',
                          style: TextStyle(
                            color: auth.status == AuthStatus.active
                                ? Colors.green
                                : theme.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                if (auth.status == AuthStatus.active &&
                    auth.activationDate != null) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  Text(
                    'Activated: ${auth.activationDate!.toIso8601String().substring(0, 10)}  •  Expires: ${auth.activationDate!.add(const Duration(days: 30)).toIso8601String().substring(0, 10)}',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 16),

          // Theme picker
          _SectionTitle(title: 'App Theme', theme: theme),
          const SizedBox(height: 8),
          ...AppThemes.themes.entries.map((entry) {
            final isSelected = themeProvider.currentTheme == entry.key;
            return _Card(
              theme: theme,
              onTap: () => themeProvider.setTheme(entry.key),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: entry.value.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(entry.value.emoji, style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      entry.value.name,
                      style: TextStyle(
                        color: isSelected ? theme.primary : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded,
                        color: theme.primary, size: 22),
                ],
              ),
            ).animate(delay: (AppThemes.themes.keys.toList().indexOf(entry.key) * 50).ms).fadeIn();
          }),

          const SizedBox(height: 16),

          // App section
          _SectionTitle(title: 'App', theme: theme),
          const SizedBox(height: 8),
          _SettingsTile(
            theme: theme,
            icon: Icons.refresh_rounded,
            title: 'Refresh Config',
            subtitle: 'Re-fetch remote config from GitHub',
            onTap: () async {
              await appProvider.init();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Config refreshed')),
                );
              }
            },
          ),
          _SettingsTile(
            theme: theme,
            icon: Icons.info_outline_rounded,
            title: 'App Version',
            subtitle: 'Jazz Cinema Pro v${AppConstants.appVersion}',
            onTap: null,
          ),

          const SizedBox(height: 16),

          // Logout
          if (auth.isLoggedIn)
            _Card(
              theme: theme,
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: theme.surface,
                    title: const Text('Log Out',
                        style: TextStyle(color: Colors.white)),
                    content: const Text('Are you sure you want to log out?',
                        style: TextStyle(color: Colors.white60)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Log Out',
                              style: TextStyle(color: Colors.red[400]))),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  await AuthService.logout();
                  await appProvider.refreshAuth();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const KeyActivationScreen()),
                    (_) => false,
                  );
                }
              },
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red[400], size: 22),
                  const SizedBox(width: 14),
                  Text('Log Out',
                      style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ],
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final AppThemeData theme;
  const _SectionTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: theme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final AppThemeData theme;
  final Widget child;
  final VoidCallback? onTap;
  const _Card({required this.theme, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: child,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final AppThemeData theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _SettingsTile({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      theme: theme,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: theme.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white30, size: 20),
        ],
      ),
    );
  }
}
