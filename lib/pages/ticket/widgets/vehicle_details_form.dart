import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/config/enums/field_type.dart';
import 'package:u_traffic_enforcer/config/enums/ticket_field.dart';
import 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';

import '../../../config/themes/spacing.dart';
import '../../../config/themes/textstyles.dart';
import '../../../model/form_input_settings.dart';
import 'text_field.dart';

class VehiecleDetailsForm extends StatelessWidget {
  const VehiecleDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildVehicleTypeInput(context, form),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              label: form.formSettings[TicketField.plateNumber]!.label,
              controller:
                  form.formSettings[TicketField.plateNumber]!.controller!,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              label: form.formSettings[TicketField.engineNumber]!.label,
              controller:
                  form.formSettings[TicketField.engineNumber]!.controller!,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              label: form.formSettings[TicketField.chassisNumber]!.label,
              controller:
                  form.formSettings[TicketField.chassisNumber]!.controller!,
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
                    enabled: !form.noDriver,
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    value: form.ownedByDriver,
                    onChanged: (value) => form.setOwnedByDriver(value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              readOnly: form.ownedByDriver,
              label: form.formSettings[TicketField.vehicleOwner]!.label,
              controller:
                  form.formSettings[TicketField.vehicleOwner]!.controller!,
            ),
            const SizedBox(height: USpace.space12),
            CreateTicketField(
              enabled: !form.noDriver,
              readOnly: form.ownedByDriver,
              label: form.formSettings[TicketField.vehicleOwnerAddress]!.label,
              controller: form
                  .formSettings[TicketField.vehicleOwnerAddress]!.controller!,
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleTypeInput(
    BuildContext context,
    CreateTicketFormNotifier form,
  ) {
    FormSettings formSettings = form.formSettings[TicketField.vehicleType]!;
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Vehicle Type",
      ),
      controller: formSettings.controller,
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
          formSettings.controller!.text = type;
        }
      },
    );
  }
}
