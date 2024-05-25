import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/vip_user_profile_card.dart';

import '../../../models/audince_list_user_modal.dart';
import 'normal_user_profile_card.dart';

class RoomUserProfileCard extends StatefulWidget {
  const RoomUserProfileCard({
    super.key,
    required this.userData,
  });

  final AudinceListUserModal userData;

  @override
  State<RoomUserProfileCard> createState() => _RoomUserProfileCardState();
}

class _RoomUserProfileCardState extends State<RoomUserProfileCard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection("user")
          .doc(auth.currentUser!.uid)
          .collection("following")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.userData.vip != "0"
              ? VipUserProfileCard(
                  userData: widget.userData,
                  isFollowing: snapshot.data?.docs.isNotEmpty ?? true,
                )
              : NormalUserProfileCard(
                  userData: widget.userData,
                  isFollowing: snapshot.data?.docs.isNotEmpty ?? true,
                );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "OPPs an error has happend! with message ${snapshot.error.toString()}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
