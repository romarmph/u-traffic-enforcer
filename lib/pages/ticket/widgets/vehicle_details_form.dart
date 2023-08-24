import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';

import '../../../config/themes/spacing.dart';
import '../../../config/themes/textstyles.dart';
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
            const CreateTicketField(
              label: "Plate Number",
              fieldName: "plateNumber",
            ),
            const SizedBox(height: USpace.space12),
            _buildVehicleTypeInput(context),
            const SizedBox(height: USpace.space12),
            const CreateTicketField(
              label: "Engine Number",
              fieldName: "engineNumber",
            ),
            const SizedBox(height: USpace.space12),
            const CreateTicketField(
              label: "Chassis Number",
              fieldName: "chassisNumber",
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
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: USpace.space12),
            const CreateTicketField(
              label: "Name",
              fieldName: "vehicleOwner",
            ),
            const SizedBox(height: USpace.space12),
            const CreateTicketField(
              label: "Address",
              fieldName: "vehicleOwnerAddress",
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleTypeInput(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Vehicle Type",
      ),
      // controller: widget.vehicleType,
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
          // widget.vehicleType.text = type;
        }
      },
    );
  }
}
