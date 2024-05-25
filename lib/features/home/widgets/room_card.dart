import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/functions/enter_room_password_allarm.dart';
import '../../../models/room_model.dart';
import '../../rooms/view/room_view.dart';

class RoomCard extends StatelessWidget {
  RoomCard({super.key, required this.roomModel});
  final RoomModels roomModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () {
          if (roomModel.password == "") {
            _firestore.collection("user").doc(_auth.currentUser!.uid).update({
              "roomJoined": roomModel.doc,
            });
            _firestore
                .collection('room')
                .doc(roomModel.doc)
                .collection('user')
                .doc(_auth.currentUser!.uid)
                .set({
              'id': _auth.currentUser!.uid,
              'type': 'normal',
              "takeSeatRequst": false,
            }).then((value) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RoomView(
                  roomModel.doc,
                  false,
                  _auth.currentUser!.displayName.toString(),
                  _auth.currentUser!.uid,
                ),
              ));
            });
          } else {
            enterRoomPasswordAllarm(
                context: context,
                roomModel: roomModel,
                controller: _controller,
                auth: _auth,
                firestore: _firestore);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(roomModel.photo),
                fit: BoxFit.cover),
            color: Colors.amber,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: screenHight * 0.12,
          width: screenWidth * 0.42,
        ),
      ),
    );
  }
}
