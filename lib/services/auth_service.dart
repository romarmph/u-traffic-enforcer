import '../config/utils/exports.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
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

    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> updatePassword(String newPassword, String oldPassword) async {
    final User currentUser = _firebaseAuth.currentUser!;

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: currentUser.email!,
      password: oldPassword,
    );

    await userCredential.user!.updatePassword(newPassword);
  }
}
