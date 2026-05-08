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
    LedgerHistoryScreen(),
    SettingsProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _screens),
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
