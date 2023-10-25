import '../../../config/utils/exports.dart';

class VehiecleDetailsForm extends StatelessWidget {
  const VehiecleDetailsForm({
    super.key,
    required this.plateNumberController,
    required this.engineNumberController,
    required this.chassisNumberController,
    required this.vehicleOwnerController,
    required this.vehicleOwnerAddressController,
    required this.vehicleTypeController,
    required this.conductionController,
  });

  final TextEditingController plateNumberController;
  final TextEditingController engineNumberController;
  final TextEditingController chassisNumberController;
  final TextEditingController vehicleOwnerController;
  final TextEditingController vehicleOwnerAddressController;
  final TextEditingController vehicleTypeController;
  final TextEditingController conductionController;

  @override
  Widget build(BuildContext context) {
    final formValidator = Provider.of<FormValidators>(context);
    // final vehicleTypes = Provider.of<VehicleTypes>(context);
    return Consumer<CreateTicketFormNotifier>(
      builder: (context, form, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Details",
              style: const UTextStyle().textbasefontmedium,
            ),
            const SizedBox(height: USpace.space12),
            VehicleTypeInputField(
              controller: vehicleTypeController,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              formatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: InputDecoration(
                labelText: 'Plate Number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.help),
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.info,
                      title: 'Valid Formats',
                      text: plateNumberFormats,
                    );
                  },
                ),
              ),
              validator: formValidator.validatePlateNumber,
              controller: plateNumberController,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              decoration: const InputDecoration(
                labelText: 'Conduction Sticker or File Number',
              ),
              validator: (value) {
                return null;
              },
              controller: conductionController,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              formatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Engine Number',
              ),
              validator: (value) {
                return null;
              },
              controller: engineNumberController,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              formatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Chassis Number',
              ),
              controller: chassisNumberController,
            ),
            const SizedBox(height: USpace.space12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Vehicle Owner",
                    style: const UTextStyle().textbasefontmedium,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CheckboxListTile(
                    title: const Text("Owned by Driver"),
                    enabled: !form.isDriverNotPresent,
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    value: form.isVehicleOwnedByDriver,
                    onChanged: (value) {
                      form.setIsVehicleOwnedByDriver(value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              formatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Vehicle Owner',
              ),
              controller: vehicleOwnerController,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              formatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Vehicle Owner Address',
              ),
              controller: vehicleOwnerAddressController,
            ),
          ],
        );
      },
    );
  }
}

class VehicleTypeInputField extends StatelessWidget {
  const VehicleTypeInputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final formValidator = Provider.of<FormValidators>(context);
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Vehicle Type",
      ),
      controller: controller,
      validator: formValidator.validateVehicleType,
      onTap: () async {
        final type = await showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                ListTile(
                  title: const Text("Motorcycle"),
                  onTap: () {
                    Navigator.pop(context, "Motorcycle");
                  },
                ),
                ListTile(
                  title: const Text("Car"),
                  onTap: () {
                    Navigator.pop(context, "Car");
                  },
                ),
                ListTile(
                  title: const Text("Truck"),
                  onTap: () {
                    Navigator.pop(context, "Truck");
                  },
                )
              ],
            );
          },
        );

        if (type != null) {
          controller.text = type;
        }
      },
    );
  }
}
