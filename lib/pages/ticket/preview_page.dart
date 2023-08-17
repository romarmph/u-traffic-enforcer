import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/model/violation_model.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../model/ticket_model.dart';
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
                    Navigator.pushNamed(context, "/ticketpreview");
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Driver Details",
              style: TextStyle(
                color: UColors.gray400,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            PreviewListTile(
              title: ticket.driverLastName!,
              subtitle: "Last Name",
            ),
            PreviewListTile(
              title: ticket.driverFirstName!,
              subtitle: "First Name",
            ),
            PreviewListTile(
              title: ticket.driverMiddleName!,
              subtitle: "Middle Name",
            ),
            PreviewListTile(
              title: dateFormat.format(ticket.birthDate!),
              subtitle: "Birthdate",
            ),
            PreviewListTile(
              title: ticket.licenseNumber!,
              subtitle: "License Number",
            ),
            const SizedBox(
              height: USpace.space12,
            ),
            const Text(
              "Vehicle Details",
              style: TextStyle(
                color: UColors.gray400,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            PreviewListTile(
              title: ticket.plateNumber!,
              subtitle: "Plate Number",
            ),
            PreviewListTile(
              title: ticket.engineNumber!,
              subtitle: "Engine Number",
            ),
            PreviewListTile(
              title: ticket.chassisNumber!,
              subtitle: "Chassis Number",
            ),
            PreviewListTile(
              title: ticket.vehicleType!,
              subtitle: "Vehicle Type",
            ),
            PreviewListTile(
              title: ticket.vehicleOwner!,
              subtitle: "Vehicle Owner",
            ),
            PreviewListTile(
              title: ticket.vehicleOwnerAddress!,
              subtitle: "Vehicle Owner Address",
            ),
          ],
        ),
      ),
    );
  }
}
