import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Onboarding screen — carousel of 4 feature highlights.
/// Matches Stitch designs: Offline-First, Transparency, Evidence, Alerts.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.wifi_off_rounded,
      accentIcon: Icons.cloud_done_outlined,
      title: 'Offline-first\nTracking',
      subtitle:
          'Log readings without an internet connection. Data syncs automatically when connection restores.',
    ),
    _OnboardingPage(
      icon: Icons.receipt_long_rounded,
      accentIcon: Icons.visibility_outlined,
      title: 'Transparent\nBilling',
      subtitle:
          'See exactly how every peso of your electricity bill is calculated. No hidden fees, ever.',
    ),
    _OnboardingPage(
      icon: Icons.notifications_active_rounded,
      accentIcon: Icons.bolt_outlined,
      title: 'Real-time\nAlerts',
      subtitle: 'Get reminded when it\'s time to take a new reading.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _onSkip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00DAF3), Color(0xFF006875)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 20),
                  child: TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: KurieColors.surface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _buildPage(page);
                  },
                ),
              ),

              // Dots
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: KurieColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPage < _pages.length - 1
                          ? KurieColors.surface
                          : KurieColors.amber,
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: TextStyle(
                        color: _currentPage < _pages.length - 1
                            ? KurieColors.primary
                            : KurieColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background gradient circle
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KurieColors.surfaceContainerLowest,
                  ),
                ),
                // Main icon
                Icon(page.icon, size: 80, color: KurieColors.primary),
                // Floating accent icon
                Positioned(
                  right: 60,
                  top: 50,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KurieColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      page.accentIcon,
                      size: 24,
                      color: KurieColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
              letterSpacing: -0.32,
              color: KurieColors.surface,
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: KurieColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final IconData accentIcon;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.accentIcon,
    required this.title,
    required this.subtitle,
  });
}
