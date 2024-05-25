import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

mainRankListCountingControlerInit() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final rankListDurationSnapshot = await firestore
      .collection("ranklistsduration")
      .doc("mainrankduration")
      .get();
  final duraionData = rankListDurationSnapshot.data();
  num day = duraionData?["day"] ?? 0;
  num month = duraionData?["month"] ?? 0;
  Map<String, dynamic> weak = duraionData?['weak'] ?? 0;
  Map<String, dynamic> halfyear = duraionData?['halfyear'] ?? 0;
  num weakstartday = weak["startday"];
  num weakendday = weak["endday"];
  num halfyearstartmonth = halfyear["startmonth"];
  num halfyearendmonth = halfyear["endmonth"];
  log("day:$day");
  log("month:$month");
  log("startoftheweak:$weakstartday");
  log("endoftheweak:$weakendday");
  log("startoftherhalfyear:$halfyearstartmonth");
  log("endoftherhalfyear:$halfyearendmonth");
  DateTime currenDate = DateTime.now();
  num currentDay = int.parse(DateFormat("dd").format(currenDate));
  num currentMonth = int.parse(DateFormat('M').format(currenDate));
  log("currentday:$currentDay");
  log("currentmonth:$currentMonth");
  QuerySnapshot querySnapshot = await firestore.collection("user").get();
  if (day == currentDay &&
      month == currentMonth &&
      currentDay >= weakstartday &&
      currentDay <= weakendday &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    log("Every Thing is Good");
  } else if (day != currentDay &&
      month == currentMonth &&
      currentDay >= weakstartday &&
      currentDay <= weakendday &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmday": 0,
        "welthday": 0,
      });
    });
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"day": currentDay});
  } else if (day == currentDay &&
      month != currentMonth &&
      currentDay >= weakstartday &&
      currentDay <= weakendday &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmmonth": 0,
        "welthmonth": 0,
      });
    });
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"month": currentMonth});
  } else if (day == currentDay &&
      month == currentMonth &&
      (currentDay > weakendday || currentDay < weakstartday) &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmweak": 0,
        "welthweak": 0,
      });
    });
    if (currentDay > weakstartday && currentDay > weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": weakstartday + 7, "endday": weakendday + 7}
      });
    } else if (currentDay < weakstartday && currentDay < weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": 1, "endday": 7}
      });
    }
  } else if (day == currentDay &&
      month == currentMonth &&
      currentDay >= weakstartday &&
      currentDay <= weakendday &&
      (currentMonth > halfyearendmonth || currentMonth < halfyearstartmonth)) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmhalfyear": 0,
        "welthhalfyear": 0,
      });
    });
    if (currentMonth > halfyearstartmonth && currentMonth > halfyearendmonth) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "halfyear": {
          "startmonth": halfyearstartmonth + 6,
          "endmonth": halfyearendmonth + 6
        }
      });
    } else if (currentMonth < halfyearstartmonth &&
        currentMonth < halfyearendmonth) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "halfyear": {"startmonth": 1, "endmonth": 6}
      });
    }
  } else if (day != currentDay &&
      month == currentMonth &&
      (currentDay > weakendday || currentDay < weakstartday) &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmday": 0,
        "welthday": 0,
        "charmweak": 0,
        "welthweak": 0,
      });
    });
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"day": currentDay});
    if (currentDay > weakstartday && currentDay > weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": weakstartday + 7, "endday": weakendday + 7}
      });
    } else if (currentDay < weakstartday && currentDay < weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": 1, "endday": 7}
      });
    }
  } else if (day != currentDay &&
      month != currentMonth &&
      (currentDay > weakendday || currentDay < weakstartday) &&
      currentMonth >= halfyearstartmonth &&
      currentMonth <= halfyearendmonth) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmday": 0,
        "welthday": 0,
        "charmweak": 0,
        "welthweak": 0,
        "charmmonth": 0,
        "welthmonth": 0,
      });
    });
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"day": currentDay});
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"month": currentMonth});
    if (currentDay > weakstartday && currentDay > weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": weakstartday + 7, "endday": weakendday + 7}
      });
    } else if (currentDay < weakstartday && currentDay < weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": 1, "endday": 7}
      });
    }
  } else if (day != currentDay &&
      month != currentMonth &&
      (currentDay > weakendday || currentDay < weakstartday) &&
      (currentMonth > halfyearendmonth || currentMonth < halfyearstartmonth)) {
    querySnapshot.docs.forEach((doc) {
      doc.reference.update({
        "charmday": 0,
        "welthday": 0,
        "charmweak": 0,
        "welthweak": 0,
        "charmmonth": 0,
        "welthmonth": 0,
        "charmhalfyear": 0,
        "welthhalfyear": 0,
      });
    });
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"day": currentDay});
    firestore
        .collection("ranklistsduration")
        .doc("mainrankduration")
        .update({"month": currentMonth});
    if (currentDay > weakstartday && currentDay > weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": weakstartday + 7, "endday": weakendday + 7}
      });
    } else if (currentDay < weakstartday && currentDay < weakendday) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "weak": {"startday": 1, "endday": 7}
      });
    }

    if (currentMonth > halfyearstartmonth && currentMonth > halfyearendmonth) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "halfyear": {
          "startmonth": halfyearstartmonth + 6,
          "endmonth": halfyearendmonth + 6
        }
      });
    } else if (currentMonth < halfyearstartmonth &&
        currentMonth < halfyearendmonth) {
      firestore.collection("ranklistsduration").doc("mainrankduration").update({
        "halfyear": {"startmonth": 1, "endmonth": 6}
      });
    }
  }
}
