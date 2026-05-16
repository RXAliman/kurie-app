import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kurie/data/repositories/app_repository.dart';
import 'package:kurie/data/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../app/theme/kurie_colors.dart';

/// Settings & Profile screen — matches Stitch "Settings & Profile" design.
/// Features profile header, property details, notification toggles, and sync controls.
class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  bool _billingAlerts = true;
  bool _readingReminders = true;
  String _selectedTheme = 'Light';

  final User? _user = FirebaseAuth.instance.currentUser;
  String _appVersion = '0.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
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
            style: TextButton.styleFrom(foregroundColor: KurieColors.error),
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
    return Scaffold(
      backgroundColor: KurieColors.surface,
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
                          color: KurieColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: KurieColors.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: KurieColors.outline,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: KurieColors.primary,
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
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: KurieColors.onSurface,
                    ),
                  ),
                  Text(
                    _user?.email ?? 'No email',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: KurieColors.onSurfaceVariant,
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
                  'Billing Alerts',
                  _billingAlerts,
                  (v) => setState(() => _billingAlerts = v),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _toggleRow(
                  'Reading Reminders',
                  _readingReminders,
                  (v) => setState(() => _readingReminders = v),
                ),
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
                    const Icon(
                      Icons.dark_mode_outlined,
                      size: 20,
                      color: KurieColors.primary,
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
                      onChanged: (v) => setState(() => _selectedTheme = v!),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Data & Sync
            _sectionTitle('DATA & SYNC'),
            const SizedBox(height: 8),
            _configGroup(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 20,
                      color: KurieColors.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last synced: 2 mins ago',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Local cache: 1.2 MB',
                            style: TextStyle(
                              fontSize: 12,
                              color: KurieColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text('Sync', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.read<AppRepository>().clearAllData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Database cleared successfully'),
                        ),
                      );
                    },
                    child: const Text(
                      'Clear Local Cache',
                      style: TextStyle(color: KurieColors.error),
                    ),
                  ),
                ),
              ],
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
                  KurieColors.onSurface,
                  _onSignOut,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _actionRow(
                  'Delete Account',
                  Icons.delete_forever_rounded,
                  KurieColors.error,
                  _onDeleteAccount,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Version
            Center(
              child: Text(
                'Kurie v$_appVersion',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: KurieColors.outline,
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
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: KurieColors.onSurfaceVariant,
      ),
    );
  }

  Widget _configGroup({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerHigh,
        border: Border.all(color: KurieColors.outlineVariant),
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
          activeTrackColor: KurieColors.primary.withAlpha(150),
          activeThumbColor: KurieColors.primary,
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
