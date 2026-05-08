import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme/kurie_colors.dart';
import '../data/models/submeter.dart';
import '../data/repositories/app_repository.dart';

/// Ledger History screen — paginated history of readings and bills.
/// Matches Stitch "Ledger History" screen.
class LedgerHistoryScreen extends StatefulWidget {
  const LedgerHistoryScreen({super.key});

  @override
  State<LedgerHistoryScreen> createState() => _LedgerHistoryScreenState();
}

class _LedgerHistoryScreenState extends State<LedgerHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final readings = context.watch<AppRepository>().readings;
    final submeters = context.watch<AppRepository>().submeters;

    // Filter logic
    final filteredReadings = readings.where((r) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Readings') return true; // Currently we only have readings anyway
      return false;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ledger History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.24,
              color: KurieColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Past readings and finalized billing cycles.',
            style: TextStyle(fontSize: 14, color: KurieColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('Readings'),
                const SizedBox(width: 8),
                _filterChip('Bills'),
                const SizedBox(width: 8),
                _filterChip('Alerts'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (filteredReadings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: KurieColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: KurieColors.outlineVariant),
              ),
              child: const Center(
                child: Text(
                  'No entries found for this filter.',
                  style: TextStyle(
                    color: KurieColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...filteredReadings.reversed.map((reading) {
              // Safe submeter lookup
              final meter = submeters.cast<Submeter?>().firstWhere(
                (s) => s?.id == reading.submeterId,
                orElse: () => null,
              );

              return _ledgerEntry(
                icon: Icons.electric_meter_rounded,
                iconColor: KurieColors.onSurfaceVariant,
                title: 'Meter Reading',
                subtitle: '${meter?.name ?? 'Unknown Meter'} — ${reading.value} kWh',
                amount: null,
                date: '${reading.timestamp.day}/${reading.timestamp.month}',
              );
            }),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? KurieColors.primary
              : KurieColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? KurieColors.primary : KurieColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? KurieColors.onPrimary
                : KurieColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _ledgerEntry({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? amount,
    required String date,
    bool isAlert = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert ? Color(0xFFFFF8EB) : KurieColors.surfaceContainerLowest,
        border: Border.all(
          color: isAlert
              ? KurieColors.tertiaryContainer.withAlpha(120)
              : KurieColors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isAlert
                        ? KurieColors.tertiary
                        : KurieColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: KurieColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (amount != null)
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KurieColors.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              Text(
                date,
                style: TextStyle(fontSize: 11, color: KurieColors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
