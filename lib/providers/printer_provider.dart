import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';

class PrinterProvider extends ChangeNotifier {
  final BluetoothPrint _device = BluetoothPrint.instance;
  BluetoothDevice _printer = BluetoothDevice();

  BluetoothDevice get getPrinter => _printer;

  void selectDevice(BluetoothDevice device) {
    _printer = device;
    notifyListeners();
  }

  Stream<bool?> get isConnected async* {
    yield await _device.isConnected;
    // Hack :D
    notifyListeners();
  }
}
