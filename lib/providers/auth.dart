import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/models/auth_exception.dart';

// class Auth {
final _auth = FirebaseAuth.instance;

Stream<User?> get user {
  return _auth.authStateChanges();
}

Future<void> signup(String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print('signup success');
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.code);
  }
}

Future<void> login(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    print('login success');
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.code);
  }
}

Future<bool> logout() async {
  try {
    await _auth.signOut();
    return true;
  } on FirebaseAuthException catch (e) {
    print(e.code);
    return false;
  }
}
// }
