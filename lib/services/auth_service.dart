import '../config/utils/exports.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return user;
  }

  User get currentUser {
    return _userFromFirebase(_firebaseAuth.currentUser)!;
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<Enforcer?> getEnforcer(String email) async {
    const String collection = "enforcers";
    const String field = "email";

    final QuerySnapshot<Map<String, dynamic>> result =
        await _db.collection(collection).where(field, isEqualTo: email).get();

    if (result.docs.isEmpty) {
      return null;
    }

    Enforcer enforcer = Enforcer.fromJson(
      result.docs.first.data(),
      result.docs.first.id,
    );

    return enforcer;
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await getEnforcer(email) == null) {
      throw Exception("account-not-enforcer");
    }

    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
