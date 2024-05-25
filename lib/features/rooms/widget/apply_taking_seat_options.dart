import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hayaa_main/features/rooms/widget/taking_seat_bootom_sheat.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../models/audince_list_user_modal.dart';

class ApplyTakingSeatOptions extends StatefulWidget {
  ApplyTakingSeatOptions({
    super.key,
    required this.userData,
    required this.roomController,
    required this.roomDocId,
    required this.isHost,
    required this.isAdmin,
  });

  ZegoLiveAudioRoomController roomController;
  final AudinceListUserModal userData;
  final String roomDocId;
  bool isHost;
  bool isAdmin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  State<ApplyTakingSeatOptions> createState() => _ApplyTakingSeatOptionsState();
}

class _ApplyTakingSeatOptionsState extends State<ApplyTakingSeatOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            widget.roomController
                .rejectSeatTakingRequest(widget.userData.docID);
            await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .collection("user")
                .doc(widget.userData.docID)
                .update({"takeSeatRequst": false});

            DocumentSnapshot snapshot = await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .get();
            int numberOfTakingSeatRequst = 0;
            numberOfTakingSeatRequst =
                int.parse(snapshot.get("numberOfTakingSeatRequst"));
            if (numberOfTakingSeatRequst > 0) {
              --numberOfTakingSeatRequst;
            }
            await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .update({
              'numberOfTakingSeatRequst': numberOfTakingSeatRequst.toString()
            });
            Navigator.pop(context);
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              builder: (builder) => TakingSeatBootomSheat(
                roomDocId: widget.roomDocId,
                isHost: widget.isHost,
                isAdmin: widget.isAdmin,
                roomController: widget.roomController,
              ),
            );
          },
          child: const Icon(Icons.close, color: Colors.red, size: 25),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            widget.roomController
                .acceptSeatTakingRequest(widget.userData.docID);
            await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .collection("user")
                .doc(widget.userData.docID)
                .update({"takeSeatRequst": false});

            DocumentSnapshot snapshot = await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .get();
            int numberOfTakingSeatRequst = 0;
            numberOfTakingSeatRequst =
                int.parse(snapshot.get("numberOfTakingSeatRequst"));
            if (numberOfTakingSeatRequst > 0) {
              --numberOfTakingSeatRequst;
            }
            await widget._firestore
                .collection('room')
                .doc(widget.roomDocId)
                .update({
              'numberOfTakingSeatRequst': numberOfTakingSeatRequst.toString()
            });

            Navigator.pop(context);
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              builder: (builder) => TakingSeatBootomSheat(
                roomDocId: widget.roomDocId,
                isHost: widget.isHost,
                isAdmin: widget.isAdmin,
                roomController: widget.roomController,
              ),
            );
          },
          child: const Icon(Icons.check, color: Colors.lightBlue, size: 25),
        )
      ],
    );
  }
}
