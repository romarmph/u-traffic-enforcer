import '../config/utils/exports.dart';

class EnforcerDBHelper {
  EnforcerDBHelper._();

  static final EnforcerDBHelper _instance = EnforcerDBHelper._();

  static EnforcerDBHelper get instance => _instance;

  final String _enforcersCollection = "enforcers";
  final _firebase = FirebaseFirestore.instance;

  Future<Enforcer> getEnforcer() async {
    final uid = AuthService().currentUser.uid;
    final doc = await _firebase.collection(_enforcersCollection).doc(uid).get();

    return Enforcer.fromJson(
      doc.data()!,
      doc.id,
    );
  }
}
