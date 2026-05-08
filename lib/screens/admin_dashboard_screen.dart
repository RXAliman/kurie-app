import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Admin Dashboard — matches Stitch "Admin Dashboard" screen.
/// Shows total sub-user contributions, trend alerts, and active submeters.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kurie',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.24,
                      color: KurieColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _syncDot(),
                      const SizedBox(width: 6),
                      Text(
                        'Synced • just now',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: KurieColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/notifications'),
                icon: const Icon(Icons.notifications_outlined),
                style: IconButton.styleFrom(
                  backgroundColor: KurieColors.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Sub-user Contributions card
          _buildContributionsCard(context),
          const SizedBox(height: 16),

          // Trend Alert
          _buildTrendAlert(),
          const SizedBox(height: 24),

          // Active Submeters section
          Row(
            children: [
              Icon(Icons.device_hub_rounded, size: 20, color: KurieColors.primary),
              const SizedBox(width: 8),
              Text(
                'Active Submeters',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: KurieColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildSubmeterCard(
            name: 'Basement Apartment',
            currentReading: '12,582',
            usage: '132 kWh',
            amount: '₱1,518.00',
            trend: '+8%',
            trendUp: true,
          ),
          const SizedBox(height: 8),
          _buildSubmeterCard(
            name: 'Detached Garage',
            currentReading: '4,215',
            usage: '45 kWh',
            amount: '₱517.50',
            trend: '-3%',
            trendUp: false,
          ),
          const SizedBox(height: 8),
          _buildSubmeterCard(
            name: 'Guest Suite',
            currentReading: '8,901',
            usage: '78 kWh',
            amount: '₱897.00',
            trend: '+15%',
            trendUp: true,
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: KurieColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.add_a_photo_rounded,
                  label: 'Log Reading',
                  onTap: () => Navigator.of(context).pushNamed('/log_reading'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.home_work_rounded,
                  label: 'Property',
                  onTap: () => Navigator.of(context).pushNamed('/property_mgmt'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.tune_rounded,
                  label: 'Configure',
                  onTap: () => Navigator.of(context).pushNamed('/billing_config'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _syncDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: KurieColors.primaryFixed.withAlpha((value * 255).toInt()),
          ),
        );
      },
    );
  }

  Widget _buildContributionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.electric_meter_rounded,
                size: 18,
                color: KurieColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'TOTAL SUB-USER CONTRIBUTIONS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: KurieColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₱3,400.00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 40,
              fontWeight: FontWeight.w600,
              height: 48 / 40,
              letterSpacing: -0.8,
              color: KurieColors.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your remaining master balance: ₱1,100.00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: KurieColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: KurieColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 20,
            color: KurieColors.tertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trend Alert',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KurieColors.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contributions are up +12% vs last cycle. Expect higher overall returns if usage maintains current trajectory.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: KurieColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmeterCard({
    required String name,
    required String currentReading,
    required String usage,
    required String amount,
    required String trend,
    required bool trendUp,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: KurieColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: trendUp
                      ? KurieColors.tertiaryContainer.withAlpha(80)
                      : KurieColors.primaryFixed.withAlpha(80),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color:
                          trendUp ? KurieColors.tertiary : KurieColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: trendUp
                            ? KurieColors.tertiary
                            : KurieColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _submeterStat('Reading', currentReading),
              const SizedBox(width: 24),
              _submeterStat('Usage', usage),
              const Spacer(),
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: KurieColors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _submeterStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: KurieColors.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KurieColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: KurieColors.surfaceContainerLowest,
          border: Border.all(color: KurieColors.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: KurieColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: KurieColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
