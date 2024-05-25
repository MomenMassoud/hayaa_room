import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../../../models/family_rank.dart';
import '../../../../../models/user_model.dart';
import '../../../model/group_rand_card.dart';
import '../../user_rank_card.dart';
import '../top_card.dart';

class GravityMonth extends StatefulWidget {
  String id;
  GravityMonth(this.id);
  _GravityMonth createState() => _GravityMonth();
}

class _GravityMonth extends State<GravityMonth> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int myidex = 0;
  String _mytype = "";
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('family')
          .doc(widget.id)
          .collection('user')
          .snapshots(),
      builder: (context, snapshot) {
        List<UserModel> users = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed) {
          UserModel us = UserModel(
              "email",
              "name",
              "gender",
              "photo",
              "massege.id",
              "phonenumber",
              "devicetoken",
              "daimond",
              "vip",
              "bio",
              "seen",
              "lang",
              "country",
              "type",
              "birthdate",
              "coin",
              "exp",
              "level");
          us.docID = massege.get('user');
          us.familytype = massege.get('type');
          users.add(us);
        }
        users.sort((a, b) => b.valueRank.compareTo(a.valueRank));
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('family')
              .doc(widget.id)
              .collection('count')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              FamilyRankModel rank = FamilyRankModel(
                  massege.id,
                  massege.get('user'),
                  massege.get('coin'),
                  massege.get('day'),
                  massege.get('month'),
                  massege.get('year'));
              for (int i = 0; i < users.length; i++) {
                if (rank.month == DateTime.now().month.toString()) {
                  if (users[i].docID == rank.user) {
                    users[i].valueRank += int.parse(rank.coin);
                    users[i].familyRank.add(rank);
                  }
                }
              }
            }
            users.sort((a, b) => b.valueRank.compareTo(a.valueRank));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('user')
                        .where('doc', isEqualTo: users[index].docID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed) {
                        users[index].bio = massege.get('bio');
                        users[index].birthdate = massege.get('birthdate');
                        users[index].coin = massege.get('coin');
                        users[index].country = massege.get('country');
                        users[index].daimond = massege.get('daimond');
                        users[index].coin = massege.get('coin');
                        users[index].devicetoken = massege.get('devicetoken');
                        users[index].email = massege.get('email');
                        users[index].exp = massege.get('exp');
                        users[index].gender = massege.get('gender');
                        users[index].id = massege.get('id');
                        users[index].lang = massege.get('lang');
                        users[index].level = massege.get('level');
                        users[index].name = massege.get('name');
                        users[index].phonenumber = massege.get('phonenumber');
                        users[index].photo = massege.get('photo');
                        final lastSeen = massege.get('seen');
                        if (lastSeen is Timestamp) {
                          final DateTime dateTime = lastSeen.toDate();
                          users[index].seen = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(dateTime);
                        } else {
                          users[index].seen = lastSeen.toString();
                        }
                        users[index].type = massege.get('type');
                        users[index].vip = massege.get('vip');
                        users[index].docID = massege.id;
                        users[index].myfamily = massege.get('myfamily');
                        if (users[index].docID == _auth.currentUser!.uid) {
                          users[index].name = "${users[index].name} (you)";
                        }
                      }
                      if (index == 0) {
                        return Text("");
                      } else if (index == 1) {
                        return Text("");
                      } else if (index == 2) {
                        List<GroupRandCard> cards = [
                          GroupRandCard(
                              cardImge: AppImages.img3,
                              rating: 'Top 3',
                              strokColor: Colors.purpleAccent,
                              userImge: users[2].photo,
                              userName: users[2].name),
                          GroupRandCard(
                              cardImge: AppImages.img1,
                              rating: 'Top 2',
                              strokColor: Colors.brown.withOpacity(0.5),
                              userImge: users[1].photo,
                              userName: users[1].name),
                          GroupRandCard(
                              ratingColor: Colors.cyan,
                              cardImge: AppImages.img2,
                              rating: 'Top 1',
                              strokColor: Colors.amber,
                              userImge: users[0].photo,
                              userName: users[0].name)
                        ];
                        List<String> coin = [];
                        if (users[2].valueRank < 1000) {
                          coin.add(users[2].valueRank.toString());
                        } else if (users[2].valueRank >= 10000 &&
                            users[index].valueRank < 1000000) {
                          coin.add(
                              "${(users[2].valueRank / 1000).toString()} K");
                          print(coin);
                        } else {
                          coin.add(
                              "${(users[2].valueRank / 1000000).toString()} K");
                        }
                        print("");
                        if (users[1].valueRank < 1000) {
                          coin.add(users[1].valueRank.toString());
                        } else if (users[1].valueRank >= 10000 &&
                            users[index].valueRank < 1000000) {
                          coin.add(
                              "${(users[1].valueRank / 1000).toString()} K");
                          print(coin);
                        } else {
                          coin.add(
                              "${(users[1].valueRank / 1000000).toString()} K");
                        }
                        print("");
                        if (users[0].valueRank < 1000) {
                          coin.add(users[0].valueRank.toString());
                        } else if (users[0].valueRank >= 10000 &&
                            users[index].valueRank < 1000000) {
                          coin.add(
                              "${(users[0].valueRank / 1000).toString()} K");
                          print(coin);
                        } else {
                          coin.add(
                              "${(users[0].valueRank / 1000000).toString()} K");
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TopCard(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                cardModel: cards[1],
                                coin: coin[1],
                                coinPic: false,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: TopCard(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                  cardModel: cards[2],
                                  coin: coin[2],
                                  coinPic: false,
                                ),
                              ),
                              TopCard(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                cardModel: cards[0],
                                coin: coin[0],
                                coinPic: false,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return UserRankCard(
                            userData: users[index], userIndex: index + 1);
                      }
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
