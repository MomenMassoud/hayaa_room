import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<dynamic>> getUsearWearedBadges() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> wearingBadges = [];
  final snapshot =
      await firestore.collection("user").doc(auth.currentUser!.uid).get();
  final json = snapshot.data() as Map<String, dynamic>;
  wearingBadges = json["wearingBadges"];
  return wearingBadges;
}
