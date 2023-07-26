import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../model/user.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(
      id: user.uid,
      email: user.email!,
    );
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth.UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(userCredential.user);
  }

  Future<User?> createUserWithEmailAndPassword({
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
