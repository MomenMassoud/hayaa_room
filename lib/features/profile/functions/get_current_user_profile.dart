import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/user_model.dart';

Future<UserModel> getCurrentUserProfileData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel;
  if (auth.currentUser!.email == null) {
    QuerySnapshot qurySnapShot = await firestore
        .collection("user")
        .where('email', isEqualTo: auth.currentUser!.phoneNumber)
        .get();
    final json = qurySnapShot.docs[0].data() as Map<String, dynamic>;
    userModel = UserModel.fromJson(json);
    final lastSeen = json["seen"];
    if (lastSeen is Timestamp) {
      final DateTime dateTime = lastSeen.toDate();
      userModel.seen = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }
    userModel.level2 = json["level2"];
    userModel.docID = json["doc"];
    userModel.wearingBadges = json["wearingBadges"] ?? [];
  } else {
    QuerySnapshot qurySnapShot = await firestore
        .collection("user")
        .where('email', isEqualTo: auth.currentUser!.email)
        .get();
    final json = qurySnapShot.docs[0].data() as Map<String, dynamic>;
    userModel = UserModel.fromJson(json);
    final lastSeen = json["seen"];
    if (lastSeen is Timestamp) {
      final DateTime dateTime = lastSeen.toDate();
      userModel.seen = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }
    userModel.level2 = json["level2"];
    userModel.docID = json["doc"];
    userModel.wearingBadges = json["wearingBadges"] ?? [];
    userModel.acualCountry = json["acualCountry"];
  }
  log(userModel.country);
  return userModel;
}
