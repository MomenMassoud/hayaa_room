import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../core/widgets/show_snack_par.dart';
import '../../../models/audince_list_user_modal.dart';
import '../../../models/gift_model.dart';
import '../../../models/user_model.dart';
import '../../store/functions/buying_done.dart';
import '../functions/get_room_audince_list_data.dart';
import 'cusotm_gift_item.dart';
import 'gift_user_item.dart';

class GiftsBottomSheet extends StatefulWidget {
  GiftsBottomSheet(
      {super.key,
      required this.roomId,
      required this.currentUserData,
      required this.welthDay,
      required this.welthWeak,
      required this.welthMonth,
      required this.welthHalfYear,
      required this.day,
      required this.month,
      required this.weakstartday,
      required this.weakendday,
      required this.halfyearstartmonth,
      required this.halfyearendmonth,
      required this.controller});
  final String roomId;
  Map<int, AudinceListUserModal> selectedUser = {};
  List<GiftModel> gifts = [];
  int currentindex = 0;
  final UserModel currentUserData;
  final num welthDay;
  final num welthWeak;
  final num welthMonth;
  final num welthHalfYear;
  final num day;
  final num month;
  final num weakstartday;
  final num weakendday;
  final num halfyearstartmonth;
  final num halfyearendmonth;
  final ZegoLiveAudioRoomController controller;
  @override
  State<GiftsBottomSheet> createState() => _GiftsBottomSheetState();
}

class _GiftsBottomSheetState extends State<GiftsBottomSheet>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TabController tabController;

  late num charmDay;

  late num charmWeak;

  late num charmMonth;

  late num cahrmHalfYear;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: const Color(0xff180F20),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _firestore
                        .collection("room")
                        .doc(widget.roomId)
                        .collection("user")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          List<String> usersIds = [];
                          snapshot.data!.docs.forEach((doc) {
                            if (doc.id != _auth.currentUser!.uid) {
                              usersIds.add(doc.id);
                            }
                          });

                          return FutureBuilder(
                            future: getRoomAudincListData(usersIds),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<AudinceListUserModal> userData =
                                    snapshot.data ?? [];
                                return SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: usersIds.length-1,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (widget.selectedUser
                                              .containsKey(index)) {
                                            widget.selectedUser.remove(index);
                                            setState(() {});
                                            print(widget.selectedUser.keys);
                                          } else {
                                            widget.selectedUser[index] =
                                                userData[index];
                                            print(widget.selectedUser.keys);
                                            log(widget
                                                .selectedUser[index]!.docID);
                                            setState(() {});
                                            log(widget
                                                .selectedUser[index]!.docID);
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: GiftUserItem(
                                              isSelected: widget.selectedUser
                                                  .containsKey(index),
                                              userData: userData[index]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                log(snapshot.error.toString());
                                return const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            },
                          );
                        } else {
                          return const Text(
                            "No user in the room",
                            style: TextStyle(color: Colors.white),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              "Opps an error has ecured check internt and try again"),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                      controller: tabController,
                      dividerHeight: 0,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      tabs: const [
                        Text(
                          'Normal/gifts',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Vip/gifts',
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: TabBarView(controller: tabController, children: [
                      FutureBuilder(
                        future: _firestore.collection('gifts').get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final masseges = snapshot.data?.docs;
                            for (var massege in masseges!.reversed) {
                              widget.gifts.add(GiftModel(
                                  massege.id,
                                  massege.get('name'),
                                  massege.get('photo'),
                                  massege.get('price'),
                                  massege.get('type')));
                            }
                            return SizedBox(
                              height: 250,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.gifts.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      widget.currentindex = index;
                                      setState(() {});
                                    },
                                    child: CustomtGiftItem(
                                        giftData: widget.gifts[index],
                                        isSelected:
                                            widget.currentindex == index),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "an error has Ocured with Message ${snapshot.error.toString()}! check enternt ",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                        },
                      ),
                      Container()
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          log(widget.selectedUser.keys.toString());
                          log(widget.selectedUser.values.first.docID);
                          log(widget.selectedUser.values.last.docID);

                          if (widget.selectedUser.isNotEmpty) {
                            for (int i = 0;
                                i < widget.selectedUser.length;
                                i++) {
                              log(i.toString());
                              log(widget.selectedUser[i]?.docID ?? "0");
                              num newWelthDay = 0;
                              num newWelthWeak = 0;
                              num newWelthMonth = 0;
                              num newWelthHalfYear = 0;
                              num newCharmDay = 0;
                              num newCharmWeak = 0;
                              num newCharmMonth = 0;
                              num newCharmHalfYear = 0;
                              DateTime currenDate = DateTime.now();
                              num currentDay = int.parse(
                                  DateFormat("dd").format(currenDate));
                              num currentMonth =
                                  int.parse(DateFormat('M').format(currenDate));
                              int coins =
                                  int.parse(widget.currentUserData.coin);
                              int price = int.parse(
                                  widget.gifts[widget.currentindex].price);
                              int exp2 = 0;
                              int daimonds = 0;
                              String reciverVip = "0";
                              if (coins >= price) {
                                int exp = int.parse(widget.currentUserData.exp);
                                if (widget.currentUserData.vip == "1") {
                                  exp = exp + (price * 1.15).toInt();
                                } else if (widget.currentUserData.vip == "2") {
                                  exp = exp + (price * 1.125).toInt();
                                } else if (widget.currentUserData.vip == "3") {
                                  exp = exp + (price * 1.50).toInt();
                                } else if (widget.currentUserData.vip == "4") {
                                  exp = exp + (price * 1.75).toInt();
                                } else {
                                  exp = exp + price;
                                }
                                coins = coins - price;
                                if (widget.day == currentDay &&
                                    widget.month == currentMonth &&
                                    currentDay >= widget.weakstartday &&
                                    currentDay <= widget.weakendday &&
                                    currentMonth >= widget.halfyearstartmonth &&
                                    currentMonth <= widget.halfyearendmonth) {
                                  newWelthDay = widget.welthDay + price;
                                  newWelthWeak = widget.welthWeak + price;
                                  newWelthMonth = widget.welthMonth + price;
                                  newWelthHalfYear =
                                      widget.welthHalfYear + price;
                                  log("all Welth  data   corect");
                                }
                                await _firestore
                                    .collection('user')
                                    .doc(_auth.currentUser!.uid)
                                    .update({
                                  'coin': coins.toString(),
                                  'exp': exp.toString(),
                                  'welthday': newWelthDay,
                                  'welthweak': newWelthWeak,
                                  "welthmonth": newWelthMonth,
                                  "welthhalfyear": newWelthHalfYear,
                                }).then((value) async {
                                  await _firestore
                                      .collection('user')
                                      .doc(widget.selectedUser[i]?.docID)
                                      .get()
                                      .then((value) {
                                    exp2 = int.parse(value.get('exp2'));
                                    daimonds = int.parse(value.get('daimond'));
                                    reciverVip = value.get('vip');
                                    charmDay = value.get("charmday");
                                    charmWeak = value.get("charmweak");
                                    charmMonth = value.get("charmmonth");
                                    cahrmHalfYear = value.get("charmhalfyear");
                                  }).then((value) async {
                                    daimonds = daimonds + price;
                                    int newexp = 0;
                                    if (reciverVip == "1") {
                                      newexp =
                                          exp2 + (price / 3.47826087).round();
                                    } else if (reciverVip == "2") {
                                      newexp =
                                          exp2 + (price / 3.55555556).round();
                                    } else if (reciverVip == "3") {
                                      newexp =
                                          exp2 + (price / 2.66666667).round();
                                    } else if (reciverVip == "4") {
                                      newexp =
                                          exp2 + (price / 2.28571429).round();
                                    } else {
                                      newexp = exp2 + (price / 4).round();
                                    }
                                    await _firestore
                                        .collection('user')
                                        .doc(widget.selectedUser[i]!.docID)
                                        .update({
                                      'exp2': newexp.toString(),
                                      'daimond': daimonds.toString(),
                                      "charmday": newCharmDay,
                                      "charmweak": newCharmWeak,
                                      "charmmonth": newCharmMonth,
                                      "charmhalfyear": newCharmHalfYear,
                                    }).then((value) async {
                                      await _firestore
                                          .collection('user')
                                          .doc(widget.selectedUser[i]!.docID)
                                          .collection('Mygifts')
                                          .doc()
                                          .set({
                                        'id': widget
                                            .gifts[widget.currentindex].docID
                                      }).then((value) async {
                                        await _firestore
                                            .collection('user')
                                            .doc(widget.selectedUser[i]!.docID)
                                            .get()
                                            .then((value) async {
                                          String friendfamily =
                                              value.get('myfamily');
                                          if (friendfamily == "") {
                                          } else {
                                            await _firestore
                                                .collection('family')
                                                .doc(friendfamily)
                                                .collection('count2')
                                                .doc()
                                                .set({
                                              'user':
                                                  widget.selectedUser[i]!.docID,
                                              'day':
                                                  DateTime.now().day.toString(),
                                              'month': DateTime.now()
                                                  .month
                                                  .toString(),
                                              'year': DateTime.now()
                                                  .year
                                                  .toString(),
                                              'coin': widget
                                                  .gifts[widget.currentindex]
                                                  .price
                                            });
                                          }
                                        });
                                      }).then((value) async {
                                        String docs =
                                            "${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                                        if (widget.selectedUser[i]!.type ==
                                            "host") {
                                          int lastincome = 0;
                                          await _firestore
                                              .collection('agency')
                                              .doc(
                                                  widget.selectedUser[i]!.agent)
                                              .collection('users')
                                              .doc(
                                                  widget.selectedUser[i]!.docID)
                                              .collection('income')
                                              .doc(docs)
                                              .get()
                                              .then((value) {
                                            lastincome = int.parse(
                                                    value.get('count')) +
                                                int.parse(widget
                                                    .gifts[widget.currentindex]
                                                    .price);
                                          }).whenComplete(() async {
                                            if (lastincome == 0) {
                                              await _firestore
                                                  .collection('agency')
                                                  .doc(widget
                                                      .selectedUser[i]!.agent)
                                                  .collection('users')
                                                  .doc(widget
                                                      .selectedUser[i]!.docID)
                                                  .collection('income')
                                                  .doc(docs)
                                                  .set({
                                                'date':
                                                    DateTime.now().toString(),
                                                'hosttime': '0',
                                                'numberradio': '0',
                                                'count': widget
                                                    .gifts[widget.currentindex]
                                                    .price,
                                              });
                                            } else {
                                              await _firestore
                                                  .collection('agency')
                                                  .doc(widget
                                                      .selectedUser[i]!.agent)
                                                  .collection('users')
                                                  .doc(widget
                                                      .selectedUser[i]!.docID)
                                                  .collection('income')
                                                  .doc(docs)
                                                  .update({
                                                'count': lastincome.toString()
                                              });
                                            }
                                            // SendDone(context);
                                            // Navigator.pop(context);
                                          });
                                        }
                                        // } else {
                                        //   SendDone(context);
                                        //   Navigator.pop(context);
                                        // }
                                        // }).then((value) async {
                                        //   Navigator.pop(context);
                                        //   widget.controller.message.send(
                                        //       "Send ${widget.gifts[widget.currentindex].Name} to User ${widget.selectedUser[i]!.name}");
                                        //   await _firestore
                                        //       .collection('room')
                                        //       .doc(widget.roomId)
                                        //       .update({
                                        //     'gift': widget
                                        //         .gifts[widget.currentindex].photo,
                                        //     'gifttype': widget
                                        //         .gifts[widget.currentindex].type
                                        //   });
                                        // setState(() {
                                        //   giftMedia = gift.photo;
                                        //   gifttype = gift.type;
                                        // });
                                        SendDone(context);
                                        Future.delayed(
                                                const Duration(seconds: 4))
                                            .then((value) {
                                          _firestore
                                              .collection('room')
                                              .doc(widget.roomId)
                                              .update(
                                                  {'gift': "", 'gifttype': ""});
                                          // setState(() {
                                          //   giftMedia = "";
                                          //   gifttype = "";
                                          // });
                                        }).then((value) {
                                          String docGift =
                                              "${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                                          _firestore
                                              .collection('room')
                                              .doc(widget.roomId)
                                              .collection('gift')
                                              .doc(docGift)
                                              .set({
                                            'giftdoc': widget
                                                .gifts[widget.currentindex]
                                                .docID,
                                            'sender': _auth.currentUser!.uid,
                                            'recever':
                                                widget.selectedUser[i]!.docID
                                          }).then((value) {
                                            _firestore
                                                .collection('user')
                                                .doc(_auth.currentUser!.uid)
                                                .collection('sendgift')
                                                .doc()
                                                .set({
                                              'giftid': widget
                                                  .gifts[widget.currentindex]
                                                  .docID,
                                              'target':
                                                  widget.selectedUser[i]!.docID
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              }
                              // } else {
                              //   NotSend(context);
                              // }
                            }
                          } else {
                            showSnackBar(
                                "No users selcected to recive gift slect user!",
                                context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff2AF69F),
                                Color(0xff14DEBF),
                                Color(0xff04CADB),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: const Text(
                            "Send",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}


  // SliverToBoxAdapter(
  //               child: FutureBuilder(
  //                 future: firestore.collection('gifts').get(),
  //                 builder: (context, snapshot) {
  //                   if (snapshot.hasData) {
  //                     List<GiftModel> gifts = [];
  //                     final masseges = snapshot.data?.docs;
  //                     for (var massege in masseges!.reversed) {
  //                       gifts.add(GiftModel(
  //                           massege.id,
  //                           massege.get('name'),
  //                           massege.get('photo'),
  //                           massege.get('price'),
  //                           massege.get('type')));
  //                     }
  //                     return SizedBox(
  //                       height: 250,
  //                       child: GridView.builder(
  //                         gridDelegate:
  //                             const SliverGridDelegateWithFixedCrossAxisCount(
  //                                 crossAxisCount: 2,
  //                                 crossAxisSpacing: 10,
  //                                 mainAxisSpacing: 10),
  //                         scrollDirection: Axis.horizontal,
  //                         shrinkWrap: true,
  //                         itemCount: gifts.length,
  //                         itemBuilder: (context, index) {
  //                           return GestureDetector(
  //                             onTap: () {
  //                               widget.currentindex = index;
  //                               setState(() {});
  //                             },
  //                             child: CustomtGiftItem(
  //                                 giftData: gifts[index],
  //                                 isSelected: widget.currentindex == index),
  //                           );
  //                         },
  //                       ),
  //                     );
  //                   } else if (snapshot.hasError) {
  //                     return Center(
  //                       child: Text(
  //                         "an error has Ocured with Message ${snapshot.error.toString()}! check enternt ",
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 16),
  //                       ),
  //                     );
  //                   } else {
  //                     return const Center(
  //                       child: CircularProgressIndicator(
  //                         backgroundColor: Colors.blue,
  //                       ),
  //                     );
  //                   }
  //                 },
  //               ),
  //             )