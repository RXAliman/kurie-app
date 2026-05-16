import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  final _readingController = TextEditingController();
  final _locationController = TextEditingController();
  final _tenantController = TextEditingController();

  @override
  void dispose() {
    _readingController.dispose();
    _locationController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _textField(
                context: context,
                label: 'Assign Tenant',
                hint: 'Tenant Name',
                controller: _tenantController,
                icon: Icons.person_outline_rounded,
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toUpperCase());
                  }),
                ],
                validator: (v) =>
                    v == null || v.isEmpty ? 'Tenant name is required' : null,
              ),
              const SizedBox(height: 20),
              _textField(
                context: context,
                label: 'Property Location / Unit',
                hint: 'e.g., North Wing, Floor 2 / Unit 12C (Optional)',
                controller: _locationController,
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),
              _textField(
                context: context,
                label: 'Initial Reading (kWh)',
                hint: '0.00',
                controller: _readingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                icon: Icons.speed_rounded,
                validator: (v) {
                  if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
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

                      final tenant = _tenantController.text.trim();
                      final finalTenant = tenant.isEmpty
                          ? 'Unassigned'
                          : tenant;

                      final location = _locationController.text.trim();
                      final initialReading = double.tryParse(_readingController.text) ?? 0.0;

                      final newSubmeter = Submeter(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        unit: location.isEmpty ? 'N/A' : location,
                        tenantId: finalTenant,
                        lastReading: initialReading.toStringAsFixed(2),
                        status: 'Active',
                      );

                      // Also create initial reading entry
                      final initialReadingEntry = Reading(
                        id: 'initial_${newSubmeter.id}',
                        submeterId: newSubmeter.id,
                        value: initialReading,
                        timestamp: DateTime.now(),
                      );
                      await appRepo.addSubmeter(newSubmeter);
                      await appRepo.addReading(initialReadingEntry);

                      navigator.pop();
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Submeter added successfully'),
                        ),
                      );
                    }
                  },
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

  Widget _textField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          ),
        ),
      ],
    );
  }
}
