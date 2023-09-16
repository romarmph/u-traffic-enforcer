import 'package:u_traffic_enforcer/pages/ticket/widgets/address_form.dart';
import 'package:u_traffic_enforcer/pages/ticket/widgets/date_picker_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../config/utils/exports.dart';

class DriverDetailsForm extends StatelessWidget {
  const DriverDetailsForm({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.phoneController,
    required this.emailController,
    required this.licenseNumberController,
    required this.birthDateController,
  });

  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController licenseNumberController;
  final TextEditingController birthDateController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTicketFormNotifier>(
      builder: (context, form, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CheckboxListTile(
            //   title: const Text("No Driver"),
            //   value: form.noDriver,
            //   onChanged: (value) {},
            // ),
            const SizedBox(height: USpace.space12),
            const ImageScannerButton(),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              controller: nameController,
              decoration: const InputDecoration(
                fillColor: UColors.gray100,
                labelText: "Driver Name",
                labelStyle: TextStyle(
                  color: UColors.gray400,
                ),
              ),
              validator: (value) {
                return null;
              },
            ),

            const SizedBox(height: USpace.space12),
            DatePickerField(
                controller: birthDateController,
                label: "Birthdate",
                validator: (value) {
                  return null;
                }),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              controller: addressController,
              decoration: const InputDecoration(
                fillColor: UColors.gray100,
                labelText: 'Address',
                labelStyle: TextStyle(
                  color: UColors.gray400,
                ),
              ),
              readOnly: true,
              validator: (value) {
                return null;
              },
              onTap: () async {
                final address = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressForm(),
                  ),
                );

                if (address != null) {
                  addressController.text = address.toString();
                }
              },
            ),
            const SizedBox(height: USpace.space12),
            IntlPhoneField(
              controller: phoneController,
              keyboardType: const TextInputType.numberWithOptions(),
              initialCountryCode: 'PH',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                counterText: '',
                labelText: 'Phone Number',
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              controller: emailController,
              decoration: const InputDecoration(
                fillColor: UColors.gray100,
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: UColors.gray400,
                ),
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: USpace.space12),
            const Text("License Number"),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              controller: licenseNumberController,
              decoration: const InputDecoration(
                fillColor: UColors.gray100,
                labelText: 'License Number',
                labelStyle: TextStyle(
                  color: UColors.gray400,
                ),
              ),
              validator: (value) {
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
