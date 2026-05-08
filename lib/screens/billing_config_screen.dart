import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Billing Configuration screen — Admin only.
/// Combines Base Fee Splitter and Tiered Rate Builder from Stitch designs.
class BillingConfigScreen extends StatefulWidget {
  const BillingConfigScreen({super.key});

  @override
  State<BillingConfigScreen> createState() => _BillingConfigScreenState();
}

class _BillingConfigScreenState extends State<BillingConfigScreen> {
  final _totalBillController = TextEditingController(text: '4500');
  final _masterUsageController = TextEditingController(text: '390');
  bool _splitBaseFeeEqually = true;
  final _baseFeeController = TextEditingController(text: '300');

  final _tiers = <_Tier>[
    _Tier(upTo: '100', rate: '10.00'),
    _Tier(upTo: '200', rate: '12.00'),
    _Tier(upTo: '', rate: '14.50'),
  ];

  @override
  void dispose() {
    _totalBillController.dispose();
    _masterUsageController.dispose();
    _baseFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      appBar: AppBar(
        title: const Text('Billing Configuration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Pro-Rata Module
          _sectionTitle('SIMPLE PRO-RATA MODULE'),
          const SizedBox(height: 12),
          _configGroup(children: [
            _labeledField('Total Bill (\u20B1)', _totalBillController),
            const SizedBox(height: 12),
            _labeledField('Master Meter Usage (kWh)', _masterUsageController),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KurieColors.primaryFixed.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(children: [
                Icon(Icons.calculate_outlined, size: 18, color: KurieColors.primary),
                const SizedBox(width: 8),
                Text('Rate: \u20B111.54/kWh',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                        color: KurieColors.primary)),
              ]),
            ),
          ]),
          const SizedBox(height: 24),

          // Base Fee Splitter
          _sectionTitle('BASE FEE SPLITTER'),
          const SizedBox(height: 12),
          _configGroup(children: [
            _labeledField('Monthly Base Fee (\u20B1)', _baseFeeController),
            const SizedBox(height: 16),
            Text('SPLIT METHOD', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, letterSpacing: 1.0,
                color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            _radioOption('Split equally among all users', true),
            const SizedBox(height: 8),
            _radioOption('Assign to master owner only', false),
          ]),
          const SizedBox(height: 24),

          // Tiered Rate Builder
          _sectionTitle('TIERED RATE BUILDER'),
          const SizedBox(height: 12),
          _configGroup(children: [
            ...List.generate(_tiers.length, (i) {
              final tier = _tiers[i];
              final isLast = i == _tiers.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: KurieColors.surfaceContainerLowest,
                    border: Border.all(color: KurieColors.outlineVariant),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: KurieColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(child: Text('${i + 1}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                              color: KurieColors.primary))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isLast
                            ? 'Above ${_tiers[i - 1].upTo} kWh'
                            : 'Up to ${tier.upTo} kWh',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                color: KurieColors.onSurface)),
                        Text('\u20B1${tier.rate} per kWh',
                            style: TextStyle(fontSize: 12,
                                color: KurieColors.onSurfaceVariant)),
                      ],
                    )),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit_outlined, size: 18,
                          color: KurieColors.outline),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_rounded, size: 18),
                label: Text('Add Tier'),
              ),
            ),
          ]),
          const SizedBox(height: 32),

          // Save
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuration saved'),
                      backgroundColor: KurieColors.primary),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save Configuration'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
        letterSpacing: 1.0, color: KurieColors.onSurfaceVariant));
  }

  Widget _configGroup({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerHigh,
        border: Border.all(color: KurieColors.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _labeledField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: KurieColors.onSurfaceVariant)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    ]);
  }

  Widget _radioOption(String label, bool value) {
    final isSelected = _splitBaseFeeEqually == value;
    return InkWell(
      onTap: () => setState(() => _splitBaseFeeEqually = value),
      borderRadius: BorderRadius.circular(4),
      child: Row(children: [
        Container(
          width: 20, height: 20,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? KurieColors.primary : KurieColors.outline,
              width: 2,
            ),
          ),
          child: isSelected
              ? Center(child: Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KurieColors.primary,
                  ),
                ))
              : null,
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14, color: KurieColors.onSurface)),
      ]),
    );
  }
}

class _Tier {
  final String upTo;
  final String rate;
  _Tier({required this.upTo, required this.rate});
}
