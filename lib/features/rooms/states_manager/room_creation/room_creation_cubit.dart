import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

part 'room_creation_state.dart';

class RoomCreationCubit extends Cubit<RoomCreationState> {
  RoomCreationCubit() : super(RoomCreationInitial());

  Future<void> createRoom(
      {required File imageFile,
      required TextEditingController namefield,
      required String mycountry}) async {
    print(imageFile);
    print(namefield);
    print(mycountry);
    try {
      emit(RoomCreationLoading());
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final path =
          "room/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print("Download Link : $urlDownload");
      String docRoom =
          "${DateTime.now().toString()} - ${_auth.currentUser!.uid}";
      String myID = "";
      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        myID = value.get('id');
      }).then((value) {
        _firestore.collection('room').doc(docRoom).set({
          'bio': namefield.text,
          'car': '',
          'cartype': '',
          'doc': docRoom,
          'gift': '',
          'gifttype': '',
          'owner': _auth.currentUser!.uid,
          'password': '',
          'seat': '9',
          'wallpaper': '',
          'id': myID,
          'country': mycountry,
          'block': 'false',
          'photo': urlDownload,
          "numberOfTakingSeatRequst": "0",
        }).then((value) {
          _firestore.collection('user').doc(_auth.currentUser!.uid).update({
            'room': docRoom,
          });
        });
      });
      emit(RoomCreationSuccess());
    } catch (e) {
      emit(RoomCreationFailure(errorMessage: e.toString()));
    }
  }
}
