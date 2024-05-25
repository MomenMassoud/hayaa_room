import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DefultRoomMessage extends StatelessWidget {
  const DefultRoomMessage({
    super.key,
    required FirebaseAuth auth,
    required this.message,
    required this.userNameColor,
  }) : _auth = auth;

  final FirebaseAuth _auth;
  final String message;
  final Color userNameColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 35),
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff5F272F).withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: RichText(
          softWrap: true,
          textAlign: TextAlign.left,
          text: TextSpan(
              text: "${_auth.currentUser!.displayName} ",
              style: TextStyle(
                  color: userNameColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: message,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )
              ]),
        ),
      ),
    );
  }
}
