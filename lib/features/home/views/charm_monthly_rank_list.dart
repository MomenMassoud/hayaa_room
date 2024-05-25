import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../models/rank_user_model.dart';
import '../widgets/top_card.dart';
import '../widgets/user_rank_card.dart';
class CharmMonthlyRankList extends StatefulWidget {
  CharmMonthlyRankList({super.key});
  List<RankUserModel> rankUsers = [];
  @override
  State<CharmMonthlyRankList> createState() => _CharmMonthlyRankListState();
}

class _CharmMonthlyRankListState extends State<CharmMonthlyRankList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final screenhieght = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          stream: _firestore
              .collection("user")
              .orderBy("charmmonth", descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (var doc in snapshot.data!.docs) {
                Map<String, dynamic> json = doc.data();
                RankUserModel rankUserModal = RankUserModel.fromJson(json);
                rankUserModal.level2 = json["level2"];
                widget.rankUsers.add(rankUserModal);
              }
              return Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.95,
                      height: screenhieght * 0.32,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: TopCard(
                                screenWidth: screenWidth,
                                topFrame: AppImages.top2frame,
                                userPhoto: widget.rankUsers[1].photo,
                                userName: widget.rankUsers[1].name,
                                userlevel: widget.rankUsers[1].level2,
                                levelImage:
                                    "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                                rankCoinImage: AppImages.daimond,
                                vip: widget.rankUsers[1].vip,
                                rankCoinValue: widget.rankUsers[1].charmMonth),
                          ),
                          const SizedBox(width: 6),
                          TopCard(
                              screenWidth: screenWidth,
                              topFrame: AppImages.top1frame,
                              userPhoto: widget.rankUsers[0].photo,
                              userName: widget.rankUsers[0].name,
                              userlevel: widget.rankUsers[0].level2,
                              levelImage:
                                  "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                              rankCoinImage: AppImages.daimond,
                              vip: widget.rankUsers[0].vip,
                              rankCoinValue: widget.rankUsers[0].charmMonth),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: TopCard(
                                screenWidth: screenWidth,
                                topFrame: AppImages.top3frame,
                                userPhoto: widget.rankUsers[2].photo,
                                userName: widget.rankUsers[2].name,
                                userlevel: widget.rankUsers[2].level2,
                                levelImage:
                                    "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                                rankCoinImage: AppImages.daimond,
                                vip: widget.rankUsers[2].vip,
                                rankCoinValue: widget.rankUsers[2].charmMonth),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: screenhieght * 0.545,
                    width: screenWidth,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        )),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 14, right: 14, bottom: 2),
                      child: SizedBox(
                        height: screenhieght * 0.7,
                        child: ListView.builder(
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return UserRankCard(
                                screenWidth: screenWidth,
                                userIndex: index + 4,
                                userPhoto: widget.rankUsers[index + 3].photo,
                                userName: widget.rankUsers[index + 3].name,
                                userLevel: widget.rankUsers[index + 3].level2,
                                vip: widget.rankUsers[index + 3].vip,
                                rankCoinValue:
                                    widget.rankUsers[index + 3].charmMonth,
                                rankCoinImage: AppImages.daimond,
                                levelImage:
                                    "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png");
                          },
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Opps an error has habend with message ${snapshot.error.toString()} please try Again Later"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ));
  }
}
