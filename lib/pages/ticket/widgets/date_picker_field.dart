import '../../../config/utils/exports.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.enabled,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool? enabled;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDatePickerMode: DatePickerMode.year,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          controller.text = date.toAmericanDate;
        }
      },
    );
  }
}
