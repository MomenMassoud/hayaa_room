import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/room_user_profile_card.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../models/audince_list_user_modal.dart';
import '../../friend_list/widget/level_card.dart';
import '../../friend_list/widget/vip_card.dart';
import '../../profile/views/visitor_.view.dart';
import 'apply_taking_seat_options.dart';

class TakingSeatUserCard extends StatelessWidget {
  TakingSeatUserCard({
    super.key,
    required this.roomDocId,
    required this.userData,
    required this.isHost,
    required this.isAdmin,
    this.showMoreButtonOnpressed,
    required this.roomController,
  });

  final AudinceListUserModal userData;
  bool isHost;
  bool isAdmin;
  void Function()? showMoreButtonOnpressed;

  ZegoLiveAudioRoomController roomController;
  final String roomDocId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              log("docId: ${userData.acualCountry}");
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return RoomUserProfileCard(userData: userData);
                },
              );
            },
            child: CircleAvatar(
              radius: (userData.vip == "0" && userData.wearingBadges.isEmpty)
                  ? 25
                  : 30,
              backgroundImage: CachedNetworkImageProvider(userData.photo),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          VistorView(userData.photo, userData.docID)));
                },
                child: Text(
                  userData.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Id: ${userData.id}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  LevelCard(
                    userLevel: userData.level,
                    levelImageType:
                        "lib/core/Utils/assets/images/wealth&charm badges/wealth126-150.png",
                  ),
                  LevelCard(
                    userLevel: userData.level2,
                    levelImageType:
                        "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                  ),
                  const SizedBox(width: 6),
                  userData.vip != "0"
                      ? Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: VipCard(vipValue: userData.vip),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
          const Spacer(),
          ApplyTakingSeatOptions(
            userData: userData,
            roomController: roomController,
            isAdmin: isAdmin,
            isHost: isHost,
            roomDocId: roomDocId,
          )
        ],
      ),
    );
  }
}
