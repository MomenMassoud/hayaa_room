import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addComment(
    String postId, Map<String, dynamic> postData, num commentCounter) async {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('post');

  if (postData != null) {
    // postData["comments"][commentId] = comment;
    postData["commentCounter"] = commentCounter + 1;
  } else {
    log("postData doesn,t exist");
  }

  await collectionRef.doc(postId).update(postData);
}
