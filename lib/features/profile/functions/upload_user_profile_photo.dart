import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadUserProfilePhoto(File? imageFile) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String urlDownload = '';
  if (imageFile != null) {
    final path = "usersPhoto/${auth.currentUser!.uid}.jpg";
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    log(urlDownload);
  }
  return urlDownload;
}
