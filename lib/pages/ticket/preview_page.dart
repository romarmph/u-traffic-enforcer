import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../providers/ticket_provider.dart';

class TicketPreview extends StatelessWidget {
  const TicketPreview({super.key});

  Widget _buildActionButtons(BuildContext context) {
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
              onPressed: () {
                Navigator.pushNamed(context, "/ticketpreview");
              },
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Consumer<TicketProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                Text(
                  value.getTicket.violationsID.toString(),
                ),
                Text(
                  value.getTicket.enforcerId.toString(),
                ),
                Text(
                  value.getTicket.violationsID.toString(),
                ),
                Text(
                  value.getTicket.violationsID.toString(),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }
}
