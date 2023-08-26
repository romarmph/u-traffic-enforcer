import '../config/utils/exports.dart' as auth;
import '../config/utils/exports.dart' as firestore;
import '../config/utils/exports.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

  UTrafficUser? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return UTrafficUser(
      id: user.uid,
      email: user.email!,
    );
  }

  UTrafficUser get currentUser {
    return _userFromFirebase(_firebaseAuth.currentUser)!;
  }

  Stream<UTrafficUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<Enforcer?> getEnforcer(String email) async {
    const String collection = "enforcers";
    const String field = "email";

    final firestore.QuerySnapshot<Map<String, dynamic>> result =
        await _db.collection(collection).where(field, isEqualTo: email).get();

    if (result.docs.isEmpty) {
      return null;
    }

    Enforcer enforcer = Enforcer.fromJson(
      result.docs.first.data(),
    );

    return enforcer;
  }

  Future<UTrafficUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await getEnforcer(email) == null) {
      print("Account is not an enforcer");
      return null;
    }

    final auth.UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  Future<UTrafficUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth.UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
