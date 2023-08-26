import '../../../config/utils/exports.dart';

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
              value: form.noDriver,
              onChanged: (value) {
                form.setNoDriver(value!);
              },
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: form.formSettings[TicketField.lastName]!.controller!,
              label: form.formSettings[TicketField.lastName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.lastName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: form.formSettings[TicketField.firstName]!.controller!,
              label: form.formSettings[TicketField.firstName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.firstName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller:
                  form.formSettings[TicketField.middleName]!.controller!,
              label: form.formSettings[TicketField.middleName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.middleName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            _buildDatePickerInput(context, form),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: form.formSettings[TicketField.address]!.controller!,
              label: form.formSettings[TicketField.address]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.address,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: form.formSettings[TicketField.phone]!.controller!,
              label: form.formSettings[TicketField.phone]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.phone,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: form.formSettings[TicketField.email]!.controller!,
              label: form.formSettings[TicketField.email]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.email,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            const Text("License Number"),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller:
                  form.formSettings[TicketField.licenseNumber]!.controller!,
              label: form.formSettings[TicketField.licenseNumber]!.label,
              validator: (value) => null,
              onChanged: (value) {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePickerInput(
    BuildContext context,
    CreateTicketFormNotifier form,
  ) {
    FormSettings formSettings = form.formSettings[TicketField.birthDate]!;
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: formSettings.label,
      ),
      controller: formSettings.controller,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          formSettings.controller!.text = date.toString();
          form.driverFormData[TicketField.birthDate] = date;
        }
      },
    );
  }
}
