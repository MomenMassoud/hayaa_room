import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/vip%20center/functions/vip_buying_error.dart';
import 'package:hayaa_main/features/vip%20center/functions/vip_buying_succssfully.dart';

void buyingVip(
    {required int myCoins,
    required int price,
    required String myVip,
    required String sectionVip,
    required int myExp,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required BuildContext context}) async {
  DateTime now = DateTime.now();
  int month = now.month + 1;

  DateTime end = DateTime(now.year, month, now.day, now.hour, now.minute,
      now.second, now.millisecond, now.microsecond);

  if (myCoins >= price) {
    myCoins = myCoins - price;
    if (myVip == "1") {
      myExp = myExp + (price * 1.15).toInt();
    } else if (myVip == "2") {
      myExp = myExp + (price * 1.125).toInt();
    } else if (myVip == "3") {
      myExp = myExp + (price * 1.50).toInt();
    } else if (myVip == "4") {
      myExp = myExp + (price * 1.75).toInt();
    } else {
      myExp = myExp + price;
    }

    firestore.collection("user").doc(auth.currentUser!.uid).update({
      'vip': sectionVip,
      'vip_end': end.toString(),
      'coin': myCoins.toString(),
      'exp': myExp.toString()
    }).then((value) {
      firestore
          .collection("user")
          .doc(auth.currentUser!.uid)
          .collection("mybadges")
          .doc("vip$sectionVip")
          .set({"id": "vip$sectionVip"});
      vipBuyingSuccesfully(context);
      firestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .collection('payment')
          .doc()
          .set({
        'date': DateTime.now().toString(),
        'type': 'coin',
        'pay': 'out',
        'value': price,
        'bio': 'vip1'
      });
    });
  } else {
    vipBuyingError(context);
  }
}
