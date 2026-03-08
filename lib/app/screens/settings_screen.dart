import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/core/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  UserSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(settingsServiceProvider);
      final settings = await service.getUserSettings();
      if (mounted) setState(() { _settings = settings; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Account Section
                _SectionHeader(title: 'Account'),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Edit Profile'),
                  subtitle: Text(user?.username ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/edit-profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/change-password'),
                ),
                const Divider(),

                // Privacy Section
                _SectionHeader(title: 'Privacy'),
                SwitchListTile(
                  secondary: const Icon(Icons.lock),
                  title: const Text('Private Account'),
                  subtitle: const Text('Only followers can see your content'),
                  value: _settings?.privacy.privateAccount ?? false,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updatePrivacySettings({'private_account': value});
                    _loadSettings();
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility),
                  title: const Text('Show Activity Status'),
                  subtitle: const Text('Let others see when you\'re online'),
                  value: _settings?.privacy.showActivityStatus ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updatePrivacySettings({'show_activity_status': value});
                    _loadSettings();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: const Text('Allow Messages From'),
                  subtitle: Text(_settings?.privacy.allowMessagesFrom ?? 'everyone'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSelectionDialog(
                    'Allow Messages From',
                    _settings?.privacy.allowMessagesFrom ?? 'everyone',
                    ['everyone', 'followers', 'none'],
                    (value) async {
                      final service = ref.read(settingsServiceProvider);
                      await service.updatePrivacySettings({'allow_messages_from': value});
                      _loadSettings();
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.comment_outlined),
                  title: const Text('Allow Comments From'),
                  subtitle: Text(_settings?.privacy.allowCommentsFrom ?? 'everyone'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSelectionDialog(
                    'Allow Comments From',
                    _settings?.privacy.allowCommentsFrom ?? 'everyone',
                    ['everyone', 'followers', 'none'],
                    (value) async {
                      final service = ref.read(settingsServiceProvider);
                      await service.updatePrivacySettings({'allow_comments_from': value});
                      _loadSettings();
                    },
                  ),
                ),
                const Divider(),

                // Notifications Section
                _SectionHeader(title: 'Notifications'),
                SwitchListTile(
                  secondary: const Icon(Icons.favorite_border),
                  title: const Text('Likes'),
                  value: _settings?.notifications.likes ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updateNotificationSettings({'likes': value});
                    _loadSettings();
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.comment_outlined),
                  title: const Text('Comments'),
                  value: _settings?.notifications.comments ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updateNotificationSettings({'comments': value});
                    _loadSettings();
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.alternate_email),
                  title: const Text('Mentions'),
                  value: _settings?.notifications.mentions ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updateNotificationSettings({'mentions': value});
                    _loadSettings();
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.person_add_outlined),
                  title: const Text('Follows'),
                  value: _settings?.notifications.follows ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updateNotificationSettings({'follows': value});
                    _loadSettings();
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.message_outlined),
                  title: const Text('Messages'),
                  value: _settings?.notifications.messages ?? true,
                  onChanged: (value) async {
                    final service = ref.read(settingsServiceProvider);
                    await service.updateNotificationSettings({'messages': value});
                    _loadSettings();
                  },
                ),
                const Divider(),

                // Appearance Section
                _SectionHeader(title: 'Appearance'),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeLabel(themeState.mode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(),
                ),
                const Divider(),

                // Feed Section
                _SectionHeader(title: 'Feed'),
                ListTile(
                  leading: const Icon(Icons.sort),
                  title: const Text('Feed Mode'),
                  subtitle: Text(_settings?.feed.mode ?? 'algorithmic'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSelectionDialog(
                    'Feed Mode',
                    _settings?.feed.mode ?? 'algorithmic',
                    ['algorithmic', 'chronological'],
                    (value) async {
                      final service = ref.read(settingsServiceProvider);
                      await service.updateFeedSettings({'mode': value});
                      _loadSettings();
                    },
                  ),
                ),
                const Divider(),

                // Security Section
                _SectionHeader(title: 'Security'),
                if (_settings?.security.sessions.isNotEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Active Sessions',
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary)),
                  ),
                  ..._settings!.security.sessions.map((session) => ListTile(
                    leading: Icon(
                      session.isCurrent ? Icons.phone_android : Icons.devices,
                      color: session.isCurrent ? theme.colorScheme.primary : null,
                    ),
                    title: Text(session.device ?? 'Unknown Device'),
                    subtitle: Text(session.isCurrent ? 'Current session' : session.ip ?? ''),
                    trailing: session.isCurrent
                        ? null
                        : TextButton(
                            onPressed: () async {
                              final service = ref.read(settingsServiceProvider);
                              await service.logoutSession(session.sessionId);
                              _loadSettings();
                            },
                            child: const Text('Logout'),
                          ),
                  )),
                ],
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout All Sessions',
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Logout All Sessions'),
                        content: const Text('This will log out all devices. Continue?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Logout All')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      final service = ref.read(settingsServiceProvider);
                      await service.logoutAllSessions();
                      _loadSettings();
                    }
                  },
                ),
                const Divider(),

                // Blocked Users
                if (_settings?.privacy.blockedUsers.isNotEmpty == true) ...[
                  _SectionHeader(title: 'Blocked Users'),
                  ..._settings!.privacy.blockedUsers.map((blocked) => ListTile(
                    leading: CircleAvatar(
                      child: Text(blocked.fullName.isNotEmpty
                          ? blocked.fullName[0].toUpperCase()
                          : '?'),
                    ),
                    title: Text(blocked.fullName),
                    subtitle: Text('@${blocked.username}'),
                  )),
                  const Divider(),
                ],

                // Activities
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Activity History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/activities'),
                ),

                // Follow Requests
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Follow Requests'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/follow-requests'),
                ),

                const SizedBox(height: 32),

                // Danger zone
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(currentUserProvider.notifier).clearUser();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Logout', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  String _getThemeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog() {
    final currentMode = ref.read(themeProvider).mode;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: AppThemeMode.values.map((mode) => RadioListTile<AppThemeMode>(
          title: Text(_getThemeLabel(mode)),
          value: mode,
          groupValue: currentMode,
          onChanged: (value) {
            if (value != null) {
              ref.read(themeProvider.notifier).setTheme(value);
              Navigator.pop(ctx);
            }
          },
        )).toList(),
      ),
    );
  }

  void _showSelectionDialog(
    String title,
    String currentValue,
    List<String> options,
    Future<void> Function(String) onSelect,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(title),
        children: options.map((option) => RadioListTile<String>(
          title: Text(option[0].toUpperCase() + option.substring(1)),
          value: option,
          groupValue: currentValue,
          onChanged: (value) {
            if (value != null) {
              Navigator.pop(ctx);
              onSelect(value);
            }
          },
        )).toList(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold)),
    );
  }
}
