import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/reading.dart';
import '../data/repositories/app_repository.dart';

/// Log Meter Reading screen — Admin only.
/// Matches Stitch "Log Meter Reading" screen.
class LogMeterReadingScreen extends StatefulWidget {
  const LogMeterReadingScreen({super.key});

  @override
  State<LogMeterReadingScreen> createState() => _LogMeterReadingScreenState();
}

class _LogMeterReadingScreenState extends State<LogMeterReadingScreen> {
  final _readingController = TextEditingController();
  String? _selectedSubmeterId;

  @override
  void dispose() {
    _readingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final submeters = context.watch<AppRepository>().submeters;
    final selectedSubmeter = _selectedSubmeterId != null 
        ? submeters.firstWhere((s) => s.id == _selectedSubmeterId)
        : null;
    final lastReading = selectedSubmeter?.lastReading ?? '0';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
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
                    color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            // Info banner
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Last reading: $lastReading kWh.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: colorScheme.primary),
                )),
              ]),
            ),
            const SizedBox(height: 24),


            // Select submeter
            Text('SUBMETER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                letterSpacing: 1.0, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: colorScheme.surfaceContainerLowest,
                  value: _selectedSubmeterId,
                  hint: Text('Select submeter', style: TextStyle(color: colorScheme.outline)),
                  isExpanded: true,
                  items: submeters
                      .map((s) => DropdownMenuItem(value: s.id, child: Text(s.unit, style: TextStyle(color: colorScheme.onSurface))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSubmeterId = v),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Current Reading
            Text('CURRENT READING (kWh)', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, letterSpacing: 1.0,
                color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            TextField(
              controller: _readingController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()]),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,
                    color: colorScheme.outlineVariant),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
            ),
            const SizedBox(height: 24),

            // Photo attachment zone
            Text('PHOTO EVIDENCE (OPTIONAL)', style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, letterSpacing: 1.0,
                color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: double.infinity, height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_a_photo_outlined, size: 32, color: colorScheme.outline),
                  const SizedBox(height: 8),
                  Text('Tap to capture meter photo',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                          color: colorScheme.outline)),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            // Submit
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final newValue = double.tryParse(_readingController.text) ?? 0.0;
                  final lastReadingValue = double.tryParse(selectedSubmeter?.lastReading ?? '0') ?? 0.0;

                  if (_selectedSubmeterId == null || _readingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a submeter and enter a reading')),
                    );
                    return;
                  }

                  if (newValue <= lastReadingValue) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('New reading must be greater than the last reading ($lastReadingValue kWh)'),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                    return;
                  }

                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final appRepo = context.read<AppRepository>();

                  final newReading = Reading(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    submeterId: _selectedSubmeterId!,
                    timestamp: DateTime.now(),
                    value: newValue,
                  );

                  await appRepo.addReading(newReading);

                  if (!mounted) return;

                  messenger.showSnackBar(
                    const SnackBar(content: Text('Reading logged successfully')),
                  );
                  navigator.pop();
                },
                child: const Text('Submit Reading'),
              ),
            ),
            const SizedBox(height: 12),
            // Timestamp
            Center(
              child: Text(
                'Timestamp will be captured automatically.',
                style: TextStyle(fontSize: 12, color: colorScheme.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
