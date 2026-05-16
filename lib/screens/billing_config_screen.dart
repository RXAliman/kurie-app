import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/app_repository.dart';

/// Billing Configuration screen — Admin only.
class BillingConfigScreen extends StatefulWidget {
  const BillingConfigScreen({super.key});

  @override
  State<BillingConfigScreen> createState() => _BillingConfigScreenState();
}

class _BillingConfigScreenState extends State<BillingConfigScreen> {
  late TextEditingController _totalBillController;
  late TextEditingController _masterUsageController;
  late TextEditingController _baseFeeController;
  late TextEditingController _flatRateController;
  late bool _splitBaseFeeEqually;
  late bool _useProRata;

  @override
  void initState() {
    super.initState();
    final appRepo = context.read<AppRepository>();
    _totalBillController = TextEditingController(text: appRepo.totalBill.toString());
    _masterUsageController = TextEditingController(text: appRepo.masterUsage.toString());
    _baseFeeController = TextEditingController(text: appRepo.baseFee.toString());
    _flatRateController = TextEditingController(text: appRepo.flatRate.toString());
    _splitBaseFeeEqually = appRepo.splitBaseFeeEqually;
    _useProRata = appRepo.useProRata;
  }

  @override
  void dispose() {
    _totalBillController.dispose();
    _masterUsageController.dispose();
    _baseFeeController.dispose();
    _flatRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRepo = context.watch<AppRepository>();
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
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
          // Computation Method Selector
          _sectionTitle(colorScheme, 'COMPUTATION METHOD'),
          const SizedBox(height: 12),
          _configGroup(colorScheme, children: [
            _methodOption(colorScheme, 'Simple Pro-Rata', 'Rate derived from total monthly bill', true),
            const Divider(height: 24, thickness: 0.5),
            _methodOption(colorScheme, 'Constant Rate', 'Use a fixed rate per kWh', false),
          ]),
          const SizedBox(height: 24),

          if (_useProRata) ...[
            // Pro-Rata Module
            _sectionTitle(colorScheme, 'SIMPLE PRO-RATA MODULE'),
            const SizedBox(height: 12),
            _configGroup(colorScheme, children: [
              _labeledField(colorScheme, 'Total Bill (₱)', _totalBillController),
              const SizedBox(height: 12),
              _labeledField(colorScheme, 'Master Meter Usage (kWh)', _masterUsageController),
              const SizedBox(height: 12),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(children: [
                  Icon(Icons.calculate_outlined, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Calculated Rate: ₱${appRepo.currentRate.toStringAsFixed(2)}/kWh',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                          color: colorScheme.primary)),
                ]),
              ),
            ]),
            const SizedBox(height: 24),

            // Base Fee Splitter
            _sectionTitle(colorScheme, 'BASE FEE SPLITTER'),
            const SizedBox(height: 12),
            _configGroup(colorScheme, children: [
              _labeledField(colorScheme, 'Monthly Base Fee (₱)', _baseFeeController),
              const SizedBox(height: 16),
              Text('SPLIT METHOD', style: TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 1.0,
                  color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              _splitOption(colorScheme, 'Split equally among all users', true),
              const SizedBox(height: 8),
              _splitOption(colorScheme, 'Assign to master owner only', false),
            ]),
          ] else ...[
            // Constant Rate Module
            _sectionTitle(colorScheme, 'CONSTANT RATE'),
            const SizedBox(height: 12),
            _configGroup(colorScheme, children: [
              _labeledField(colorScheme, 'Rate per kWh (₱)', _flatRateController),
              const SizedBox(height: 12),
              Text(
                'This rate will be applied to all submeter usage regardless of the total monthly bill.',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
            ]),
          ],
          const SizedBox(height: 32),

          // Save
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                
                await context.read<AppRepository>().updateBillingConfig(
                  totalBill: double.tryParse(_totalBillController.text),
                  masterUsage: double.tryParse(_masterUsageController.text),
                  baseFee: double.tryParse(_baseFeeController.text),
                  flatRate: double.tryParse(_flatRateController.text),
                  splitBaseFeeEqually: _splitBaseFeeEqually,
                  useProRata: _useProRata,
                );

                messenger.showSnackBar(
                  SnackBar(content: const Text('Configuration saved'),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating),
                );
                navigator.pop();
              },
              child: const Text('Save Configuration'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(ColorScheme colorScheme, String title) {
    return Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
        letterSpacing: 1.0, color: colorScheme.onSurfaceVariant));
  }

  Widget _configGroup(ColorScheme colorScheme, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _labeledField(ColorScheme colorScheme, String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
      ),
    ]);
  }

  Widget _methodOption(ColorScheme colorScheme, String title, String subtitle, bool value) {
    final isSelected = _useProRata == value;
    return InkWell(
      onTap: () => setState(() => _useProRata = value),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, 
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          // ignore: deprecated_member_use
          Radio<bool>(
            value: value,
            // ignore: deprecated_member_use
            groupValue: _useProRata,
            // ignore: deprecated_member_use
            onChanged: (val) {
              if (val != null) setState(() => _useProRata = val);
            },
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _splitOption(ColorScheme colorScheme, String label, bool value) {
    return InkWell(
      onTap: () => setState(() => _splitBaseFeeEqually = value),
      borderRadius: BorderRadius.circular(4),
      child: Row(children: [
        SizedBox(
          width: 24, height: 24,
          // ignore: deprecated_member_use
          child: Radio<bool>(
            value: value,
            // ignore: deprecated_member_use
            groupValue: _splitBaseFeeEqually,
            // ignore: deprecated_member_use
            onChanged: (val) {
              if (val != null) setState(() => _splitBaseFeeEqually = val);
            },
            activeColor: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, color: colorScheme.onSurface)),
      ]),
    );
  }
}
