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
  List<BluetoothDevice> _devices = [];
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
    if (!mounted) return;
    _bluetooth.scanResults.listen((devices) {
      if (!mounted) return;
      setState(() {
        _devices = devices;
      });
    });
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
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  if (_devices.isEmpty) {
                    return const Center(
                      child: Text(
                        'No device found',
                      ),
                    );
                  }

                  BluetoothDevice device = _devices[index];

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
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _bluetooth.scan();
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
