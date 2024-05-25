import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../core/Utils/helper/firebase_fire_store_services.dart';
import '../../../models/room_model.dart';

Future<List<String>> getRelatedUsers() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> relatedUsers = [];
  List<String> frinds;
  List<String> followers;
  frinds = await FirebaseService().readIdsFromSubcollection(
      parentCollectionName: 'user',
      parentDocumentId: _auth.currentUser!.uid,
      subcollectionName: "friends");
  followers = await FirebaseService().readIdsFromSubcollection(
      parentCollectionName: 'user',
      parentDocumentId: _auth.currentUser!.uid,
      subcollectionName: 'following');
  relatedUsers.addAll(frinds);
  relatedUsers.addAll(followers);
  return relatedUsers;
}

Future<List<RoomModels>> getrealtedRooms(List<String> relatedUsers) async {
  List<RoomModels> realtedRooms = [];
  ;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  for (int i = 0; i < relatedUsers.length; i++) {
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection("room")
        .where('owner', isEqualTo: relatedUsers[i])
        .get();

    if (snapshot.docs.isNotEmpty) {
      realtedRooms.add(
          RoomModels.fromJson(snapshot.docs[0].data() as Map<String, dynamic>));
    }
  }
  return realtedRooms;
}
