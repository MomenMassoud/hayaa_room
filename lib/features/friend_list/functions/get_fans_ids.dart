import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/Utils/helper/firebase_fire_store_services.dart';

Future<List<String>> getFansUsersIds() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> fansUsersIds = [];

  fansUsersIds = await FirebaseService().readIdsFromSubcollection(
      parentCollectionName: 'user',
      parentDocumentId: auth.currentUser!.uid,
      subcollectionName: "fans");

  return fansUsersIds;
}
