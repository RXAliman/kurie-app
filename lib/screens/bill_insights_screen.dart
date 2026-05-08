import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Bill & Insights screen — Tenant view of their current bill.
class BillInsightsScreen extends StatelessWidget {
  const BillInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Bill & Insights',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                  letterSpacing: -0.24, color: KurieColors.onSurface)),
          const SizedBox(height: 24),
          _bottomLineCard(),
          const SizedBox(height: 16),
          _transparencyCard(),
          const SizedBox(height: 16),
          _trendAlert(),
          const SizedBox(height: 16),
          _evidenceCard(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.help_outline_rounded, color: KurieColors.error, size: 20),
              label: Text('Query Calculation',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: KurieColors.error)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: KurieColors.error.withAlpha(80)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomLineCard() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.receipt_long_rounded, size: 18, color: KurieColors.primary),
          const SizedBox(width: 8),
          Text('THE BOTTOM LINE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
              letterSpacing: 1.0, color: KurieColors.onSurfaceVariant)),
        ]),
        const SizedBox(height: 4),
        Text('Your current bill for this period.',
            style: TextStyle(fontSize: 14, color: KurieColors.outline)),
        const SizedBox(height: 16),
        Text('\u20B11,250.00', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700,
            height: 56 / 48, letterSpacing: -0.96, color: KurieColors.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()])),
        const SizedBox(height: 8),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: KurieColors.primaryFixed.withAlpha(60),
                borderRadius: BorderRadius.circular(4)),
            child: Text('ACTIVE CYCLE', style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.w700, letterSpacing: 0.8, color: KurieColors.primary)),
          ),
          const SizedBox(width: 8),
          Text('125 kWh used', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
              color: KurieColors.onSurfaceVariant)),
        ]),
      ]),
    );
  }

  Widget _transparencyCard() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TRANSPARENCY BREAKDOWN', style: TextStyle(fontSize: 12,
            fontWeight: FontWeight.w700, letterSpacing: 1.0, color: KurieColors.onSurfaceVariant)),
        const SizedBox(height: 16),
        _row('You used 125 kWh of electricity this month.', Icons.electric_bolt_rounded),
        const SizedBox(height: 12),
        _row('The current rate agreed upon is \u20B110.00 per kWh.', Icons.payments_outlined),
        const SizedBox(height: 12),
        Divider(color: KurieColors.outlineVariant),
        const SizedBox(height: 12),
        _row('Your bill includes a \u20B1150 split base fee, plus 50 kWh at \u20B111.50/kWh.',
            Icons.calculate_outlined),
      ]),
    );
  }

  Widget _row(String text, IconData icon) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: KurieColors.primary),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: TextStyle(fontSize: 16, height: 24 / 16,
          color: KurieColors.onSurface))),
    ]);
  }

  Widget _trendAlert() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8EB), borderRadius: BorderRadius.circular(4),
        border: Border.all(color: KurieColors.tertiaryContainer.withAlpha(120)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.trending_up_rounded, size: 20, color: KurieColors.tertiary),
        const SizedBox(width: 12),
        Expanded(child: Text(
          'Your usage is 10% higher than last month. Expect a slightly higher bill if this trend continues.',
          style: TextStyle(fontSize: 14, height: 20 / 14, color: KurieColors.tertiary),
        )),
      ]),
    );
  }

  Widget _evidenceCard() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('METER READING EVIDENCE', style: TextStyle(fontSize: 12,
            fontWeight: FontWeight.w700, letterSpacing: 1.0, color: KurieColors.onSurfaceVariant)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity, height: 160,
          decoration: BoxDecoration(
            color: KurieColors.surfaceContainer, borderRadius: BorderRadius.circular(4),
            border: Border.all(color: KurieColors.outlineVariant),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.photo_camera_rounded, size: 32, color: KurieColors.outline),
            const SizedBox(height: 8),
            Text('Photo evidence attached by admin',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: KurieColors.outline)),
            const SizedBox(height: 4),
            Text('Logged: May 1, 2026 at 9:15 AM',
                style: TextStyle(fontSize: 12, color: KurieColors.outline)),
          ]),
        ),
      ]),
    );
  }
}
