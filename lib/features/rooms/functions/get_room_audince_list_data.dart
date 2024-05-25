import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/audince_list_user_modal.dart';

Future<List<AudinceListUserModal>> getRoomAudincListData(
    List<String> usersIds) async {
  List<AudinceListUserModal> userProfils = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  for (int i = 0; i < usersIds.length; i++) {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection("user")
        .where('doc', isEqualTo: usersIds[i])
        .get();

    if (snapshot.docs.isNotEmpty) {
      final json = snapshot.docs[0].data() as Map<String, dynamic>;
      AudinceListUserModal userModel = AudinceListUserModal.fromJson(json);
      userModel.level2 = json["level2"];
      userModel.docID = json["doc"];
      userModel.wearingBadges = json["wearingBadges"] ?? [];
      userModel.acualCountry = json["acualCountry"];
      userModel.agent = json["myagent"];

      userProfils.add(userModel);
    }
  }
  // only left to sort list acording to vip value the bigst is first
  userProfils.sort(((a, b) => int.parse(b.vip).compareTo(int.parse(a.vip))));
  return userProfils;
}
