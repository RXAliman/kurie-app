import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kurie/data/repositories/app_repository.dart';
import 'package:kurie/data/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';


/// Settings & Profile screen — matches Stitch "Settings & Profile" design.
/// Features profile header, property details, notification toggles, and sync controls.
class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  late bool _readingReminders;
  late String _reminderFrequency;
  late int _reminderDay;
  String _selectedTheme = 'Light';

  final User? _user = FirebaseAuth.instance.currentUser;
  String _appVersion = '0.0.0';

  @override
  void initState() {
    super.initState();
    final repo = context.read<AppRepository>();
    _readingReminders = repo.readingRemindersEnabled;
    _reminderFrequency = repo.reminderFrequency;
    _reminderDay = repo.reminderDay;
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final repo = context.read<AppRepository>();
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
        // Sync local state with repository theme
        if (repo.themeMode == ThemeMode.light) _selectedTheme = 'Light';
        if (repo.themeMode == ThemeMode.dark) _selectedTheme = 'Dark';
        if (repo.themeMode == ThemeMode.system) _selectedTheme = 'System';
      });
    }
  }

  Future<void> _onSignOut() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Future<void> _onDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AuthService().deleteAccount();
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: colorScheme.outline,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user?.displayName ?? 'User',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    _user?.email ?? 'No email',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Notifications
            _sectionTitle('NOTIFICATIONS'),
            const SizedBox(height: 8),
            _configGroup(
              children: [
                _toggleRow(
                  'Reading Reminders',
                  _readingReminders,
                  (v) {
                    setState(() => _readingReminders = v);
                    context
                        .read<AppRepository>()
                        .updateReminderSettings(enabled: v);
                  },
                ),
                if (_readingReminders) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  _dropdownRow(
                    'Frequency',
                    _reminderFrequency,
                    ['Monthly', 'Weekly', 'Daily'],
                    (v) {
                      setState(() => _reminderFrequency = v!);
                      context
                          .read<AppRepository>()
                          .updateReminderSettings(frequency: v);
                    },
                  ),
                  if (_reminderFrequency == 'Monthly') ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    _dropdownRow(
                      'Preferred Day',
                      _reminderDay.toString(),
                      List.generate(31, (i) => (i + 1).toString()),
                      (v) {
                        final day = int.parse(v!);
                        setState(() => _reminderDay = day);
                        context
                            .read<AppRepository>()
                            .updateReminderSettings(day: day);
                      },
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Appearance
            _sectionTitle('APPEARANCE'),
            const SizedBox(height: 8),
            _configGroup(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'App Theme',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedTheme,
                      underline: const SizedBox(),
                      items: ['Light', 'Dark', 'System']
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _selectedTheme = v);
                          context.read<AppRepository>().setThemeMode(v);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

             // Data & Sync
            _sectionTitle('DATA & SYNC'),
            const SizedBox(height: 8),
            Consumer<AppRepository>(
              builder: (context, repo, child) {
                final lastSyncedStr = repo.lastSynced != null
                    ? '${DateTime.now().difference(repo.lastSynced!).inMinutes} mins ago'
                    : 'Never';
                
                return _configGroup(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sync_rounded,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last synced: $lastSyncedStr',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Cloud database connected',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: repo.syncStatus == SyncStatus.syncing
                              ? null
                              : () async {
                                  await repo.performManualSync();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Sync complete!'),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                          ),
                          child: repo.syncStatus == SyncStatus.syncing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Sync',
                                  style: TextStyle(fontSize: 12),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          repo.clearAllData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Database cleared successfully'),
                            ),
                          );
                        },
                        child: Text(
                          'Clear Local Cache',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Account Actions
            _sectionTitle('ACCOUNT'),
            const SizedBox(height: 8),
            _configGroup(
              children: [
                _actionRow(
                  'Sign Out',
                  Icons.logout_rounded,
                  colorScheme.onSurface,
                  _onSignOut,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _actionRow(
                  'Delete Account',
                  Icons.delete_forever_rounded,
                  colorScheme.error,
                  _onDeleteAccount,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Version
            Center(
              child: Text(
                'Kurie v$_appVersion',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _configGroup({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Theme.of(context).colorScheme.primary.withAlpha(150),
          activeThumbColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _dropdownRow(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: colorScheme.primary,
          ),
          items: options
              .map(
                (t) => DropdownMenuItem(value: t, child: Text(t)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _actionRow(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: color.withAlpha(150),
            ),
          ],
        ),
      ),
    );
  }
}
