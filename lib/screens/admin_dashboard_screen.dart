import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/app_repository.dart';
import '../data/services/pdf_service.dart';
import 'package:printing/printing.dart';

/// Admin Dashboard — matches Stitch "Admin Dashboard" screen.
/// Shows total sub-user contributions, trend alerts, and active submeters.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final submeters = context.watch<AppRepository>().submeters;
    final readings = context.watch<AppRepository>().readings;

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
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _syncDot(colorScheme),
                      const SizedBox(width: 6),
                      Text(
                        'Synced • just now',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/notifications'),
                icon: const Icon(Icons.notifications_outlined),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Sub-user Contributions card
          _buildContributionsCard(context, colorScheme),
          const SizedBox(height: 16),

          // Trend Alert
          if (submeters.isNotEmpty) _buildTrendAlert(colorScheme),
          if (submeters.isNotEmpty) const SizedBox(height: 24),

          // Active Submeters section
          Row(
            children: [
              Icon(
                Icons.device_hub_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Active Submeters',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...submeters.map((meter) {
            final meterReadings =
                readings.where((r) => r.submeterId == meter.id).toList()
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

            double usage = 0;
            double amount = 0;
            if (meterReadings.length >= 2) {
              usage = meterReadings[0].value - meterReadings[1].value;
              // Assuming a default rate of 12.0 per kWh if not configured
              amount = usage * 12.0;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSubmeterCard(
                colorScheme: colorScheme,
                name: meter.name,
                currentReading: '${meter.lastReading} kWh',
                usage: '${usage.toStringAsFixed(1)} kWh',
                amount: '₱${amount.toStringAsFixed(2)}',
                trend: '0%',
                trendUp: false,
              ),
            );
          }),

          if (submeters.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Center(
                child: Text(
                  'No submeters added yet.',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  colorScheme: colorScheme,
                  icon: Icons.add_a_photo_rounded,
                  label: 'Log Reading',
                  onTap: () => Navigator.of(context).pushNamed('/log_reading'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionCard(
                  colorScheme: colorScheme,
                  icon: Icons.home_work_rounded,
                  label: 'Property',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/property_mgmt'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionCard(
                  colorScheme: colorScheme,
                  icon: Icons.summarize_rounded,
                  label: 'Generate Summary',
                  onTap: () async {
                    final appRepo = context.read<AppRepository>();
                    if (appRepo.bills.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'No bills available to generate summary. Log some readings first.',
                          ),
                          backgroundColor: colorScheme.tertiary,
                        ),
                      );
                      return;
                    }

                    final pdfData = await PdfService.generateCuttableSlips(
                      appRepo.bills,
                      appRepo.submeters,
                    );
                    await Printing.layoutPdf(
                      onLayout: (format) => pdfData,
                      name: 'Kurie_Monthly_Summary.pdf',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _syncDot(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withAlpha((value * 255).toInt()),
          ),
        );
      },
    );
  }

  Widget _buildContributionsCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: colorScheme.outlineVariant),
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
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'TOTAL SUB-USER CONTRIBUTIONS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₱0.00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 40,
              fontWeight: FontWeight.w600,
              height: 48 / 40,
              letterSpacing: -0.8,
              color: colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your remaining master balance: ₱0.00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAlert(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 20,
            color: colorScheme.tertiary,
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
                    color: colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-time trends will appear here as you log more readings over time.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: colorScheme.onSurfaceVariant,
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
    required ColorScheme colorScheme,
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
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: colorScheme.outlineVariant),
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
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: trendUp
                      ? colorScheme.tertiaryContainer.withAlpha(80)
                      : colorScheme.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: trendUp
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: trendUp
                            ? colorScheme.tertiary
                            : colorScheme.primary,
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
              _submeterStat(colorScheme, 'Reading', currentReading),
              const SizedBox(width: 24),
              _submeterStat(colorScheme, 'Usage', usage),
              const Spacer(),
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _submeterStat(ColorScheme colorScheme, String label, String value) {
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
            color: colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required ColorScheme colorScheme,
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
          color: colorScheme.surfaceContainerLowest,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
