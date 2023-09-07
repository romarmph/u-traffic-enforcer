import '../../../config/utils/exports.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.field,
  });

  final TicketField field;

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    final formSetting = form.formSettings[field];
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: formSetting!.label,
      ),
      controller: formSetting.controller,
      validator: (value) => form.validateDate(value),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          formSetting.controller!.text = date.toString().split(' ').first;
          form.driverFormData[field] = date;
        } else {
          formSetting.controller!.clear();
        }
      },
    );
  }
}
