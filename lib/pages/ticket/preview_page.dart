import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:u_traffic_enforcer/model/form_input_settings.dart';
import 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';

import '../../config/enums/ticket_field.dart';
import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../model/violation_model.dart';
import '../../providers/violations_provider.dart';
import 'widgets/preview_list_tile.dart';

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
      type: QuickAlertType.confirm,
      title: "Save Ticket",
      text: "Are you sure the ticket is correct?",
      confirmBtnText: "Yes, save",
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

    await saveTicket();
  }

  Future<void> saveTicket() async {
    print("saving ticket");
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

            if (data.key == TicketField.birthDate) {
              title = dateFormat.format(DateTime.parse(data.value));
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
