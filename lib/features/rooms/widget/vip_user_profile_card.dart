import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/room_user_profile_card_list_options.dart';

import '../../../models/audince_list_user_modal.dart';
import '../../friend_list/widget/level_card.dart';
import '../../friend_list/widget/vip_card.dart';
import '../../profile/functions/calculate_user_age.dart';
import '../../profile/views/profile_edit_view.dart';
import '../../profile/widgets/age_card.dart';

class VipUserProfileCard extends StatelessWidget {
  VipUserProfileCard(
      {super.key, required this.userData, required this.isFollowing});
  final AudinceListUserModal userData;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final bool isFollowing;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("vip")
          .doc("vip${userData.vip}")
          .get(),
      builder: (context, snapshot) {
        final String? profileframe = snapshot.data?.get("profileframe") ?? "";

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  (userData.wearingBadges.isNotEmpty ? 0.42 : 0.34),
              color: Colors.transparent,
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  (userData.wearingBadges.isNotEmpty ? 0.34 : 0.26),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 55),
                  Text(
                    userData.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AgeCard(
                        age: calculateAge(userData.birthdate),
                        gender: userData.gender,
                      ),
                      const SizedBox(width: 4),
                      userData.vip != "0"
                          ? VipCard(vipValue: userData.vip)
                          : const SizedBox(),
                      const SizedBox(width: 4),
                      LevelCard(
                        userLevel: userData.level,
                        levelImageType:
                            "lib/core/Utils/assets/images/wealth&charm badges/wealth126-150.png",
                      ),
                      const SizedBox(width: 4),
                      LevelCard(
                        userLevel: userData.level2,
                        levelImageType:
                            "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ID: ${userData.id}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(width: 3),
                        GestureDetector(
                          onTap: () async {
                            await FlutterClipboard.copy(userData.id)
                                .whenComplete(() {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Copyed ID"),
                                showCloseIcon: true,
                              ));
                            });
                          },
                          child: const Icon(
                            Icons.copy,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2.5,
                          ),
                        ),
                        Text(
                          userData.acualCountry,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2.5,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Text(
                            userData.seen,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  userData.wearingBadges.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.28),
                          child: SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userData.wearingBadges.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: CachedNetworkImageProvider(
                                            userData.wearingBadges[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
                      : const SizedBox(),
                  const Spacer(),
                  RoomUserProfileCardListOptions(
                    isFollowing: isFollowing,
                    userId: userData.docID,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () async {
                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collection('user')
                      .doc(userData.docID)
                      .collection('fans')
                      .get();
                  final int numberOfFans = snapshot.docs.length;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileEditView(
                            fans: numberOfFans > 0
                                ? numberOfFans.toString()
                                : "0",
                            isVisitor: auth.currentUser!.uid != userData.docID,
                          )));
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(userData.photo),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
