import '../config/utils/exports.dart';

class EnforcerProvider extends ChangeNotifier {
  var _enforcer = const Enforcer(
    firstName: "",
    middleName: "",
    lastName: "",
    email: "",
  );

  Enforcer get enforcer => _enforcer;

  void setEnforcer(Enforcer enforcer) {
    _enforcer = enforcer;
    notifyListeners();
  }
}
