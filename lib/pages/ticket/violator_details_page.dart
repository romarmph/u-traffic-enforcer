import 'package:flutter/material.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../config/themes/textstyles.dart';
import '../../services/image_picker.dart';

class ViolatorDetails extends StatefulWidget {
  const ViolatorDetails({super.key});

  @override
  State<ViolatorDetails> createState() => _ViolatorDetailsState();
}

class _ViolatorDetailsState extends State<ViolatorDetails> {
  final _driverDetailFormKey = GlobalKey<FormState>();
  final _vehicleDetailFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _vehicleOwnerController = TextEditingController();
  final _vehicleOwnerAddressController = TextEditingController();
  bool _isSameAsDriver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _driverDetailFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: USpace.space12),
                            _buildDriverDetailsForm(),
                            const SizedBox(height: USpace.space12),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Form(
                        key: _vehicleDetailFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: USpace.space12),
                            _buildVehicleForm(),
                            const SizedBox(height: USpace.space12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      readOnly: readOnly,
    );
  }

  Widget _buildDatePickerInput() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
      ),
      controller: _birthDateController,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          _birthDateController.text = date.toString();
        }
      },
    );
  }

  Widget _buildDriverDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Driver Details",
          style: const UTextStyle().textbasefontmedium,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "Last Name",
          controller: _lastNameController,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "First Name",
          controller: _firstNameController,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "Middle Name",
          controller: _middleNameController,
        ),
        const SizedBox(height: USpace.space12),
        _buildDatePickerInput(),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "Address",
          controller: _addressController,
        ),
        const SizedBox(height: USpace.space12),
        Text(
          "Driver's License",
          style: const UTextStyle().textbasefontmedium,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "License Number",
          controller: _licenseNumberController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: USpace.space12),
        SizedBox(
          height: 64,
          width: double.infinity,
          // padding: const EdgeInsets.all(USpace.space16),
          child: OutlinedButton.icon(
            onPressed: () async {
              final imagePicker = ImagePickerService.instance;
              final file = await imagePicker.pickImage();
              print(
                  "=========================== DITO YUN PRE ============================");
              print(file!.path);
            },
            label: const Text("Scann Driver's License"),
            icon: const Icon(Icons.camera_alt_rounded),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleTypeInput() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Vehicle Type",
      ),
      controller: _vehicleTypeController,
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
          _vehicleTypeController.text = type;
        }
      },
    );
  }

  Widget _buildVehicleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Details",
          style: const UTextStyle().textbasefontmedium,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "Plate Number",
          controller: _plateNumberController,
        ),
        const SizedBox(height: USpace.space12),
        _buildVehicleTypeInput(),
        const SizedBox(height: USpace.space12),
        _buildInput(
          label: "Engine Number",
          controller: _engineNumberController,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
            label: "Chassis Number", controller: _chassisNumberController),
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
                value: _isSameAsDriver,
                onChanged: (value) {
                  if (value!) {
                    _vehicleOwnerController.text =
                        "${_lastNameController.text}, ${_firstNameController.text} ${_middleNameController.text}";
                    _vehicleOwnerAddressController.text =
                        _addressController.text;
                  } else {
                    _vehicleOwnerController.text = "";
                    _vehicleOwnerAddressController.text = "";
                  }
                  setState(() {
                    _isSameAsDriver = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          controller: _vehicleOwnerController,
          label: "Name",
          readOnly: _isSameAsDriver,
        ),
        const SizedBox(height: USpace.space12),
        _buildInput(
          controller: _vehicleOwnerAddressController,
          label: "Address",
          readOnly: _isSameAsDriver,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(USpace.space12),
      color: UColors.white,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: USpace.space16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return const TabBar(
      tabs: [
        Tab(text: "Driver Details"),
        Tab(text: "Vehicle Details"),
      ],
    );
  }
}
