import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

Future<void> addlike(
  String postId,
  Map<String, dynamic> postData,
  Map<String, dynamic> like,
  String likeId,
) async {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('post');

  if (postData != null) {
    postData["likes"][likeId] = like;
    postData["likesCounter"]++;
    postData["like"] = true;
  } else {
    log("postData doesn,t exist");
  }

  await collectionRef.doc(postId).update(postData);
}
