import '../config/utils/exports.dart';

class UTrafficImageProvider extends ChangeNotifier {
  String _licenseImagePath = "";
  String _signatureImagePath = "";
  List<String> _vehicleImagePath = [];
  List<String> _locationImagePath = [];

  String get licenseImagePath => _licenseImagePath;
  String get signatureImagePath => _signatureImagePath;
  List<String> get vehicleImagePath => _vehicleImagePath;
  List<String> get locationImagePath => _locationImagePath;

  void setLicenseImagePath(String path) {
    _licenseImagePath = path;
    notifyListeners();
  }

  void setSignatureImagePath(String path) {
    _signatureImagePath = path;
    notifyListeners();
  }

  void setVehicleImagePaths(List<String> path) {
    _vehicleImagePath = path;
    notifyListeners();
  }

  void setLocationImagePaths(List<String> path) {
    _locationImagePath = path;
    notifyListeners();
  }

  void resetLicense() {
    _licenseImagePath = "";
    notifyListeners();
  }

  void resetSignature() {
    _signatureImagePath = "";
    notifyListeners();
  }

  void resetVehicle() {
    _vehicleImagePath = [];
    notifyListeners();
  }

  void resetLocation() {
    _locationImagePath = [];
    notifyListeners();
  }

  void reset() {
    _licenseImagePath = "";
    _signatureImagePath = "";
    _vehicleImagePath = [];
    _locationImagePath = [];
    notifyListeners();
  }
}
