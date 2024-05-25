import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<String>> getUsergifts() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('user')
      .doc(auth.currentUser!.uid)
      .collection('Mygifts')
      .get();
  List<String> giftsIds = [];
  if (querySnapshot.docs.isNotEmpty) {
    for (var doc in querySnapshot.docs) {
      giftsIds.add(doc.get("id"));
    }
  }
  List<String> giftsPhotos = [];
  for (int i = 0; i < giftsIds.length; i++) {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('gifts').doc(giftsIds[i]).get();
    giftsPhotos.add(documentSnapshot.get("photo"));
  }
  return giftsPhotos;
}
