import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';

class PrinterProvider extends ChangeNotifier {
  BluetoothDevice _printer = BluetoothDevice();

  BluetoothDevice get getPrinter => _printer;

  void selectDevice(BluetoothDevice device) {
    _printer = device;
    notifyListeners();
  }
}
