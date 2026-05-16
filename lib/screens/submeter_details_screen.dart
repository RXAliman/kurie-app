import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/submeter.dart';
import '../data/repositories/app_repository.dart';
import 'edit_submeter_screen.dart';

class SubmeterDetailsScreen extends StatefulWidget {
  final String submeterId;

  const SubmeterDetailsScreen({super.key, required this.submeterId});

  @override
  State<SubmeterDetailsScreen> createState() => _SubmeterDetailsScreenState();
}

class _SubmeterDetailsScreenState extends State<SubmeterDetailsScreen> {
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appRepo = context.watch<AppRepository>();
    final meter = appRepo.submeters.cast<Submeter?>().firstWhere(
          (s) => s?.id == widget.submeterId,
          orElse: () => null,
        );

    if (meter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unit Details')),
        body: const Center(child: Text('Submeter not found')),
      );
    }

    final allReadings = appRepo.readings.where((r) => r.submeterId == widget.submeterId).toList();
    allReadings.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final totalPages = (allReadings.length / _pageSize).ceil();
    final paginatedReadings = allReadings.skip(_currentPage * _pageSize).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Manage Unit'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _confirmDelete(context, appRepo, meter),
            color: colorScheme.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          meter.tenantId,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSubmeterScreen(submeterId: meter.id),
                            ),
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer.withAlpha(50),
                          foregroundColor: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _detailRow(colorScheme, Icons.location_on_outlined, 'Location/Unit', meter.unit),
                  const SizedBox(height: 8),
                  _detailRow(colorScheme, Icons.speed_rounded, 'Current Reading', '${meter.lastReading} kWh'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'READING HISTORY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (allReadings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'No history available',
                    style: TextStyle(color: colorScheme.outline),
                  ),
                ),
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedReadings.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final reading = paginatedReadings[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${reading.value} kWh',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${reading.timestamp.day}/${reading.timestamp.month}/${reading.timestamp.year}',
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
                  );
                },
              ),
              if (allReadings.length > _pageSize) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Page ${_currentPage + 1} of $totalPages',
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 20),
                      onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 20),
                      onPressed: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppRepository appRepo, Submeter meter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Submeter?'),
        content: Text('Are you sure you want to delete the submeter for ${meter.tenantId}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await appRepo.deleteSubmeter(meter.id);
              nav.pop(); // Close dialog
              nav.pop(); // Go back to property management
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(ColorScheme colorScheme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
