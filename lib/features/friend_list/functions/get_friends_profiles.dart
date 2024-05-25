import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/Utils/helper/firebase_fire_store_services.dart';

Future<List<String>> getFrindsUsersIds() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> friendsUsersIds = [];

  friendsUsersIds = await FirebaseService().readIdsFromSubcollection(
      parentCollectionName: 'user',
      parentDocumentId: auth.currentUser!.uid,
      subcollectionName: "friends");

  return friendsUsersIds;
}
