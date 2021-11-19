import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/models/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final usersCollection = _firestore.collection('users');
// class Auth {
final _auth = FirebaseAuth.instance;

Stream<User?> get user {
  return _auth.authStateChanges();
}

Future<void> signup(String email, String password, String userType) async {
  try {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await usersCollection.doc(authResult.user!.uid).set({
      'email': '${authResult.user!.email}',
      'userType': '$userType',
    });
    print('signup success');
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.code);
  }
}

Future<void> login(String email, String password, String userType) async {
  try {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    // authResult.
    // TODO check usertype and show diff UI based on screen, maybe use provider again :/
    usersCollection.doc(authResult.user!.uid).get().then(
      (doc) {
        // if (doc.exists) {
        //   print('doc exists');
        //   // String type = doc.get('userType') as String;
        //   // print(type);
        //   // if (type != userType) {}
        // }
        // if (!doc.exists) print('doc not exists');
        String type = doc.get('userType') as String;
        print(type);
        if (type != userType)
          throw AuthException("not registered with $userType user type!");
      },
    );
    print('login success');
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.code);
  } on StateError catch (_) {
    throw AuthException("user does not exist!");
  } on AuthException catch (e) {
    throw AuthException(e.toString());
  } finally {
    logout();
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
