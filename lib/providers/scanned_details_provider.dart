import 'package:u_traffic_enforcer/config/utils/exports.dart';

class ScannedDetails extends ChangeNotifier {
  Map<String, dynamic> _details = {};

  Map<String, dynamic> get details => _details;

  void setDetails(Map<String, dynamic> details) {
    _details = details;
    notifyListeners();
  }

  void clearDetails() {
    try {
      _details = {};
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void onChange(String key, String value) {
    _details[key] = value;
    notifyListeners();
  }
}
