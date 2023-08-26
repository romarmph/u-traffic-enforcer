import '../../../config/utils/exports.dart';

class ViolationProvider extends ChangeNotifier {
  final _violationsDatabase = ViolationsDatabase();
  List<Violation> _violationsList = [];

  List<Violation> get getViolations => _violationsList;

  void listenToViolations() {
    _violationsDatabase.getViolationsStream().listen((violations) {
      _violationsList = violations;
      notifyListeners();
    });
  }

  void selectViolation(String id) {
    final int index = _violationsList.indexWhere((Violation v) => v.id == id);
    _violationsList[index].isSelected =
        _violationsList[index].isSelected ? false : true;

    notifyListeners();
  }
}
