import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user_model.dart';

Future<List<UserModel>> getUsersProfils(List<String> usersIds) async {
  List<UserModel> userProfils = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  for (int i = 0; i < usersIds.length; i++) {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection("user")
        .where('doc', isEqualTo: usersIds[i])
        .get();

    if (snapshot.docs.isNotEmpty) {
      userProfils.add(
          UserModel.fromJson(snapshot.docs[0].data() as Map<String, dynamic>));
    }
  }
  return userProfils;
}

Future<List<UserModel>> getFrinsProfils(List<String> usersIds) async {
  List<UserModel> userProfils = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  for (int i = 0; i < usersIds.length; i++) {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection("user")
        .where('doc', isEqualTo: usersIds[i])
        .get();

    if (snapshot.docs.isNotEmpty) {
      final json = snapshot.docs[0].data() as Map<String, dynamic>;
      UserModel userModel = UserModel.fromJson(json);
      userModel.level2 = json["level2"];
      userModel.docID = json["doc"];
      userModel.wearingBadges = json["wearingBadges"] ?? [];
      userProfils.add(userModel);
    }
  }
  return userProfils;
}
