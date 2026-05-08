import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';
import 'admin_dashboard_screen.dart';
import 'ledger_history_screen.dart';
import 'settings_profile_screen.dart';

/// Home shell — bottom navigation for Dashboard, Readings, Billing, Insights.
/// Matches the bottom nav from Stitch designs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    AdminDashboardScreen(),
    _ReadingsPlaceholder(),
    LedgerHistoryScreen(),
    SettingsProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: KurieColors.surfaceContainerLowest,
          border: Border(
            top: BorderSide(color: KurieColors.outlineVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo_outlined),
              label: 'Readings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for Readings tab — directs to log meter reading.
class _ReadingsPlaceholder extends StatelessWidget {
  const _ReadingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_rounded, size: 64,
                color: KurieColors.outlineVariant),
            const SizedBox(height: 16),
            Text('Meter Readings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                    color: KurieColors.onSurface)),
            const SizedBox(height: 8),
            Text('Capture and manage submeter readings here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/log_reading'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Log New Reading'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
