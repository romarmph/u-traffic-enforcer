import '../../config/utils/exports.dart';

class DeviceScanPage extends StatefulWidget {
  const DeviceScanPage({super.key});

  @override
  State<DeviceScanPage> createState() => DeviceScanPageState();
}

class DeviceScanPageState extends State<DeviceScanPage> {
  final _bluetooth = BluetoothPrint.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => initPrinter(),
    );
  }

  Future<void> initPrinter() async {
    try {
      _bluetooth.startScan(timeout: const Duration(seconds: 2));
    } catch (e) {
      // ignore: avoid_print
      print("Couldn't start scan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Printer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space12),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<BluetoothDevice>>(
                stream: _bluetooth.scanResults,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No devices found"),
                    );
                  }

                  List<BluetoothDevice> devices = snapshot.data!;

                  return ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      if (devices.isEmpty) {
                        return const Center(
                          child: Text(
                            'No device found',
                          ),
                        );
                      }

                      BluetoothDevice device = devices[index];

                      return ListTile(
                        leading: const Icon(Icons.print_rounded),
                        title: Text(
                          device.name!,
                        ),
                        onTap: () async {
                          if (device.address != null) {
                            try {
                              final success = await _bluetooth.connect(device);

                              if (success) {
                                await showSuccessDialog();
                                insertDevice(device);
                              } else {
                                await showErrorDialog();
                              }
                            } on Exception catch (e) {
                              // ignore: avoid_print
                              print(e);
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _bluetooth.startScan(
                  timeout: const Duration(seconds: 2),
                );
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }

  void insertDevice(BluetoothDevice device) {
    Provider.of<PrinterProvider>(
      context,
      listen: false,
    ).selectDevice(device);
    Navigator.of(context).pop();
  }

  Future showSuccessDialog() async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: "Printer connected!",
    );
  }

  Future showErrorDialog() async {
    return await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: "Couldn't connect to device. Please try again",
    );
  }
}
