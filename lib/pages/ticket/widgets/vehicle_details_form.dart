import '../../../config/utils/exports.dart';

class VehiecleDetailsForm extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final formValidator = ref.watch(formValidatorProvider);
    final form = ref.watch(createTicketFormProvider);
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
  }
}

class VehicleTypeInputField extends ConsumerWidget {
  const VehicleTypeInputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createTicketFormProvider);
    final formValidator = ref.watch(formValidatorProvider);
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Vehicle Type",
      ),
      controller: controller,
      validator: formValidator.validateVehicleType,
      onTap: () async {
        final VehicleType? type = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(8),
              content: LayoutBuilder(builder: (context, constraints) {
                return ref.watch(vehicleTypeStreamProvider).when(
                      data: (data) {
                        return SizedBox(
                          height: constraints.maxHeight * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Select Vehicle Type"),
                              const SizedBox(
                                height: 16,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final vehicle = data[index];
                                    return ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      onTap: () {
                                        Navigator.pop(context, vehicle);
                                      },
                                      title: Text(vehicle.typeName),
                                      subtitle: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: vehicle.isPublic
                                              ? UColors.yellow400
                                              : UColors.blue400,
                                        ),
                                        child: Text(
                                          vehicle.isPublic
                                              ? "Public"
                                              : "Private",
                                          style: const TextStyle(
                                            color: UColors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        return const Center(
                          child: Text("Error loading vehicle types"),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
              }),
            );
          },
        );

        if (type != null) {
          controller.text = type.typeName;
          form.setVehicleTypeID(type.id!);
        }
      },
    );
  }
}
