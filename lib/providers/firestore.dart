import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as path;

// class FireStoreDB {
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

/// Storing res details in collection named restaurants in firestore
/// Storing res images in res_images folder in cloud storage
/// with user uid as image name
Future<void> addRes({
  required String name,
  required String desc,
  required String website,
  required String openTime,
  required String closeTime,
  required File img,
}) async {
  final String uid = _auth.currentUser!.uid;
  final resCollection = _firestore.collection('restaurants');
  String fileExt = path.extension(img.path);
  final ref = _storage.ref().child('res_images').child('$uid$fileExt');

  await ref.putFile(img);

  final url = await ref.getDownloadURL();

  await resCollection.doc(uid).set(
    <String, String>{
      'resName': name,
      'desc': desc,
      'website': website,
      'openTime': openTime,
      'closeTime': closeTime,
      'imageUrl': url,
    },
  );

  log('res added!');
}
// }
