import 'package:flutter/foundation.dart';

class Restaurant extends ChangeNotifier {
  String? _docId;
  String? _resName;
  String? _email;
  String? _phone;
  String? _website;
  String? _desc;
  String? _openTime;
  String? _closeTime;
  String? _imageUrl;
  String? _rating;

  // Restaurant({
  //   required this.docId,
  //   required this.resName,
  //   required this.website,
  //   required this.desc,
  //   required this.openTime,
  //   required this.closeTime,
  //   required this.imageUrl,
  // });
  void addRes({
    required String docId,
    required String resName,
    required String website,
    required String desc,
    required String openTime,
    required String closeTime,
    required String imageUrl,
    String? email,
    String? phone,
    String? rating,
  }) {
    this._docId = docId;
    this._resName = resName;
    this._website = website;
    this._desc = desc;
    this._openTime = openTime;
    this._closeTime = closeTime;
    this._imageUrl = imageUrl;
    this._email = _email;
    this._phone = _phone;
    this._rating = rating;
    notifyListeners();
  }

  Map<String, String?> get resData {
    return {
      'resName': _resName,
      'phone': _phone,
    };
  }

  String? get rating {
    return this._rating;
  }

  set resPhone(String phone) {
    this._phone = phone;
    notifyListeners();
  }
}
