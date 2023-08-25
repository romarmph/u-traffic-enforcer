import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/config/enums/ticket_field.dart';
import 'package:u_traffic_enforcer/config/themes/textstyles.dart';
import 'package:u_traffic_enforcer/config/utils/nav_utils.dart';
import 'package:u_traffic_enforcer/providers/create_ticket_form_notifier.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../model/violation_model.dart';
import '../../providers/ticket_provider.dart';
import '../../providers/violations_provider.dart';

class ViolationsList extends StatefulWidget {
  const ViolationsList({super.key});

  @override
  State<ViolationsList> createState() => _ViolationsListState();
}

class _ViolationsListState extends State<ViolationsList> {
  @override
  void initState() {
    super.initState();

    Provider.of<ViolationProvider>(context, listen: false).listenToViolations();
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
              child: const Text("Back"),
            ),
          ),
          const SizedBox(width: USpace.space16),
          Expanded(
            child: ElevatedButton(
              onPressed: _previewTicket,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationsList() {
    return Consumer<ViolationProvider>(
      builder: (context, violation, child) {
        return ListView.builder(
          itemCount: violation.getViolations.length,
          itemBuilder: (context, index) {
            Violation current = violation.getViolations[index];
            return CheckboxListTile(
              value: current.isSelected,
              onChanged: (value) {
                violation.selectViolation(current.id);
              },
              title: Text(current.name),
              subtitle: Text(
                "Fine: ${current.fine.toString()}",
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Violations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please select the violations below:",
              style: const UTextStyle().textlgfontmedium,
            ),
            Expanded(
              child: _buildViolationsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  void _previewTicket() {
    final provider = Provider.of<ViolationProvider>(context, listen: false);

    if (provider.getViolations.where((element) => element.isSelected).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one violation"),
        ),
      );
      return;
    }

    final Set<String?> selectedTicket = provider.getViolations
        .where((element) => element.isSelected)
        .map((e) => e.id)
        .toSet();

    goPreviewTicket();
  }
}
