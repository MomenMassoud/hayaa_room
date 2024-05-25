import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

vipEndControler() async {
  DateTime currenDate = DateTime.now();
  log("current date is : $currenDate");

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DocumentSnapshot documentSnapshot =
      await firestore.collection("user").doc(auth.currentUser!.uid).get();

  if (documentSnapshot.exists) {
    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    log(userData["vip"]);
    int vipValue = int.parse(userData["vip"]);
    log("vipValue $vipValue");
    if (vipValue != 0) {
      DateTime vipEndDate = DateTime.parse(userData["vip_end"]);
      log("vipEndyear:$vipEndDate");
      List<String> wearingBadgesList = List.from(userData["wearingBadges"]);
      print(wearingBadgesList);
      if (vipValue == 1) {
        wearingBadgesList.remove(
            "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/Badges%2FVIP%201.png?alt=media&token=89f86fe7-bc00-4288-a74a-ef8be7612835");
      } else if (vipValue == 2) {
        wearingBadgesList.remove(
            "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/Badges%2FVIP%202.png?alt=media&token=1a878a81-c3d3-4718-9898-f900861ae025");
      } else if (vipValue == 3) {
        wearingBadgesList.remove(
            "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/Badges%2FVIP%203.png?alt=media&token=2e7f069b-4291-4871-9fdf-212d96c6fb4f");
      } else if (vipValue == 4) {
        wearingBadgesList.remove(
            "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/Badges%2FVIP4.png?alt=media&token=119b4c62-8d02-4fb3-8b7d-26ddc8d0c146");
      }

      print(wearingBadgesList);
      if (currenDate.isAfter(vipEndDate)) {
        firestore.collection("user").doc(auth.currentUser!.uid).update({
          "vip": "0",
          "vip_end": FieldValue.delete(),
          "wearingBadges": wearingBadgesList,
        });

        firestore
            .collection("user")
            .doc(auth.currentUser!.uid)
            .collection("mybadges")
            .doc("vip$vipValue")
            .delete();
      }
    }
  }
}
