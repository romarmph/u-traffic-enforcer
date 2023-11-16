import 'package:intl/intl.dart';

import '../../../config/utils/exports.dart';

class PrinterHome extends ConsumerStatefulWidget {
  const PrinterHome({super.key});

  @override
  ConsumerState<PrinterHome> createState() => _PrinterHomeState();
}

class _PrinterHomeState extends ConsumerState<PrinterHome> {
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
                  return FutureBuilder(
                    future: _printer.isConnected,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!) {
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

                goPrinterScanner();
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

  void showTurnOnBluetoothAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Turn on bluetooth",
      text: "Please turn on bluetooth to connect to printer.",
    );
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

    final ticket = ref.watch(ticketChangeNotifierProvider).ticket;

    final vehicleType = ref.watch(vehicleTypeProvider);

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
        content: "Name:\n  ${ticket.driverName}",
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
        content: "Address:\n  ${ticket.address}",
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
        content: "License Number:\n  ${ticket.licenseNumber}",
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
            "Plate Number:\n  ${ticket.plateNumber!.isEmpty ? 'N/A' : ticket.plateNumber}",
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
        content: "Vehicle Type:\n  $vehicleType",
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
        content: "Place of Violation:\n  ${ticket.violationPlace.address}",
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
            "Date and Time of Violation:\n  ${ticket.violationDateTime.toAmericanDate} ${ticket.violationDateTime.toTime}",
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
            "Ticket Due Date:\n  ${ticket.violationDateTime.getDueDate.toAmericanDate}",
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
        content: "Enforcer:\n  ${ticket.enforcerName}\n",
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
        content: "Violations:",
        weight: 2,
        height: 2,
        width: 2,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );

    final List<IssuedViolation> driverViolations = ticket.issuedViolations;
    final List<Violation> violations = ref.watch(violationsListProvider);

    for (final violation in driverViolations) {
      final name = violations
          .firstWhere(
            (element) => element.id == violation.violationID,
          )
          .name;
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "  $name",
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
        content: "--------------------------------",
        width: 2,
        weight: 2,
        linefeed: 1,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "TOTAL FINE:",
        weight: 4,
        height: 4,
        width: 4,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: _getFineTotal(driverViolations).toString(),
        weight: 4,
        height: 4,
        width: 4,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "\n\n",
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_BARCODE,
        content: _formatTicketNumber(ticket.ticketNumber!),
        align: LineText.ALIGN_CENTER,
        width: 4,
        height: 4,
        linefeed: 1,
        weight: 4,
      ),
    );

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "\n\n",
      ),
    );

    await _printer.printReceipt(config, list);
  }

  String _formatTicketNumber(int number) {
    return number.toString().padLeft(12, '0');
  }

  int _getFineTotal(List<IssuedViolation> violations) {
    int total = 0;

    for (var element in violations) {
      total += element.fine;
    }
    return total;
  }
}
