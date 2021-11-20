import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flex/models/auth_exception.dart';

final _firestore = FirebaseFirestore.instance;
final usersCollection = _firestore.collection('users');
enum AuthStatus { loggedIn, SignedOut }

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var _authStatus = AuthStatus.SignedOut;

  bool get isAuth {
    // _user.listen(
    //   (user) {
    //     if (user != null)
    //       authStatus = true;
    //     else
    //       authStatus = false;
    //   },
    // );
    return _authStatus == AuthStatus.loggedIn;
  }

  // Stream<User?> get _user {
  //   return _auth.authStateChanges();
  // }

  Future<void> signup(String email, String password, String userType) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await usersCollection.doc(authResult.user!.uid).set({
        'email': '${authResult.user!.email}',
        'userType': '$userType',
      });
      print('signup success');
      _authStatus = AuthStatus.loggedIn;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  Future<void> login(String email, String password, String userType) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final doc = await usersCollection.doc(authResult.user!.uid).get();
      // .then(
      //   (doc) {
      // if (doc.exists) {
      //   print('doc exists');
      //   // String type = doc.get('userType')
      // String;
      //   // print(type);
      //   // if (type != userType) {}
      // }
      // if (!doc.exists) print('doc not exists');
      String type = doc.get('userType') as String;
      print(type);
      if (type != userType)
        throw AuthException("not registered with $userType user type!");
      else {
        _authStatus = AuthStatus.loggedIn;
        notifyListeners();
        print('login success');
        print('auth status: ' + _authStatus.toString());
      }
      // },
      // ).onError((error, stackTrace) => throw AuthException(error.toString()));
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } on StateError catch (_) {
      throw AuthException("user does not exist!");
    } on AuthException catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _authStatus = AuthStatus.SignedOut;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
