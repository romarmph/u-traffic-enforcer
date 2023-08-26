import 'package:intl/intl.dart';

import '../../config/utils/exports.dart';

class TicketPreview extends StatefulWidget {
  const TicketPreview({super.key});

  @override
  State<TicketPreview> createState() => _TicketPreviewState();
}

class _TicketPreviewState extends State<TicketPreview>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

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
                child: ElevatedButton(
                  onPressed: _showDialog,
                  child: const Text("Save Ticket"),
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
        // Navigator.of(context).pushNamed("/printer/");
      },
    );

    if (value == null) {
      return;
    }

    saveTicket();
  }

  Future<void> saveTicket() async {
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    final enforcer = Provider.of<AuthService>(context, listen: false);

    Map<String, dynamic> data = {
      'ticketNumber': "",
      'violationsID': form.selectedViolationsID,
      'licenseNumber': form.driverFormData[TicketField.licenseNumber],
      'firstName': form.driverFormData[TicketField.firstName],
      'middleName': form.driverFormData[TicketField.middleName],
      'lastName': form.driverFormData[TicketField.lastName],
      'birthDate': form.driverFormData[TicketField.birthDate],
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
      'placeOfViolation': "",
      'violationDateTime': DateTime.now(),
      'enforcerId': enforcer.currentUser.id,
      'driverSignature': "",
    };

    await TicketDBHelper().saveTicket(
      data,
    );

    _showSaveSuccessDialog();
  }

  void _showSaveSuccessDialog() async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
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
    final dateFormat = DateFormat("MMMM dd, yyyy");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: formData.entries.map((data) {
            String title = data.value;

            if (data.key == TicketField.birthDate && data.value != "") {
              title = dateFormat.format(DateTime.parse(data.value));
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
}
