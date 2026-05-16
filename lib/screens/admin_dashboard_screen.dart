import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import '../data/models/bill.dart';
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
    final bills = context.watch<AppRepository>().bills;

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
          _buildContributionsCard(context, colorScheme, bills),
          const SizedBox(height: 16),

          // Trend Alert
          if (submeters.isNotEmpty) _buildTrendAlert(colorScheme),
          if (submeters.isNotEmpty) const SizedBox(height: 24),

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
                  icon: Icons.electric_meter_rounded,
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
                      String message =
                          'No bills available to generate summary.';
                      if (appRepo.readings.isNotEmpty) {
                        message +=
                            ' Need at least two readings per meter to calculate usage.';
                      } else {
                        message += ' Log some readings first.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
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
          const SizedBox(height: 24),

          // Billing Configuration Card
          _buildBillingConfigCard(context, colorScheme),
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

  Widget _buildContributionsCard(
    BuildContext context,
    ColorScheme colorScheme,
    List<Bill> bills,
  ) {
    final totalAmount = bills.fold<double>(0, (sum, bill) => sum + bill.amount);
    final totalPaid = bills
        .where((b) => b.status == 'Paid')
        .fold<double>(0, (sum, bill) => sum + bill.amount);
    final totalUnpaid = bills
        .where((b) => b.status == 'Pending')
        .fold<double>(0, (sum, bill) => sum + bill.amount);
        
    final currencyFormat = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

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
                Icons.account_balance_wallet_rounded,
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
            currencyFormat.format(totalAmount),
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
          const SizedBox(height: 16),
          Row(
            children: [
              _buildContributionStat(
                colorScheme,
                'Paid',
                currencyFormat.format(totalPaid),
                colorScheme.primary,
              ),
              const SizedBox(width: 32),
              _buildContributionStat(
                colorScheme,
                'Unpaid',
                currencyFormat.format(totalUnpaid),
                colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContributionStat(
    ColorScheme colorScheme,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
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

  Widget _buildBillingConfigCard(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final appRepo = context.watch<AppRepository>();
    final currencyFormat = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.settings_suggest_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'BILLING CONFIGURATION',
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
              TextButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/billing_config'),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _billingStat(
                  colorScheme,
                  appRepo.useProRata ? 'Monthly Bill' : 'Rate Method',
                  appRepo.useProRata
                      ? currencyFormat.format(appRepo.totalBill)
                      : 'Constant Rate',
                ),
              ),
              Expanded(
                child: _billingStat(
                  colorScheme,
                  'Active Rate',
                  '₱${appRepo.currentRate.toStringAsFixed(2)}/kWh',
                  isHighlight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          Text(
            'BILLING METHOD DETAILS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appRepo.useProRata
                ? 'Based on pro-rata distribution of the total master bill among all active submeters.'
                : 'Flat rate applied consistently to all submeter consumption.',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _billingStat(
    ColorScheme colorScheme,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
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
