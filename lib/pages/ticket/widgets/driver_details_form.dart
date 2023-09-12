import 'package:u_traffic_enforcer/pages/ticket/widgets/address_form.dart';
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
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.lastName]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
              validator: (value) => form.validateName(
                value,
                TicketField.lastName,
              ),
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.firstName]!.controller!,
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.firstName]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
              validator: (value) => form.validateName(
                value,
                TicketField.firstName,
              ),
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.middleName]!.controller!,
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.middleName]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
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
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.address]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
              readOnly: true,
              validator: (value) => form.validateAddress(value),
              onTap: () async {
                final address = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressForm(),
                  ),
                );

                if (address != null) {
                  form.formSettings[TicketField.address]!.controller!.text =
                      address.toString();
                }
              },
            ),
            const SizedBox(height: USpace.space12),
            IntlPhoneField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.phone]!.controller!,
              keyboardType: const TextInputType.numberWithOptions(),
              initialCountryCode: 'PH',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                counterText: '',
              ),
              validator: (value) => form.validatePhone(value!.number),
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              controller: formSettings[TicketField.email]!.controller!,
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.email]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
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
              decoration: InputDecoration(
                fillColor: !form.noDriver ? UColors.gray100 : UColors.gray50,
                labelText: formSettings[TicketField.licenseNumber]!.label,
                labelStyle: TextStyle(
                  color: !form.noDriver ? UColors.gray400 : UColors.gray200,
                ),
              ),
              validator: (value) => form.validateLicenseNumber(value),
            ),
          ],
        );
      },
    );
  }
}
