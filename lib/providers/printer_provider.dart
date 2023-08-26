import '../../../config/utils/exports.dart';

class PrinterProvider extends ChangeNotifier {
  final BluetoothPrint _device = BluetoothPrint.instance;
  BluetoothDevice _printer = BluetoothDevice();

  BluetoothDevice get getPrinter => _printer;

  void selectDevice(BluetoothDevice device) {
    _printer = device;
    notifyListeners();
  }
}
