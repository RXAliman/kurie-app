import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme/kurie_colors.dart';
import '../data/models/submeter.dart';
import '../data/models/reading.dart';
import '../data/repositories/app_repository.dart';

/// Add New Submeter screen — matches Stitch "Add Submeter" design.
/// Form for provisioning a new unit with initial readings and tenant assignment.
class AddSubmeterScreen extends StatefulWidget {
  const AddSubmeterScreen({super.key});

  @override
  State<AddSubmeterScreen> createState() => _AddSubmeterScreenState();
}

class _AddSubmeterScreenState extends State<AddSubmeterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _readingController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedTenant;

  @override
  void dispose() {
    _nameController.dispose();
    _readingController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      appBar: AppBar(
        title: const Text('Add New Submeter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('UNIT INFORMATION'),
              const SizedBox(height: 8),
              _textField(
                label: 'Submeter Name',
                hint: 'e.g., Unit 12C',
                controller: _nameController,
                icon: Icons.drive_file_rename_outline_rounded,
              ),
              const SizedBox(height: 20),
              _textField(
                label: 'Initial Reading (kWh)',
                hint: '0.00',
                controller: _readingController,
                keyboardType: TextInputType.number,
                icon: Icons.speed_rounded,
              ),
              const SizedBox(height: 32),
              _sectionLabel('TENANT ASSIGNMENT'),
              const SizedBox(height: 8),
              _dropdownField(
                label: 'Assign Tenant',
                hint: 'Select an existing tenant',
                items: ['Unassigned'],
                value: _selectedTenant,
                onChanged: (v) => setState(() => _selectedTenant = v),
              ),
              const SizedBox(height: 32),
              _sectionLabel('LOCATION DETAILS'),
              const SizedBox(height: 8),
              _textField(
                label: 'Property Location',
                hint: 'e.g., North Wing, Floor 2',
                controller: _locationController,
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      final appRepo = context.read<AppRepository>();

                      final newSubmeter = Submeter(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        unit: _locationController.text,
                        tenantId: _selectedTenant ?? 'Unassigned',
                        lastReading: _readingController.text,
                        status: 'Active',
                      );

                      await appRepo.addSubmeter(newSubmeter);

                      // Also create an initial reading record if provided
                      if (_readingController.text.isNotEmpty) {
                        final initialValue = double.tryParse(_readingController.text) ?? 0.0;
                        final initialReading = Reading(
                          id: 'init_${newSubmeter.id}',
                          submeterId: newSubmeter.id,
                          timestamp: DateTime.now(),
                          value: initialValue,
                        );
                        await appRepo.addReading(initialReading);
                      }

                      navigator.pop();
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Submeter added successfully'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KurieColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Save Submeter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: KurieColors.onSurfaceVariant,
      ),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            fillColor: KurieColors.surfaceContainerLowest,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: KurieColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: KurieColors.outlineVariant),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String hint,
    required List<String> items,
    String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: KurieColors.surfaceContainerLowest,
            border: Border.all(
              color: KurieColors.outlineVariant,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(hint),
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
