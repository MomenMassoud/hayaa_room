import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../friend_list/widget/level_card.dart';
import '../../friend_list/widget/vip_card.dart';

class UserRankCard extends StatelessWidget {
  const UserRankCard({
    super.key,
    required this.screenWidth,
    required this.userIndex,
    required this.userPhoto,
    required this.userName,
    required this.userLevel,
    required this.vip,
    required this.rankCoinValue,
    required this.rankCoinImage,
    required this.levelImage,
  });
  final double screenWidth;
  final int userIndex;
  final String userPhoto;
  final String userName;
  final String userLevel;
  final String vip;
  final num rankCoinValue;
  final String rankCoinImage;
  final String levelImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Text(
            userIndex.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(userPhoto),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.3,
                child: Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  LevelCard(userLevel: userLevel, levelImageType: levelImage),
                  vip != "0"
                      ? SizedBox(height: 18, child: VipCard(vipValue: vip))
                      : const SizedBox(),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.16,
                  ),
                  child: Text(
                    rankCoinValue.toString().length == 7
                        ? "${rankCoinValue / 1000000}M"
                        : "${rankCoinValue / 1000}K",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(height: 23, width: 23, child: Image.asset(rankCoinImage))
            ],
          ),
        ],
      ),
    );
  }
}
