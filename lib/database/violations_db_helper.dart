import '../../config/utils/exports.dart';

class ViolationsDatabase {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Violation>> getViolationsStream() {
    return _firestore.collection('violations').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Violation.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }
}
