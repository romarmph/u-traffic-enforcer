import '../../../config/utils/exports.dart';

class ViolationProvider extends ChangeNotifier {
  final _violationsDatabase = ViolationsDatabase();
  List<Violation> _violationsList = [];

  List<Violation> get getViolations {
    _violationsList
        .sort((a, b) => (b.isSelected ? 1 : 0) - (a.isSelected ? 1 : 0));
    return _violationsList;
  }

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

  void setViolations(List<Violation> violations) {
    _violationsList = violations;
    notifyListeners();
  }
}
