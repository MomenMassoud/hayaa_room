import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/get_user_weared_badges.dart';
import '../functions/show_multi_selected_badges.dart';
import '../models/badge_model.dart';
import 'badges_list_item.dart';

class BadgesDone extends StatefulWidget {
  _BadgesDone createState() => _BadgesDone();
}

class _BadgesDone extends State<BadgesDone> {
  int currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map> ownBadges = [];
  List<dynamic> wearingBadges = [];
  int selectedCounter = 0;
  Stream<List<dynamic>> getUserWearingBadges() {
    return Stream.fromFuture(getUsearWearedBadges());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckNewBadge();
  }

  void CheckNewBadge() async {
    await for (var snap in _firestore.collection('badges').snapshots()) {
      print("Start");
      for (int i = 0; i < snap.docs.length; i++) {
        String badgegiftphoto = snap.docs[i].get('giftphoto');
        int count = int.parse(snap.docs[i].get('count'));
        String badgegift = snap.docs[i].get('gift');
        String badgedoc = snap.docs[i].id;
        if (badgegift == "") {
          if (badgegiftphoto == "receve daimond") {
            getBadgeDaiomond(badgedoc, count);
          } else {
            getBadgeCoin(badgedoc, count);
          }
        } else {
          getBadgeGift(badgedoc, count, badgegift);
        }
      }
    }
  }

  void getBadgeDaiomond(String badgedoc, int target) async {
    int c = 0;
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('Mygifts')
        .snapshots()) {
      for (int i = 0; i < snap.docs.length; i++) {
        await for (var snap2 in _firestore
            .collection('gifts')
            .doc(snap.docs[i].get('id'))
            .snapshots()) {
          c += int.parse(snap2.get('price'));
          if (c >= target) {
            _firestore
                .collection("user")
                .doc(_auth.currentUser!.uid)
                .collection("mybadges")
                .doc(badgedoc)
                .set({
              'id': badgedoc,
            });
          }
        }
      }
    }
  }

  void getBadgeCoin(String badgedoc, int target) async {
    int c = 0;
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('sendgift')
        .snapshots()) {
      for (int i = 0; i < snap.docs.length; i++) {
        String giftid = snap.docs[i].get('giftid');
        await for (var snap2
            in _firestore.collection('gifts').doc(giftid).snapshots()) {
          c += int.parse(snap2.get('price'));
          if (c >= target) {
            _firestore
                .collection("user")
                .doc(_auth.currentUser!.uid)
                .collection("mybadges")
                .doc(badgedoc)
                .set({
              'id': badgedoc,
            });
          }
        }
      }
    }
  }

  void getBadgeGift(String badgedoc, int target, String giftgoc) async {
    int c = 0;
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('sendgift')
        .snapshots()) {
      for (int i = 0; i < snap.docs.length; i++) {
        String giftid = snap.docs[i].get('giftid');
        if (giftid == giftgoc) {
          c++;
          if (c >= target) {
            _firestore
                .collection('user')
                .doc(_auth.currentUser!.uid)
                .collection('mybadges')
                .doc(badgedoc)
                .set({'id': badgedoc});
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection('mybadges')
          .snapshots(),
      builder: (context, snapshot) {
        List<String> badgesdoc = [];
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              badgesdoc.add(massege.get('id'));
              print(massege.get('id'));
            }
            //from here
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('badges').snapshots(),
              builder: (context, snapshot) {
                List<BadgeModel> mybadges = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  if (badgesdoc.contains(massege.id)) {
                    print("yes");
                    mybadges.add(BadgeModel(
                        badgeImage: massege.get('photo'),
                        badgeName: massege.get('name'),
                        count: massege.get('count'),
                        gift: massege.get('gift'),
                        Giftphoto: massege.get('giftphoto')));
                    ownBadges.add(
                        {"image": massege.get('photo'), "isWeared": false});
                  }
                }
                return StreamBuilder(
                  stream: getUserWearingBadges(),
                  builder: (context, snapshot) {
                    wearingBadges = snapshot.data ?? [];
                    selectedCounter = wearingBadges.length;
                    for (var map in ownBadges) {
                      if (wearingBadges.contains(map["image"])) {
                        map["isWeared"] = true;
                      }
                    }
                    return Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showMultiSelcedBadges(
                                      context, ownBadges, selectedCounter);
                                },
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          topLeft: Radius.circular(15)),
                                      color: Colors.brown[100]),
                                  child: const Center(
                                      child: Text(
                                    "ارتداء",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHight * 0.32,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BadgeInfo(
                                    bgImage:
                                        'lib/core/Utils/assets/images/702.png',
                                    screenWidth: screenWidth,
                                    opacity: 1.0,
                                    badgeModel: mybadges[currentIndex]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.brown.withOpacity(0.6),
                                      border: Border.all(
                                          color: Colors.brown, width: 2),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: List.generate(mybadges.length,
                                            (index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  print("hi");
                                                  print(index);
                                                  print(currentIndex);
                                                  currentIndex = index;
                                                  print(currentIndex);
                                                });
                                              },
                                              child: BadgesListItem(
                                                  bgImage:
                                                      "lib/core/Utils/assets/images/709.png",
                                                  opacity: 0.75,
                                                  screenWidth: screenWidth,
                                                  badgeModel: mybadges[index]),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                top: screenHight * 0.19,
              ),
              child: const Text(
                "No Bages Completed Yet !",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
              width: screenWidth * 0.7,
              child: Text(
                snapshot.error.toString(),
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ));
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.lightBlue,
          ));
        }
      },
    );
  }
}
