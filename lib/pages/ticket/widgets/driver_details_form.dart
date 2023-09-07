import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:u_traffic_enforcer/config/extensions/number_format.dart';
import 'package:u_traffic_enforcer/pages/ticket/widgets/date_picker_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../config/utils/exports.dart';

class DriverDetailsForm extends StatelessWidget {
  const DriverDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTicketFormNotifier>(
      builder: (context, form, child) {
        final formSettings = form.formSettings;

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
            const ImageScannerButton(),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.lastName]!.controller!,
              label: formSettings[TicketField.lastName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.lastName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.firstName]!.controller!,
              label: formSettings[TicketField.firstName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.firstName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.middleName]!.controller!,
              label: formSettings[TicketField.middleName]!.label,
              validator: (value) => form.validateName(
                value,
                TicketField.middleName,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            const DatePickerField(
              field: TicketField.birthDate,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.address]!.controller!,
              label: formSettings[TicketField.address]!.label,
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            // CreateTicketField(
            //   maxLength: 11,
            //   formatters: [NumberTextInputFormatter()],
            //   enabled: !form.noDriver,
            //   controller: formSettings[TicketField.phone]!.controller!,
            //   label: formSettings[TicketField.phone]!.label,
            //   hint: 'Example: 09xxxxxxx',
            //   keyboardType: const TextInputType.numberWithOptions(),
            //   validator: (value) => form.validatePhone(
            //     value,
            //   ),
            //   onChanged: (value) {},
            // ),
            IntlPhoneField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.phone]!.controller!,
              keyboardType: const TextInputType.numberWithOptions(),
              initialCountryCode: 'PH',
              decoration: const InputDecoration(
                counterText: '',
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.email]!.controller!,
              label: formSettings[TicketField.email]!.label,
              validator: (value) => form.validateEmail(
                value,
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: USpace.space12),
            const Text("License Number"),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.licenseNumber]!.controller!,
              label: formSettings[TicketField.licenseNumber]!.label,
              validator: (value) => null,
              onChanged: (value) {},
            ),
          ],
        );
      },
    );
  }
}
