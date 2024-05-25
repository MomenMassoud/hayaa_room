import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<List<String>> getUserCars() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> usercars = [];
  String myCarId = "";
  DocumentSnapshot querySnapshot =
      await firestore.collection("user").doc(auth.currentUser!.uid).get();

  myCarId = querySnapshot.get("mycar");
  log("my Car id = $myCarId");

  DocumentSnapshot carSnapshot =
      await firestore.collection("store").doc(myCarId).get();

  usercars.add(carSnapshot.get("photo"));
  log("user Car photo is${usercars.first} ");
  return usercars;
}
