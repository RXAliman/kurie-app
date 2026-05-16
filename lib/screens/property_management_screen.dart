import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/app_repository.dart';
import 'add_submeter_screen.dart';
import 'submeter_details_screen.dart';

class PropertyManagementScreen extends StatefulWidget {
  const PropertyManagementScreen({super.key});

  @override
  State<PropertyManagementScreen> createState() => _PropertyManagementScreenState();
}

class _PropertyManagementScreenState extends State<PropertyManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _currentPage = 0; // Reset pagination on search
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allSubmeters = context.watch<AppRepository>().submeters;
    
    // Filter logic
    final filteredSubmeters = allSubmeters.where((m) {
      final query = _searchController.text.toLowerCase();
      return m.unit.toLowerCase().contains(query) || 
             m.tenantId.toLowerCase().contains(query);
    }).toList();

    // Pagination logic
    final totalPages = (filteredSubmeters.length / _pageSize).ceil();
    final paginatedSubmeters = filteredSubmeters
        .skip(_currentPage * _pageSize)
        .take(_pageSize)
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Property Management'),
        backgroundColor: colorScheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSubmeterScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Submeter'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Property',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${allSubmeters.length} Submeters Total',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Search Bar (Only if 5 or more total submeters)
          if (allSubmeters.length >= 5)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search submeter or tenant...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  fillColor: colorScheme.surfaceContainerLow,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
              ),
            ),
          
          if (allSubmeters.length >= 5) const SizedBox(height: 20),

          // List
          Expanded(
            child: paginatedSubmeters.isEmpty
                ? Center(
                    child: Text(
                      'No units found',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: paginatedSubmeters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final meter = paginatedSubmeters[index];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          border: Border.all(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meter.tenantId,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.history_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                                const SizedBox(width: 6),
                                Text(
                                  'Last Reading: ${meter.lastReading} kWh',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubmeterDetailsScreen(submeterId: meter.id),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colorScheme.primary),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child: const Text('Manage Unit', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Pagination Controls (Only if 10 or more total filtered submeters)
          if (filteredSubmeters.length > _pageSize)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Page ${_currentPage + 1} of $totalPages',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    onPressed: _currentPage > 0 
                        ? () => setState(() => _currentPage--) 
                        : null,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    onPressed: _currentPage < totalPages - 1 
                        ? () => setState(() => _currentPage++) 
                        : null,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
