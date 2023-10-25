import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EvidenceProvider extends ChangeNotifier {
  final List<Evidence> _evidences = [];
  List<Evidence> get evidences => _evidences;

  void addEvidence(Evidence evidence) {
    _evidences.add(evidence);
    notifyListeners();
  }

  void removeEvidence(Evidence evidence) {
    _evidences.remove(evidence);
    notifyListeners();
  }

  void removeEvidenceByID(String id) {
    _evidences.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void clearEvidences() {
    _evidences.clear();
    notifyListeners();
  }
}
