import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Log Meter Reading screen — Admin only.
/// Matches Stitch "Log Meter Reading" screen.
class LogMeterReadingScreen extends StatefulWidget {
  const LogMeterReadingScreen({super.key});

  @override
  State<LogMeterReadingScreen> createState() => _LogMeterReadingScreenState();
}

class _LogMeterReadingScreenState extends State<LogMeterReadingScreen> {
  final _readingController = TextEditingController();
  String? _selectedSubmeter;
  final _lastReading = 12450;

  @override
  void dispose() {
    _readingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      appBar: AppBar(
        title: const Text('Log Meter Reading'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the current value from the analog or digital display.',
                style: TextStyle(fontSize: 16, height: 24 / 16,
                    color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            // Info banner
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KurieColors.primaryFixed.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 18, color: KurieColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Reading must be greater than or equal to $_lastReading.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: KurieColors.primary),
                )),
              ]),
            ),
            const SizedBox(height: 24),

            // Select submeter
            Text('SUBMETER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                letterSpacing: 1.0, color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: KurieColors.surfaceContainerLowest,
                border: Border.all(color: KurieColors.outlineVariant),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubmeter,
                  hint: Text('Select submeter', style: TextStyle(color: KurieColors.outline)),
                  isExpanded: true,
                  items: ['Basement Apartment', 'Detached Garage', 'Guest Suite']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSubmeter = v),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Current Reading
            Text('CURRENT READING (kWh)', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, letterSpacing: 1.0,
                color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            TextField(
              controller: _readingController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                  color: KurieColors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()]),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                    color: KurieColors.outlineVariant),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
            ),
            const SizedBox(height: 24),

            // Photo attachment zone
            Text('PHOTO EVIDENCE (OPTIONAL)', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, letterSpacing: 1.0,
                color: KurieColors.onSurfaceVariant)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: double.infinity, height: 120,
                decoration: BoxDecoration(
                  color: KurieColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: KurieColors.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_a_photo_outlined, size: 32, color: KurieColors.outline),
                  const SizedBox(height: 8),
                  Text('Tap to capture meter photo',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                          color: KurieColors.outline)),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            // Submit
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reading logged successfully'),
                        backgroundColor: KurieColors.primary),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Submit Reading'),
              ),
            ),
            const SizedBox(height: 12),
            // Timestamp
            Center(
              child: Text(
                'Timestamp will be captured automatically.',
                style: TextStyle(fontSize: 12, color: KurieColors.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
