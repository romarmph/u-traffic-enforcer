import '../config/utils/exports.dart';

class EnforcerDBHelper {
  EnforcerDBHelper._();

  static final EnforcerDBHelper _instance = EnforcerDBHelper._();

  static EnforcerDBHelper get instance => _instance;

  final String _enforcersCollection = "enforcers";
  final _firebase = FirebaseFirestore.instance;

  Stream<Enforcer> getCurrentEnforcer(String uid) {
    final doc = _firebase.collection(_enforcersCollection).doc(uid).snapshots();

    return doc.map((event) => Enforcer.fromJson(
          event.data()!,
          event.id,
        ));
  }
}
