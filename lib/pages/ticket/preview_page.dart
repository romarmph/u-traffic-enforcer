import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';

import '../../config/utils/exports.dart';

class TicketPreview extends StatefulWidget {
  const TicketPreview({super.key});

  @override
  State<TicketPreview> createState() => _TicketPreviewState();
}

class _TicketPreviewState extends State<TicketPreview>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool _isSaving = false;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(USpace.space8),
      color: UColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info),
              SizedBox(width: USpace.space12),
              Flexible(
                child: Text(
                  "Please make sure that all details are correct and was checked by the driver before saving.",
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(height: USpace.space12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: USpace.space16),
              Expanded(
                child: AbsorbPointer(
                  absorbing: _isSaving,
                  child: ElevatedButton(
                    style: _isSaving
                        ? ElevatedButton.styleFrom(
                            backgroundColor: UColors.gray400,
                          )
                        : null,
                    onPressed: _showDialog,
                    child: Text(_isSaving ? "Saving..." : "Save Ticket"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog() async {
    final value = await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: "Save Ticket",
      text:
          "Once save it cannot be edited anymore.\nAre you sure the ticket is correct?",
      confirmBtnText: "Yes, save",
      showCancelBtn: true,
      cancelBtnText: "No, cancel",
      barrierDismissible: true,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
    );

    if (value == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await saveTicket();

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> saveTicket() async {
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    final enforcer = Provider.of<AuthService>(context, listen: false);

    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Saving ticket...',
        barrierDismissible: false);

    final location = await LocationServices.instance.getLocation();

    Map<String, dynamic> data = {
      'ticketNumber': "",
      'violationsID': form.selectedViolationsID,
      'licenseNumber': form.driverFormData[TicketField.licenseNumber],
      'firstName': form.driverFormData[TicketField.firstName],
      'middleName': form.driverFormData[TicketField.middleName],
      'lastName': form.driverFormData[TicketField.lastName],
      'birthDate': form.driverFormData[TicketField.birthDate]
          .toString()
          .reverseFormatDate(),
      'phone': form.driverFormData[TicketField.phone],
      'email': form.driverFormData[TicketField.email],
      'address': form.driverFormData[TicketField.address],
      'status': TicketStatus.unpaid,
      'vehicleType': form.vehicleFormData[TicketField.vehicleType],
      'engineNumber': form.vehicleFormData[TicketField.engineNumber],
      'chassisNumber': form.vehicleFormData[TicketField.chassisNumber],
      'plateNumber': form.vehicleFormData[TicketField.plateNumber],
      'vehicleOwner': form.vehicleFormData[TicketField.vehicleOwner],
      'vehicleOwnerAddress':
          form.vehicleFormData[TicketField.vehicleOwnerAddress],
      'violationDateTime': DateTime.now(),
      'enforcerId': enforcer.currentUser.id,
      'driverSignature': "",
      'placeOfViolation': location.toJson(),
    };

    final future = await TicketDBHelper().saveTicket(data);

    try {
      await renameAndUpload(form.licenseImagePath, future.id!);
    } catch (e) {
      print(e);
    }

    popCurrent();

    _showSaveSuccessDialog(future);
  }

  void _showSaveSuccessDialog(Ticket ticket) async {
    Provider.of<TicketProvider>(context, listen: false).updateTicket(ticket);

    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      barrierDismissible: false,
      onConfirmBtnTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/printer/',
          (route) => route.isFirst,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Details"),
      ),
      body: Consumer<CreateTicketFormNotifier>(
        builder: (context, form, child) {
          final driverForm = form.driverFormData;
          final vehicleForm = form.vehicleFormData;
          final formSettings = form.formSettings;

          return Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: _buildTabs(),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _buildDetails(driverForm, formSettings),
                    _buildDetails(vehicleForm, formSettings),
                    _buildViolationsView(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  List<Widget> _buildTabs() {
    return const <Widget>[
      Tab(
        text: "Driver Detials",
      ),
      Tab(
        text: "Vehicle Detials",
      ),
      Tab(
        text: "Violations",
      ),
    ];
  }

  Widget _buildViolationsView() {
    return Consumer<ViolationProvider>(
      builder: (context, value, child) {
        final List<Violation> selected =
            value.getViolations.where((element) => element.isSelected).toList();

        return ListView.builder(
          itemCount: selected.length,
          itemBuilder: (context, index) {
            final Violation violation = selected[index];

            return ListTile(
              title: Text(violation.name),
              trailing: Text(
                violation.fine.toString(),
                style: const TextStyle(
                  color: UColors.red400,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              titleTextStyle: const TextStyle(
                color: UColors.gray600,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetails(
    Map<TicketField, dynamic> formData,
    Map<TicketField, dynamic> formSettings,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: formData.entries.map((data) {
            String title = data.value;

            if (data.key == TicketField.birthDate && data.value != "") {
              title = data.value;
            }

            if (title.isEmpty) {
              title = "N/A";
            }

            return PreviewListTile(
              title: title,
              subtitle: formSettings[data.key].label,
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> renameAndUpload(String oldPath, String newName) async {
    final newFile = ImagePickerService.instance.rename(
      oldPath,
      newName,
    );

    // Create a reference to the location you want to upload to in Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('licenseImage/$newName.jpg');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = ref.putFile(newFile);

    // Check for any errors
    try {
      await uploadTask;
      print('Upload complete!');
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
