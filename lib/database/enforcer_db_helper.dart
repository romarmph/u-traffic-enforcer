import '../config/utils/exports.dart';

class EnforcerDBHelper {
  EnforcerDBHelper._();

  static EnforcerDBHelper get instance => EnforcerDBHelper._();

  final String _enforcersCollection = "enforcers";
  final _firebase = FirebaseFirestore.instance;

  Future<Enforcer> getEnforcer() async {
    final uid = AuthService().currentUser.id;
    final doc = await _firebase.collection(_enforcersCollection).doc(uid).get();

    return Enforcer.fromJson(doc.data()!);
  }
}
