import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../home/views/home_view.dart';
import '../widgets/complete_and_sotore_user_data.dart';

void navigationControler(BuildContext context, String id) async {
  User? user = FirebaseAuth.instance.currentUser;
  String uid = user!.uid;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('doc', isEqualTo: uid)
      .get();

  if (querySnapshot.docs.isEmpty) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteAndStorUserData(userId: id),
        ));
  } else {
    Navigator.pushReplacementNamed(context, HomeView.id);
  }
}
