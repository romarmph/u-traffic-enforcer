import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/pages/ticket/widgets/driver_details_form.dart';
import 'package:u_traffic_enforcer/pages/ticket/widgets/vehicle_details_form.dart';
import 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
// import '../../services/image_picker.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CreateTicketFormNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _notifier = Provider.of<CreateTicketFormNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notifier.clearDriverFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateTicketFormNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: state.driverFormKey,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: USpace.space12),
                          DriverDetailsForm(),
                          SizedBox(height: USpace.space12),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: state.vehicleFormKey,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: USpace.space12),
                          VehiecleDetailsForm(),
                          SizedBox(height: USpace.space12),
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
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(USpace.space12),
      decoration: const BoxDecoration(
        color: UColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(USpace.space24),
          topRight: Radius.circular(USpace.space24),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
            color: UColors.gray200,
            spreadRadius: 2,
          ),
        ],
      ),
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
              onPressed: () {
                if (_tabController.index == 0) {
                  _tabController.animateTo(1);
                  return;
                }

                getFieldValues();
              },
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "Driver Details"),
        Tab(text: "Vehicle Details"),
      ],
    );
  }

  void getFieldValues() {
    final data = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    print(data.vehicleFormData.toString());
    print(data.driverFormData.toString());
  }
}
