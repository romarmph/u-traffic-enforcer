import '../../config/utils/exports.dart';

class ViolationsDatabase {
  const ViolationsDatabase._();

  static const ViolationsDatabase _instance = ViolationsDatabase._();
  static ViolationsDatabase get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;

  Stream<List<Violation>> getViolationsStream() {
    return _firestore.collection('violations').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Violation.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<List<Violation>> getViolations() async {
    final snapshot =
        await _firestore.collection('violations').orderBy('name').get();

    return snapshot.docs
        .map((doc) => Violation.fromJson(doc.data(), doc.id))
        .toList();
  }
}
