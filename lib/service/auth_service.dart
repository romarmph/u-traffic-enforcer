import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../model/enforcer.dart';
import '../model/user.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

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

  Future<Enforcer?> getEnforcer(String email) async {
    const String collection = "enforcers";
    const String field = "email";

    final firestore.QuerySnapshot<Map<String, dynamic>> result =
        await _db.collection(collection).where(field, isEqualTo: email).get();

    if (result.docs.isEmpty) {
      return null;
    }

    Enforcer enforcer =
        Enforcer.fromJson(result.docs.first as Map<String, dynamic>);

    return enforcer;
  }

  Future<User?> signInWithEmailAndPassword({
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
