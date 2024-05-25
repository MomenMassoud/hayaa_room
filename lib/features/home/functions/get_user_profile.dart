import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user_model.dart';

Future<UserModel> getUserProfils(String userId) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  DocumentSnapshot snapshot =
      await firebaseFirestore.collection("user").doc(userId).get();

  final json = snapshot.data() as Map<String, dynamic>;
  UserModel userModel = UserModel.fromJson(json);
  userModel.level2 = json["level2"];
  userModel.docID = json["doc"];
  userModel.wearingBadges = json["wearingBadges"] ?? [];

  return userModel;
}
