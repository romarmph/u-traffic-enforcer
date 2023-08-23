import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/create_ticket_form_notifier.dart';
import 'text_field.dart';
import '../../../config/themes/spacing.dart';
import '../../../config/themes/textstyles.dart';

class DriverDetailsForm extends StatelessWidget {
  const DriverDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTicketFormNotifier>(
      builder: (context, form, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text("No Driver"),
              value: form.enabledField,
              onChanged: (value) {
                form.disableFields(value!);
                form.clearDriverFields();
              },
            ),
            CreateTicketField(
              label: form.lastName.label,
              fieldName: form.lastName.fieldName,
              validator: (value) => form.validateName(value),
              enabled: !form.enabledField,
              onChanged: (value) => form.updateDriverFormField(
                form.lastName.fieldName,
                value,
              ),
              initialValue: form.enabledField
                  ? form.driverFormData[form.lastName.fieldName]
                  : null,
            ),
            CreateTicketField(
              label: form.firstName.label,
              fieldName: form.firstName.fieldName,
              validator: (value) => form.validateName(value),
              enabled: !form.enabledField,
              onChanged: (value) => form.updateDriverFormField(
                form.firstName.fieldName,
                value,
              ),
              initialValue: form.enabledField
                  ? form.driverFormData[form.firstName.fieldName]
                  : null,
            ),
            CreateTicketField(
              label: form.middleName.label,
              fieldName: form.middleName.fieldName,
              validator: (value) => form.validateName(value),
              enabled: !form.enabledField,
              onChanged: (value) => form.updateDriverFormField(
                form.middleName.fieldName,
                value,
              ),
              initialValue: form.enabledField
                  ? form.driverFormData[form.middleName.fieldName]
                  : null,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePickerInput(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          // birthDate.text = date.toString();
        }
      },
    );
  }
}
