import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/room_user_profile_card_options.dart';
import 'package:iconsax/iconsax.dart';

class RoomUserProfileCardListOptions extends StatefulWidget {
  const RoomUserProfileCardListOptions(
      {super.key, required this.isFollowing, required this.userId});
  final bool isFollowing;
  final String userId;
  @override
  State<RoomUserProfileCardListOptions> createState() =>
      _RoomUserProfileCardListOptionsState();
}

class _RoomUserProfileCardListOptionsState
    extends State<RoomUserProfileCardListOptions> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RooMUserProfileCardOptions(
          onTap: () {},
          icon: Icons.alternate_email_outlined,
          tilte: "Reminder",
          iconColor: const Color(0xff34A7E3),
        ),
        RooMUserProfileCardOptions(
          onTap: () {},
          icon: Iconsax.gift5,
          tilte: "Send Gifts",
          iconColor: const Color(0xffFB5391),
          divider: auth.currentUser!.uid != widget.userId ? null : false,
        ),
        auth.currentUser!.uid != widget.userId
            ? RooMUserProfileCardOptions(
                onTap: () {
                  widget.isFollowing
                      ? firestore
                          .collection("user")
                          .doc(auth.currentUser!.uid)
                          .collection("following")
                          .doc(widget.userId)
                          .delete()
                      : firestore
                          .collection("user")
                          .doc(auth.currentUser!.uid)
                          .collection("following")
                          .doc(widget.userId)
                          .set({"id": widget.userId});
                },
                icon: Icons.add,
                tilte: widget.isFollowing ? "Unfollow" : "Follow",
                iconColor: const Color(0xff03C93D),
                divider: false,
              )
            : const SizedBox(),
      ],
    );
  }
}
