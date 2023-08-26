import 'package:intl/intl.dart';

import '../../../config/utils/exports.dart';

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
                      child: const Center(
                        child: Text("Printer is connected."),
                      ),
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
    final ticket = Provider.of<TicketProvider>(
      context,
      listen: false,
    ).getTicket;
    final violationProvider = Provider.of<ViolationProvider>(
      context,
      listen: false,
    );
    final dateFormatter = DateFormat("yyyy-MM-dd hh:mm:ss");

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
        content: "Traffic Violation Ticket",
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
        content: dateFormatter.format(DateTime.now()),
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            "Name:\n  ${ticket.firstName ?? 'N/A'} ${ticket.middleName ?? ''} ${ticket.lastName ?? ""}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Address:\n  ${ticket.address ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "License Number:\n  ${ticket.licenseNumber ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Plate Number:\n  ${ticket.plateNumber ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Vehicle Type:\n  ${ticket.vehicleType ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Place of Violation:\n  ${ticket.placeOfViolation ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            "Date and Time of Violation:\n  ${ticket.violationDateTime ?? "N/A"}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Enforcer ID:\n  ${ticket.enforcerId}",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 2,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "Violations:",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );

    final driverViolations =
        violationProvider.getViolations.where((element) => element.isSelected);

    for (final violation in driverViolations) {
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "  ${violation.name}",
          weight: 2,
          height: 2,
          width: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: " PHP ${violation.fine}",
          weight: 2,
          height: 2,
          width: 2,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ),
      );
    }

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "\n\n",
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
