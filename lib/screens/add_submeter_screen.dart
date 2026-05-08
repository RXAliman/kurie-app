import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Add New Submeter screen — matches Stitch "Add Submeter" design.
/// Form for provisioning a new unit with initial readings and tenant assignment.
class AddSubmeterScreen extends StatefulWidget {
  const AddSubmeterScreen({super.key});

  @override
  State<AddSubmeterScreen> createState() => _AddSubmeterScreenState();
}

class _AddSubmeterScreenState extends State<AddSubmeterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTenant;

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
                icon: Icons.drive_file_rename_outline_rounded,
              ),
              const SizedBox(height: 20),
              _textField(
                label: 'Initial Reading (kWh)',
                hint: '0.00',
                keyboardType: TextInputType.number,
                icon: Icons.speed_rounded,
              ),
              const SizedBox(height: 32),
              _sectionLabel('TENANT ASSIGNMENT'),
              const SizedBox(height: 8),
              _dropdownField(
                label: 'Assign Tenant',
                hint: 'Select an existing tenant',
                items: ['Alice Johnson', 'Bob Smith', 'Charlie Davis', 'Unassigned'],
                value: _selectedTenant,
                onChanged: (v) => setState(() => _selectedTenant = v),
              ),
              const SizedBox(height: 32),
              _sectionLabel('LOCATION DETAILS'),
              const SizedBox(height: 8),
              _textField(
                label: 'Property Location',
                hint: 'e.g., North Wing, Floor 2',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Submeter added successfully')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KurieColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            border: Border.all(color: KurieColors.outlineVariant),
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
