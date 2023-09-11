import '../../../config/utils/exports.dart';

class CreateTicketField extends StatelessWidget {
  const CreateTicketField({
    super.key,
    this.validator,
    this.onChanged,
    this.enabled,
    this.readOnly = false,
    required this.controller,
    this.keyboardType,
    this.formatters,
    this.maxLength,
    this.decoration,
    this.onTap,
  });

  final String? Function(String?)? validator;
  final void Function(String value)? onChanged;
  final bool? enabled;
  final bool readOnly;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final int? maxLength;
  final InputDecoration? decoration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      maxLength: maxLength,
      inputFormatters: formatters,
      enabled: enabled,
      validator: validator,
      decoration: decoration,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
