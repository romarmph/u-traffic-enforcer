import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../model/ticket_model.dart';
import '../../model/violation_model.dart';
import '../../providers/ticket_provider.dart';
import '../../providers/violations_provider.dart';
import '../common/preview_list_tile.dart';

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
    tabController = TabController(length: 2, vsync: this);

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
                  "Please make sure that all details are correct and was checked by the driver before printing.",
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
                  onPressed: () {
                    // Navigator.pushNamed(context, "");
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text: "Are you sure to print this ticket?",
                      confirmBtnText: "Print now",
                      cancelBtnText: "No, cancel",
                      onConfirmBtnTap: () {
                        print("Printed");
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/printer/");
                      },
                    );
                  },
                  child: const Text("Print"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final violationsProvider = Provider.of<ViolationProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Details"),
      ),
      body: Consumer<TicketProvider>(
        builder: (context, value, child) {
          final Ticket ticket = value.getTicket;

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
                    _builDetailsView(ticket),
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
        text: "Violator Detials",
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

  Widget _builDetailsView(Ticket ticket) {
    final dateFormat = DateFormat("MMMM dd, yyyy");

    final details = ticket
        .map((key, value) => {key: value})
        .entries
        .toList()
        .where((element) =>
            (element.value != null || element.key == "birthDate") &&
            element.key != "violationsID");

    print(details);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: details.map((e) {
            String title = "";

            return PreviewListTile(
              title: title,
              subtitle: _getLabel(e.key),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getLabel(String key) {
    Map<String, dynamic> fields = {
      // 'ticketNumber': "ticketNumber",
      // 'violationsID': "violationsID",
      'licenseNumber': "License Number",
      'driverFirstName': "First Name",
      'driverMiddleName': "Middle Name",
      'driverLastName': "Last Name",
      'birthDate': "Birthdate",
      'address': "Address",
      // 'status': "status",
      'vehicleType': "Vehicle Type",
      'engineNumber': "Engine Number",
      'chassisNumber': "Chassis Number",
      'plateNumber': "Plate Number",
      'vehicleOwner': "Vehicle Owner",
      'vehicleOwnerAddress': "Vehicle Owner Address",
      // 'placeOfViolation': "placeOfViolation",
      // 'violationDateTime': "violationDateTime",
      // 'enforcerId': "enforcerId",
      // 'driverSignature': "driverSignature",
    };

    return fields[key];
  }
}
