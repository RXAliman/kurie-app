import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/models/submeter.dart';
import '../data/repositories/app_repository.dart';

class EditSubmeterScreen extends StatefulWidget {
  final String submeterId;

  const EditSubmeterScreen({super.key, required this.submeterId});

  @override
  State<EditSubmeterScreen> createState() => _EditSubmeterScreenState();
}

class _EditSubmeterScreenState extends State<EditSubmeterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _tenantController;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final meter = context.read<AppRepository>().submeters.firstWhere((s) => s.id == widget.submeterId);
      _locationController = TextEditingController(text: meter.unit == 'N/A' ? '' : meter.unit);
      _tenantController = TextEditingController(text: meter.tenantId);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Edit Submeter'),
        backgroundColor: colorScheme.surface,
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
                validator: (v) => v == null || v.isEmpty ? 'Tenant name is required' : null,
              ),
              const SizedBox(height: 20),
              _textField(
                context: context,
                label: 'Property Location / Unit',
                hint: 'e.g., North Wing, Floor 2 / Unit 12C (Optional)',
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
                      final appRepo = context.read<AppRepository>();
                      final meter = appRepo.submeters.firstWhere((s) => s.id == widget.submeterId);
                      
                      final updatedMeter = Submeter(
                        id: meter.id,
                        unit: _locationController.text.trim().isEmpty ? 'N/A' : _locationController.text.trim(),
                        tenantId: _tenantController.text.trim(),
                        lastReading: meter.lastReading,
                        status: meter.status,
                      );

                      final navigator = Navigator.of(context);
                      await appRepo.updateSubmeter(updatedMeter);
                      navigator.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
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
