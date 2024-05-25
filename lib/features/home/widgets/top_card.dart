import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../friend_list/widget/level_card.dart';
import '../../friend_list/widget/vip_card.dart';

class TopCard extends StatelessWidget {
  const TopCard({
    super.key,
    required this.screenWidth,
    required this.topFrame,
    required this.userPhoto,
    required this.userName,
    required this.userlevel,
    required this.levelImage,
    required this.rankCoinImage,
    required this.rankCoinValue,
    required this.vip,
  });

  final double screenWidth;
  final String topFrame;
  final String userPhoto;
  final String userName;
  final String userlevel;
  final String levelImage;
  final String rankCoinImage;
  final num rankCoinValue;
  final String vip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(userPhoto),
            ),
            SizedBox(height: 120, width: 120, child: Image.asset(topFrame))
          ],
        ),
        SizedBox(
            width: screenWidth * 0.25,
            child: Text(
              userName,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )),
        Row(
          children: [
            LevelCard(userLevel: userlevel, levelImageType: levelImage),
            vip != "0"
                ? SizedBox(height: 18, child: VipCard(vipValue: vip))
                : const SizedBox(),
          ],
        ),
        Row(
          children: [
            SizedBox(
                width: screenWidth * 0.16,
                child: Text(
                  rankCoinValue.toString().length == 7
                      ? "${rankCoinValue / 1000000}M"
                      : "${rankCoinValue / 1000}K",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )),
            SizedBox(height: 18, width: 18, child: Image.asset(rankCoinImage))
          ],
        ),
      ],
    );
  }
}
