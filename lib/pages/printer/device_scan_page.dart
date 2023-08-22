import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/themes/spacing.dart';
import '../../providers/printer_provider.dart';

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
    _bluetooth.startScan(timeout: const Duration(seconds: 2));
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
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
                      _bluetooth.state.listen((state) {});

                      return ListTile(
                        leading: const Icon(Icons.print_rounded),
                        title: Text(
                          device.name!,
                        ),
                        onTap: () async {
                          if (device.address != null) {
                            await _bluetooth.connect(device);
                            insertDevice(device);
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
}
