import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Ledger History screen — paginated history of readings and bills.
/// Matches Stitch "Ledger History" screen.
class LedgerHistoryScreen extends StatelessWidget {
  const LedgerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ledger History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                  letterSpacing: -0.24, color: KurieColors.onSurface)),
          const SizedBox(height: 4),
          Text('Past readings and finalized billing cycles.',
              style: TextStyle(fontSize: 14, color: KurieColors.onSurfaceVariant)),
          const SizedBox(height: 12),
          // Alert banner
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFF8EB), borderRadius: BorderRadius.circular(4),
              border: Border.all(color: KurieColors.tertiaryContainer.withAlpha(120)),
            ),
            child: Row(children: [
              Icon(Icons.warning_amber_rounded, size: 18, color: KurieColors.tertiary),
              const SizedBox(width: 8),
              Expanded(child: Text('High consumption alert flagged on Sep 15.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: KurieColors.tertiary))),
            ]),
          ),
          const SizedBox(height: 20),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _filterChip('All', true),
              const SizedBox(width: 8),
              _filterChip('Readings', false),
              const SizedBox(width: 8),
              _filterChip('Bills', false),
              const SizedBox(width: 8),
              _filterChip('Alerts', false),
            ]),
          ),
          const SizedBox(height: 20),
          // Month header
          Text('OCTOBER 2026', style: TextStyle(fontSize: 12,
              fontWeight: FontWeight.w700, letterSpacing: 1.0,
              color: KurieColors.outline)),
          const SizedBox(height: 12),
          _ledgerEntry(
            icon: Icons.receipt_long_rounded,
            iconColor: KurieColors.primary,
            title: 'Bill Finalized',
            subtitle: 'Cycle: Sep 1 – Sep 30',
            amount: '\u20B11,250.00',
            date: 'Oct 1',
            isFinalized: true,
          ),
          _ledgerEntry(
            icon: Icons.electric_meter_rounded,
            iconColor: KurieColors.onSurfaceVariant,
            title: 'Meter Reading',
            subtitle: 'Basement Apartment — 12,582 kWh',
            amount: null,
            date: 'Sep 30',
          ),
          const SizedBox(height: 16),
          Text('SEPTEMBER 2026', style: TextStyle(fontSize: 12,
              fontWeight: FontWeight.w700, letterSpacing: 1.0,
              color: KurieColors.outline)),
          const SizedBox(height: 12),
          _ledgerEntry(
            icon: Icons.warning_amber_rounded,
            iconColor: KurieColors.tertiary,
            title: 'High Consumption Alert',
            subtitle: 'Usage spiked +22% week over week',
            amount: null,
            date: 'Sep 15',
            isAlert: true,
          ),
          _ledgerEntry(
            icon: Icons.electric_meter_rounded,
            iconColor: KurieColors.onSurfaceVariant,
            title: 'Meter Reading',
            subtitle: 'Guest Suite — 8,901 kWh',
            amount: null,
            date: 'Sep 14',
          ),
          _ledgerEntry(
            icon: Icons.receipt_long_rounded,
            iconColor: KurieColors.primary,
            title: 'Bill Finalized',
            subtitle: 'Cycle: Aug 1 – Aug 31',
            amount: '\u20B11,080.00',
            date: 'Sep 1',
            isFinalized: true,
          ),
          _ledgerEntry(
            icon: Icons.electric_meter_rounded,
            iconColor: KurieColors.onSurfaceVariant,
            title: 'Meter Reading',
            subtitle: 'Detached Garage — 4,170 kWh',
            amount: null,
            date: 'Aug 31',
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? KurieColors.primary : KurieColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? KurieColors.primary : KurieColors.outlineVariant),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: selected ? KurieColors.onPrimary : KurieColors.onSurfaceVariant)),
    );
  }

  Widget _ledgerEntry({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? amount,
    required String date,
    bool isFinalized = false,
    bool isAlert = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert ? Color(0xFFFFF8EB) : KurieColors.surfaceContainerLowest,
        border: Border.all(color: isAlert
            ? KurieColors.tertiaryContainer.withAlpha(120)
            : KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                color: isAlert ? KurieColors.tertiary : KurieColors.onSurface)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12,
                color: KurieColors.onSurfaceVariant)),
          ],
        )),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (amount != null) Text(amount, style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w700, color: KurieColors.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()])),
          Text(date, style: TextStyle(fontSize: 11, color: KurieColors.outline)),
        ]),
      ]),
    );
  }
}
