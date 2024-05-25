import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

// Future<void> deletLike({required String postId, required String docId}) async {
//   FirebaseService().deleteDataFromSubcollection(
//       parentCollectionName: 'post',
//       parentDocumentId: postId,
//       subcollectionName: 'like',
//       documentId: docId);
// }

Future<void> delteLike(
    String postId, String likeId, Map<String, dynamic> postData) async {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('post');

  // if (postData != null) {
  //   postData["likes"][likeId]=;
  //   postData["likesCounter"]--;
  // } else {
  //   log("postData doesn,t exist");
  await collectionRef.doc(postId).update({
    "likes.$likeId": FieldValue.delete(),
    'likesCounter': postData["likesCounter"] - 1,
  });
}
