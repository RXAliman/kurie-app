import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/submeter.dart';
import '../data/models/reading.dart';
import '../data/models/bill.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final readings = context.watch<AppRepository>().readings;
    final bills = context.watch<AppRepository>().bills;
    final submeters = context.watch<AppRepository>().submeters;

    final List<dynamic> items = [];
    if (_selectedFilter == 'All' || _selectedFilter == 'Readings') items.addAll(readings);
    if (_selectedFilter == 'All' || _selectedFilter == 'Bills') items.addAll(bills);
    
    // Sort by timestamp descending
    items.sort((a, b) {
      final tA = a is Reading ? a.timestamp : (a as Bill).timestamp;
      final tB = b is Reading ? b.timestamp : (b as Bill).timestamp;
      return tB.compareTo(tA);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ledger History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.24,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Past readings and finalized billing cycles.',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(colorScheme, 'All'),
                const SizedBox(width: 8),
                _filterChip(colorScheme, 'Readings'),
                const SizedBox(width: 8),
                _filterChip(colorScheme, 'Bills'),
                const SizedBox(width: 8),
                _filterChip(colorScheme, 'Alerts'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (items.isEmpty)
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
                  'No entries found for this filter.',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...items.map((item) {
              if (item is Reading) {
                final meter = submeters.cast<Submeter?>().firstWhere(
                  (s) => s?.id == item.submeterId,
                  orElse: () => null,
                );

                return _ledgerEntry(
                  colorScheme: colorScheme,
                  icon: Icons.electric_meter_rounded,
                  iconColor: colorScheme.onSurfaceVariant,
                  title: 'Meter Reading',
                  subtitle: '${meter?.name ?? 'Unknown Meter'} — ${item.value} kWh',
                  amount: null,
                  date: '${item.timestamp.day}/${item.timestamp.month}',
                );
              } else {
                final bill = item as Bill;
                final meter = submeters.cast<Submeter?>().firstWhere(
                  (s) => s?.id == bill.submeterId,
                  orElse: () => null,
                );

                return _ledgerEntry(
                  colorScheme: colorScheme,
                  icon: Icons.receipt_long_rounded,
                  iconColor: colorScheme.primary,
                  title: 'Monthly Bill',
                  subtitle: '${meter?.name ?? 'Unknown'} — ${bill.month}',
                  amount: 'P${bill.amount.toStringAsFixed(2)}',
                  date: '${bill.timestamp.day}/${bill.timestamp.month}',
                  onTap: () => Navigator.of(context).pushNamed('/bill_details', arguments: bill.id),
                );
              }
            }),
        ],
      ),
    );
  }

  Widget _filterChip(ColorScheme colorScheme, String label) {
    final selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _ledgerEntry({
    required ColorScheme colorScheme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? amount,
    required String date,
    bool isAlert = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAlert ? colorScheme.tertiaryContainer.withAlpha(40) : colorScheme.surfaceContainerLowest,
            border: Border.all(
              color: isAlert
                  ? colorScheme.tertiaryContainer.withAlpha(120)
                  : colorScheme.outlineVariant,
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
                        color: isAlert ? colorScheme.tertiary : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
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
                        color: colorScheme.onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11, color: colorScheme.outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
