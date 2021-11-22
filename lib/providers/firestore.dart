import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:path/path.dart' as path;

// class FireStoreDB {
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;
final uuid = Uuid();

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

Future<List<String>> getRes() async {
  final String uid = _auth.currentUser!.uid;
  final resCollection = _firestore.collection('restaurants');

  final doc = await resCollection.doc(uid).get();
  if (!doc.exists) {
    log('no doc');
    return ['none'];
  }

  final Map<String, dynamic> resData = doc.data()!;

  // for (var item in doc.data()!.entries) {

  print(resData['resName']);
  print(resData['desc']);
  print(resData['website']);
  print(resData['openTime']);
  print(resData['closeTime']);
  print(resData['imageUrl']);
  // }

  return [
    resData['resName'], // 0
    resData['desc'], // 1
    resData['website'], // 2
    resData['openTime'], // 3
    resData['closeTime'], // 4
    resData['imageUrl'], // 5
  ];
}

Future<void> addMeal({
  required String resName,
  required String mealName,
  required String price,
  required List<String> ingredients,
  required File img,
}) async {
  final String resUid = _auth.currentUser!.uid;
  final mealsCollection = _firestore.collection('meals');
  final String fileExt = path.extension(img.path);
  final String mealUid = uuid.v1();

  /// meal_images/res uid/mealuid.jpg
  final ref = _storage
      .ref()
      .child('meal_images')
      .child('$resUid')
      .child('$mealUid$fileExt');

  await ref.putFile(img);

  final url = await ref.getDownloadURL();

  /// meals / which res (res uid) / meal uid (one meal entry) / meal data
  await mealsCollection.doc(resUid).collection('menu').doc(mealUid).set(
    <String, dynamic>{
      'resName': resName,
      'mealName': mealName,
      'price': price,
      'ingredients': ingredients,
      'imageUrl': url,
    },
  );

  log('meal added!');
}
// }
