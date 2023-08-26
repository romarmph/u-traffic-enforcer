import '../../../config/utils/exports.dart';

class CreateTicketField extends StatelessWidget {
  const CreateTicketField({
    super.key,
    this.validator,
    this.onChanged,
    this.enabled,
    this.readOnly = false,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final bool? enabled;
  final bool readOnly;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onChanged: onChanged,
    );
  }
}
