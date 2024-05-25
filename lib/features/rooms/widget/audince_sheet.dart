import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/room_user_card.dart';
import 'package:hayaa_main/features/rooms/widget/room_view_body.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../functions/get_room_audince_list_data.dart';

class AudinceBottomSheet extends StatefulWidget {
  AudinceBottomSheet(
      {super.key,
      required this.roomDocId,
      required this.isHost,
      required this.isAdmin,
      required this.roomController});
  final String roomDocId;
  bool isHost;
  bool isAdmin;
  ZegoLiveAudioRoomController roomController;

  @override
  State<AudinceBottomSheet> createState() => _AudinceBottomSheetState();
}

class _AudinceBottomSheetState extends State<AudinceBottomSheet> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("room")
            .doc(widget.roomDocId)
            .collection('user')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> usersIds =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              return document.id;
            }).toList();
            return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36))),
                child: FutureBuilder(
                  future: getRoomAudincListData(usersIds),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return RoomUserCard(
                                userData: snapshot.data![index],
                                isHost: widget.isHost,
                                isAdmin: widget.isAdmin,
                                roomController: widget.roomController,
                                roomDocId: widget.roomDocId,
                                showMoreButtonOnpressed: () {
                                  onMemberListMoreButtonPressed(
                                      ZegoUIKitUser(
                                          id: snapshot.data![index].docID,
                                          name: snapshot.data![index].name),
                                      context,
                                      widget.isHost,
                                      firestore,
                                      widget.roomDocId,
                                      widget.roomController);
                                });
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Opps Something Went Wrong ${snapshot.error.toString()}?,Try Again Later!",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ));
          } else if (snapshot.hasData) {
            return Text(
              "Opps Something Went Wrong ${snapshot.error.toString()}?,Try Again Later!",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }
}
