import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
import '../../providers/printer_provider.dart';
import '../../providers/ticket_provider.dart';

class PrinterHome extends StatefulWidget {
  const PrinterHome({super.key});

  @override
  State<PrinterHome> createState() => _PrinterHomeState();
}

class _PrinterHomeState extends State<PrinterHome> {
  static final _printer = BluetoothPrint.instance;
  final isConnectedStream = Stream.fromFuture(_printer.isConnected);
  bool isPrinting = false;

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
            Consumer<PrinterProvider>(
              builder: (context, value, child) {
                return StreamBuilder<bool?>(
                  stream: value.isConnected,
                  builder: (context, snapshot) {
                    // ignore: avoid_print
                    print("checking printer connection state");

                    if (snapshot.data != null && !snapshot.data!) {
                      return Container(
                        padding: const EdgeInsets.all(USpace.space12),
                        decoration: BoxDecoration(
                          color: UColors.red200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Printer is not connected."),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(USpace.space12),
                      decoration: BoxDecoration(
                        color: UColors.green200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Printer is connected."),
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                bool? isConnected = await _printer.isConnected;
                if (isConnected != null && isConnected) {
                  _printer.disconnect();
                }
                findDevice();
              },
              child: const Text("Select Printer"),
            ),
            ElevatedButton(
              onPressed: isPrinting
                  ? null
                  : () async {
                      bool? isConnected = await _printer.isConnected;
                      if (isConnected != null && !isConnected) {
                        displayPrinterErrorState();
                        return;
                      }
                      // setState(() {
                      //   isPrinting = true;
                      // });
                      await startPrint();
                      // setState(() {
                      //   isPrinting = false;
                      // });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPrinting ? UColors.gray400 : UColors.blue600,
              ),
              child: const Text("Print"),
            ),
            ElevatedButton(
              onPressed: () {
                _printer.disconnect();
              },
              child: const Text("Disconnect"),
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
        content: "CHUCHUCHUCHU",
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

    setState(() {
      isPrinting = true;
    });
    await _printer.printReceipt(config, list);
    setState(() {
      isPrinting = false;
    });
  }
}
