import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VipRoomMessage extends StatelessWidget {
  const VipRoomMessage({
    super.key,
    required FirebaseAuth auth,
    required this.message,
    required this.vipMessageFrame,
    required this.vipNameColor,
  }) : _auth = auth;

  final FirebaseAuth _auth;
  final String message;
  final String vipMessageFrame;
  final String vipNameColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        minHeight: 65,
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(vipMessageFrame))),
      child: Row(
        children: [
          const SizedBox(width: 29),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              "${_auth.currentUser!.displayName} awad mohamed ",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(int.parse(vipNameColor)),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
