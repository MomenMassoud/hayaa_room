import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> wearBadges(List<String> selectedBadges) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  await firestore
      .collection("user")
      .doc(auth.currentUser!.uid)
      .update({"wearingBadges": selectedBadges});
  log("Wearing Badges");
}
