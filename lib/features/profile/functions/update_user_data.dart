import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateUserProfileData(Map<String, dynamic> updatedData) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  await firestore
      .collection('user')
      .doc(auth.currentUser!.uid)
      .update(updatedData);
}
