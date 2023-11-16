import '../../../config/utils/exports.dart';

class PrinterProvider extends ChangeNotifier {
  BluetoothDevice _printer = BluetoothDevice();

  BluetoothDevice get getPrinter => _printer;

  void selectDevice(BluetoothDevice device) {
    _printer = device;
    notifyListeners();
  }
}

final printerProvider = ChangeNotifierProvider<PrinterProvider>((ref) {
  return PrinterProvider();
});
