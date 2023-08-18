import 'package:flutter/material.dart';

import '../../config/themes/spacing.dart';

class PrinterHome extends StatefulWidget {
  const PrinterHome({super.key});

  @override
  State<PrinterHome> createState() => _PrinterHomeState();
}

class _PrinterHomeState extends State<PrinterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print Ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/printer/scan'),
              child: const Text("Select Printer"),
            ),
          ],
        ),
      ),
    );
  }
}
