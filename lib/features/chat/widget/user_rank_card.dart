import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';

class UserRankCard extends StatelessWidget {
  const UserRankCard({
    super.key,
    required this.userData,
    required this.userIndex,
  });

  final UserModel userData;
  final int userIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(
              userData.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userIndex.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userData.photo),
                )
              ],
            ),
            subtitle: Text(
              "ID:${userData.id}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userData.valueRank.toString(),
                  style: const TextStyle(color: Colors.yellow),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  backgroundImage: AssetImage(AppImages.daimond),
                  radius: 10,
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 2,
              bottom: 8,
            ),
            child: Divider(
              thickness: 0.3,
            ),
          )
        ],
      ),
    );
  }
}
