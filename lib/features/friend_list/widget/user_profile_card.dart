import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/vip_card.dart';

import '../../../models/firends_model.dart';
import '../../../models/user_model.dart';
import '../../chat/widget/one_to_one/chat_body.dart';
import '../../profile/views/visitor_.view.dart';
import 'level_card.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, required this.userData});

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    final FriendsModel chatData = FriendsModel(
        userData.email,
        userData.id,
        userData.docID,
        userData.photo,
        userData.name,
        userData.phonenumber,
        userData.gender);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              log("docId: ${userData.docID}");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      VistorView(userData.photo, userData.docID)));
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
              const SizedBox(height: 0),
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
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  userData.vip != "0"
                      ? VipCard(vipValue: userData.vip)
                      : const SizedBox(),
                  userData.wearingBadges.isNotEmpty
                      ? SizedBox(
                          height: 25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: userData.wearingBadges.length,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: userData.wearingBadges[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatBody(
                        chatData,
                      )));
            },
            child: const Text(
              "دردشة",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}



  
  // Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ListTile(
  //         title: Text(userData.name),
  //         leading: InkWell(
  //           onTap: () {
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) =>
  //                     VistorView(userData.photo, userData.docID)));
  //           },
  //           child: CircleAvatar(
  //             backgroundImage: CachedNetworkImageProvider(userData.photo),
  //           ),
  //         ),
  //         subtitle: InkWell(
  //             onTap: () {
  //               Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) =>
  //                       VistorView(userData.photo, userData.docID)));
  //             },
  //             child: Text(userData.bio)),
  //         trailing: InkWell(
  //             onTap: () {
  //               Navigator.pop(context);
  //               Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => ChatBody(
  //                         userData,
  //                       )));
  //             },
  //             child: const Text(
  //               "دردشة",
  //               style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.bold),
  //             ))),
  //   );