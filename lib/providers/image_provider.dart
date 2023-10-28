import '../config/utils/exports.dart';

class LicenseImageProvider extends ChangeNotifier {
  String _licenseImagePath = "";

  String get licenseImagePath => _licenseImagePath;

  void setLicenseImagePath(String path) {
    _licenseImagePath = path;
    notifyListeners();
  }

  void resetLicense() {
    _licenseImagePath = "";
    notifyListeners();
  }
}
