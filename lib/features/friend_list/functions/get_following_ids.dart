import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/Utils/helper/firebase_fire_store_services.dart';

Future<List<String>> getFollowersUsersIds() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> followersUsersIds = [];

  followersUsersIds = await FirebaseService().readIdsFromSubcollection(
      parentCollectionName: 'user',
      parentDocumentId: auth.currentUser!.uid,
      subcollectionName: 'following');

  return followersUsersIds;
}
