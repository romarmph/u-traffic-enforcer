import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';

class PrinterHome extends StatefulWidget {
  const PrinterHome({super.key});

  @override
  State<PrinterHome> createState() => _PrinterHomeState();
}

class _PrinterHomeState extends State<PrinterHome> {
  static final _printer = BluetoothPrint.instance;
  final isConnectedStream = Stream.fromFuture(_printer.isConnected);

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
            Expanded(
              child: StreamBuilder<int>(
                stream: _printer.state,
                builder: (context, snapshot) {
                  // ignore: avoid_print
                  print("PRINTER STATE: ${snapshot.data}");

                  if (snapshot.data != null &&
                      (snapshot.data == 12 || snapshot.data == 1)) {
                    return Container(
                      padding: const EdgeInsets.all(USpace.space12),
                      decoration: BoxDecoration(
                        color: UColors.green200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text("Printer is connected.")),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.all(USpace.space12),
                    decoration: BoxDecoration(
                      color: UColors.red200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text("Printer is not connected."),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: USpace.space12),
            OutlinedButton(
              onPressed: () async {
                bool? isConnected = await _printer.isConnected;
                if (isConnected != null && isConnected) {
                  _printer.disconnect();
                }
                findDevice();
              },
              child: const Text("Select Printer"),
            ),
            const SizedBox(height: USpace.space8),
            ElevatedButton(
              onPressed: () async {
                bool? isConnected = await _printer.isConnected;
                if (isConnected != null && !isConnected) {
                  displayPrinterErrorState();
                  return;
                }

                await startPrint();
              },
              child: const Text("Print Ticket"),
            ),
          ],
        ),
      ),
    );
  }

  void findDevice() {
    Navigator.pushNamed(context, '/printer/scan');
  }

  void displayPrinterErrorState() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Printer not connected"),
        backgroundColor: UColors.red500,
      ),
    );
  }

  Future<void> startPrint() async {
    Map<String, dynamic> config = {
      'width': 48,
    };

    List<LineText> list = [];

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Public Order and Safety Office",
        weight: 4,
        height: 4,
        width: 4,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "City of Urdaneta",
        weight: 4,
        height: 4,
        width: 4,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "DADADADADADADADA",
        weight: 4,
        height: 4,
        width: 4,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_BARCODE,
        content: "1231241231312",
        align: LineText.ALIGN_CENTER,
        width: 12,
        height: 12,
        linefeed: 1,
        weight: 12,
      ),
    );

    await _printer.printReceipt(config, list);
  }
}
