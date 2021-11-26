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
Future<String> addRes({
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

  final doc = resCollection.doc(uid);
  final docStatus = await doc.get();

  if (docStatus.exists)
    await doc.update(
      <String, String>{
        'resName': name,
        'desc': desc,
        'website': website,
        'openTime': openTime,
        'closeTime': closeTime,
        'imageUrl': url,
        'rating': '1',
      },
    );
  else
    await doc.set(
      <String, String>{
        'resName': name,
        'desc': desc,
        'website': website,
        'openTime': openTime,
        'closeTime': closeTime,
        'imageUrl': url,
        'rating': '1',
      },
    );
  log('res added!');
  return uid;
}

Future<void> addResRating(String uid, String rating) async {
  final resCollection = _firestore.collection('restaurants');
  final doc = resCollection.doc(uid);
  await doc.update(
    {
      'rating': rating,
    },
  );
}

Future<String> getResRating(String uid) async {
  final resCollection = _firestore.collection('restaurants');
  final doc = resCollection.doc(uid);
  final data = await doc.get();
  return data['rating'];
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getResRatingSync(String uid) {
  final resCollection = _firestore.collection('restaurants');
  final doc = resCollection.doc(uid);
  return doc.snapshots();
  // final data = await doc.get();
  // return data['rating'];
}

Future<List<String>> getRes() async {
  final String uid = _auth.currentUser!.uid;
  final resCollection = _firestore.collection('restaurants');

  final doc = await resCollection.doc(uid).get();
  if (!doc.exists || !doc.data()!.containsKey('resName')) {
    log('no doc');
    return ['none'];
  }

  final Map<String, dynamic> resData = doc.data()!;

  // for (var item in doc.data()!.entries) {

  // print(resData['resName']);
  // print(resData['desc']);
  // print(resData['website']);
  // print(resData['openTime']);
  // print(resData['closeTime']);
  // print(resData['imageUrl']);
  // print(resData['rating']);
  // print(doc.id);
  // }

  return [
    resData['resName'], // 0
    resData['desc'], // 1
    resData['website'], // 2
    resData['openTime'], // 3
    resData['closeTime'], // 4
    resData['imageUrl'], // 5
    doc.id, // 6
    if (resData.containsKey('phone')) resData['phone'], // 7
    if (!resData.containsKey('phone')) '', // 7
    resData['rating'], // 8
  ];
}

Future<void> addResPhone(String phone) async {
  final String uid = _auth.currentUser!.uid;
  final resCollection = _firestore.collection('restaurants');

  final doc = resCollection.doc(uid);

  final docStatus = await doc.get();
  if (docStatus.exists)
    await doc.update({
      'phone': phone,
    });
  else
    await doc.set({
      'phone': phone,
    });
}

Future<void> addCusPhone(String phone) async {
  final String uid = _auth.currentUser!.uid;
  final usersCollection = _firestore.collection('users');

  final doc = usersCollection.doc(uid);
  await doc.update({
    'phone': phone,
  });

  log('cus phone added');
}

Future<String> getCusPhone() async {
  final String uid = _auth.currentUser!.uid;
  final usersCollection = _firestore.collection('users');

  final doc = usersCollection.doc(uid);
  final data = await doc.get();
  // print(data.data()!['phone']);
  return data.data()!['phone'];
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

Future<List<Map<String, dynamic>>> fetchAllMeals() async {
  final usersCollection = _firestore.collection('users');
  final mealsCollection = _firestore.collection('meals');
  final favoritesCollection = _firestore.collection('favorites');

  /// contains the ids used to access
  /// the docs inside meals collection
  /// basically res names
  List<String> restaurants = [];

  /// each index represents one restaurant
  /// each index is a list of meals
  /// each meal is a Map itself
  List<Map<String, dynamic>> meals = [];

  final resUsers =
      await usersCollection.where('userType', isEqualTo: 'restaurant').get();
  resUsers.docs.forEach(
    (res) {
      // print(res.id);
      restaurants.add(res.id);
    },
  );

  // print('restaurants data');
  // restaurants.forEach((element) {
  //   print(element);
  // });

  /// contains the doc ids of a meal in menu collection

  for (var res in restaurants) {
    var menu = await mealsCollection.doc(res).collection('menu').get();

    // print('res $res menu datas: ');
    await Future.forEach(menu.docs,
        (QueryDocumentSnapshot<Map<String, dynamic>> meal) async {
      var data;
      bool? fav;
      data = await favoritesCollection.doc(_auth.currentUser!.uid).get();
      if (data.exists) fav = data.data()[meal.id];
      if (fav == null) fav = false;

      meals.add({
        'resName': meal.data()['resName'],
        'mealName': meal.data()['mealName'],
        'price': meal.data()['price'],
        'imageUrl': meal.data()['imageUrl'],
        'ingredients': meal.data()['ingredients'],
        'mealId': meal.id,
        'favorite': fav,
      });
    });
    // meals.add(meals);
    // resMeals.;
  }

  // meals.forEach((element) {
  //   print(element['mealName']);
  // });
  // print('ending all res fetch');
  return meals;
}

Future<List<Map<String, String>>> fetchAllRes() async {
  final resCollection = _firestore.collection('restaurants');

  List<Map<String, String>> res = [];

  final resDocs = await resCollection.get();

  // res.forEach((r) {
  //   r.entries.toList().forEach((element) {
  //     print(element);
  //   });
  resDocs.docs.forEach((doc) {
    final data = doc.data();
    res.add({
      'resName': data['resName'],
      'openTime': data['openTime'],
      'closeTime': data['closeTime'],
      'imageUrl': data['imageUrl'],
      'id': doc.id,
      'rating': data['rating'],
    });
  });

  // print('from firestore');
  // res.forEach((r) {
  //   r.entries.toList().forEach((element) {
  //     print(element);
  //   });
  //   print('');
  // });
  return res;
}

// ? meals are added to list after the function returns causing to reload twice
// ? this is because in all res function after adding it jumps to next line
// ? which is again the for loop and hence it returns the meals list with meals
// ? here after the adding the meals there is a return statement and it returns immediately
// ? have to stop the return before adding the meals somehow
// ? maybe
// ? update : bug fixed using Future.forEach()

/// returns a list with length 0 if no meals
/// otherwise returns a list with all meals (each meal is Map)
Future<List<Map<String, dynamic>>> fetchSingleResMeals([String? resId]) async {
  final mealsCollection = _firestore.collection('meals');
  final favoritesCollection = _firestore.collection('favorites');
  List<Map<String, dynamic>> meals = [];

  final menu = await mealsCollection
      .doc(resId ?? _auth.currentUser!.uid)
      .collection('menu')
      .get();
  // int i = 0;
  // if (menu.size > 0) {
  // print('inside if');
  // menu.docs.forEach((meal) async {
  //     print('inside for each');
  //     var data;
  //     bool? fav;
  //     data = await favoritesCollection.doc(_auth.currentUser!.uid).get();
  //     if (data.exists) fav = data.data()[meal.id];
  //     if (fav == null) fav = false;

  //     meals.add({
  //       'resName': meal.data()['resName'],
  //       'mealName': meal.data()['mealName'],
  //       'price': meal.data()['price'],
  //       'imageUrl': meal.data()['imageUrl'],
  //       'ingredients': meal.data()['ingredients'],
  //       'mealId': meal.id,
  //       'favorite': fav,
  //     });
  //     print('added ${meals[i]['mealName']}');
  //     i++;
  //   });
  // }

  await Future.forEach(menu.docs,
      (QueryDocumentSnapshot<Map<String, dynamic>> meal) async {
    var data;
    bool? fav;
    data = await favoritesCollection.doc(_auth.currentUser!.uid).get();
    if (data.exists) fav = data.data()[meal.id];
    if (fav == null) fav = false;

    meals.add({
      'resName': meal.data()['resName'],
      'mealName': meal.data()['mealName'],
      'price': meal.data()['price'],
      'imageUrl': meal.data()['imageUrl'],
      'ingredients': meal.data()['ingredients'],
      'mealId': meal.id,
      'favorite': fav,
    });
  });
  // meals.forEach((element) {
  //   print(element['mealName']);
  // });
  // print('meals.length: ${meals.length}');
  // print('ending single res fetch');
  // await task;

  return meals;
}

Future<bool> deleteMeal(String mealId) async {
  final mealsCollection = _firestore.collection('meals');
  try {
    await mealsCollection
        .doc(_auth.currentUser!.uid)
        .collection('menu')
        .doc(mealId)
        .delete();
    // .get();
    return true;
  } on Exception catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> toggleFavorite(String mealId) async {
  final String cusUid = _auth.currentUser!.uid;
  final favoritesCollection = _firestore.collection('favorites');

  final doc = favoritesCollection.doc(cusUid);
  final status = await doc.get();
  bool curr;
  if (status.exists) {
    bool? prev = status.data()![mealId];
    if (prev == null) prev = false;
    doc.update({
      mealId: !prev,
    });
    curr = !prev;
  } else {
    doc.set({
      mealId: true,
    });
    curr = true;
  }

  return curr;
}

Future<List<Map<String, dynamic>>> fetchCusFavMeals() async {
  final String cusUid = _auth.currentUser!.uid;
  final usersCollection = _firestore.collection('users');
  final mealsCollection = _firestore.collection('meals');
  final favoritesCollection = _firestore.collection('favorites');
  List<Map<String, dynamic>> favMeals = [];

  final doc = await favoritesCollection.doc(cusUid).get();

  List<String> favs = [];
  // print('fav meals');
  final docData = doc.data();
  if (docData == null) // no favs exist of this user
  {
    // print('returning');
    return favMeals;
  } else {
    // docData.removeWhere((key, value) => value == false);
    // print('else');
    docData.entries.forEach((element) {
      if (element.value == true) {
        // print('adding ${element.key}');

        favs.add(element.key);
      }
    });
  }

  List<String> restaurants = [];
  final resUsers =
      await usersCollection.where('userType', isEqualTo: 'restaurant').get();
  resUsers.docs.forEach(
    (res) {
      // print(res.id);
      restaurants.add(res.id);
    },
  );
  // final allRes = await mealsCollection.get(GetOptions(source: Source.server));

  // print(allRes.docs);
  // print('size:' + allRes.size.toString());

  // List<String> rests = [];
  // await Future.forEach(allRes.docs,
  //     (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  //   print('doc.id: ${doc.id}');
  //   rests.add(doc.id);
  // });
  // print(rests.length);
  // print('between');
  for (var rests in restaurants) {
    var meals = await mealsCollection.doc(rests).collection('menu').get();
    // await Future.forEach(rests, (String res) async {
    //   print(res);
    await Future.forEach(meals.docs,
        (QueryDocumentSnapshot<Map<String, dynamic>> meal) {
      // print(meal.id);
      if (favs.contains(meal.id)) {
        // print(meal.data()['mealName']);
        favMeals.add(
          {
            'resName': meal.data()['resName'],
            'mealName': meal.data()['mealName'],
            'price': meal.data()['price'],
            'imageUrl': meal.data()['imageUrl'],
            'ingredients': meal.data()['ingredients'],
            'mealId': meal.id,
          },
        );
      }
    });
  }
  // });
  // print('returning');
  return favMeals;
}
// ?resuse this logic for customer restaurant view
/*
Future<List<List<Map<String, dynamic>>>> fetchAllMeals() async {
  final usersCollection = _firestore.collection('users');
  final mealsCollection = _firestore.collection('meals');

  /// contains the ids used to access
  /// the docs inside meals collection
  /// basically res names
  List<String> restaurants = [];

  /// each index represents one restaurant
  /// each index is a list of meals
  /// each meal is a Map itself
  List<List<Map<String, dynamic>>> meals = [];

  final resUsers =
      await usersCollection.where('userType', isEqualTo: 'restaurant').get();
  resUsers.docs.forEach(
    (res) {
      // print(res.id);
      restaurants.add(res.id);
    },
  );

  // print('restaurants data');
  // restaurants.forEach((element) {
  //   print(element);
  // });

  /// contains the doc ids of a meal in menu collection

  for (var res in restaurants) {
    List<Map<String, dynamic>> resMeals = [];
    var menu = await mealsCollection.doc(res).collection('menu').get();

    // print('res $res menu datas: ');
    menu.docs.forEach((meal) {
      // print(meal.data());
      resMeals.add({
        'resName': meal.data()['resName'],
        'mealName': meal.data()['mealName'],
        'price': meal.data()['price'],
        'imageUrl': meal.data()['imageUrl'],
        'ingredients': meal.data()['ingredients'],
      });
    });
    meals.add(resMeals);
    // resMeals.;
  }

//! imp prints below DO NOT REMOVE
  // print('all meals: ${meals.length}');
  // // print(meals);
  // for (var item in meals) {
  //   // print('item: ${item.length}');
  //   item.forEach((element) {
  //     print(element['mealName']);
  //     print(element['ingredients']);
  //   });
  // }

  return meals;
}
 */
// }
