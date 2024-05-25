import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/room_model.dart';
import '../../../models/user_model.dart';
import '../models/room_model.dart';
import '../widgets/horezintal_rooms_section.dart';
import '../widgets/horizontal_event_slider.dart';
import '../widgets/sub_screens_section.dart';
import '../widgets/vertical_rooms_list_view_builder.dart';

class HotViewBody extends StatefulWidget {
  const HotViewBody({
    super.key,
  });

  @override
  State<HotViewBody> createState() => _HotViewBodyState();
}

class _HotViewBodyState extends State<HotViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel userModel = UserModel(
      "email",
      "name",
      "gende",
      "photo",
      "id",
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

  @override
  void initState() {
    super.initState();
    start();
    getEvent();
  }

  @override
  void dispose() {
    start();
    super.dispose();
  }

  void start() async {
    if (_auth.currentUser!.email == null) {
      await for (var snap in _firestore
          .collection('user')
          .where('phonenumber', isEqualTo: _auth.currentUser!.phoneNumber)
          .snapshots()) {
        userModel.bio = snap.docs[0].get('bio');
        userModel.birthdate = snap.docs[0].get('birthdate');
        userModel.coin = snap.docs[0].get('coin');
        userModel.country = snap.docs[0].get('country');
        userModel.daimond = snap.docs[0].get('daimond');
        userModel.devicetoken = snap.docs[0].get('devicetoken');
        userModel.email = snap.docs[0].get('email');
        userModel.exp = snap.docs[0].get('exp');
        userModel.gender = snap.docs[0].get('gender');
        userModel.id = snap.docs[0].get('id');
        userModel.lang = snap.docs[0].get('lang');
        userModel.level = snap.docs[0].get('level');
        userModel.name = snap.docs[0].get('name');
        userModel.phonenumber = snap.docs[0].get('phonenumber');
        userModel.photo = snap.docs[0].get('photo');
        userModel.seen = snap.docs[0].get('seen');
        userModel.type = snap.docs[0].get('type');
        userModel.vip = snap.docs[0].get('vip');
        setState(() {
          userModel.myroom = snap.docs[0].get('room');
          log(userModel.myroom);
        });
      }
    } else {
      await for (var snap in _firestore
          .collection('user')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .snapshots()) {
        userModel.bio = snap.docs[0].get('bio');
        userModel.birthdate = snap.docs[0].get('birthdate');
        userModel.coin = snap.docs[0].get('coin');
        userModel.country = snap.docs[0].get('country');
        userModel.daimond = snap.docs[0].get('daimond');
        userModel.devicetoken = snap.docs[0].get('devicetoken');
        userModel.email = snap.docs[0].get('email');
        userModel.exp = snap.docs[0].get('exp');
        userModel.gender = snap.docs[0].get('gender');
        userModel.id = snap.docs[0].get('id');
        userModel.lang = snap.docs[0].get('lang');
        userModel.level = snap.docs[0].get('level');
        userModel.name = snap.docs[0].get('name');
        userModel.phonenumber = snap.docs[0].get('phonenumber');
        userModel.photo = snap.docs[0].get('photo');
        userModel.seen = snap.docs[0].get('seen').toString();
        userModel.type = snap.docs[0].get('type');
        userModel.vip = snap.docs[0].get('vip');
        setState(() {
          userModel.myroom = snap.docs[0].get('room');
        });
      }
    }
    setState(() {
      userModel;
    });
  }

  void getEvent() async {
    await for (var snap in _firestore.collection('event').snapshots()) {
      for (int i = 0; i < snap.size; i++) {
        setState(() {
          images.add(snap.docs[i].get('photo'));
        });
      }
    }
  }

  List<String> images = [];
  // List<String> countryCodes = Flags.flagsCode;
  List<RoomModel> rooms = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
  ];
  List<RoomModel> rooms2 = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage4),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .where('doc', isEqualTo: _auth.currentUser!.uid)
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
          userModel.myroom = massege.get('room');
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('event').snapshots(),
          builder: (context, snapshot) {
            List<String> img = [];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              img.add(massege.get('photo'));
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('room')
                  .where('owner', isNotEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                List<RoomModels> roomss = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  roomss.add(RoomModels(
                      massege.get('id'),
                      massege.id,
                      massege.get('gift'),
                      massege.get('gifttype'),
                      massege.get('cartype'),
                      massege.get('wallpaper'),
                      massege.get('password'),
                      massege.get('owner'),
                      massege.get('bio'),
                      massege.get('car'),
                      massege.get('seat'),
                      massege.get('photo')));
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: HorizontalEventSlider(
                              screenHight: MediaQuery.of(context).size.height,
                              screenWidth: MediaQuery.of(context).size.width,
                              images: img),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 8.0, left: 8.0),
                          child: SubScreensSection(
                            screenHight: MediaQuery.of(context).size.height,
                            screenWidth: MediaQuery.of(context).size.width,
                            evetsImages: images,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, right: 8.0, left: 8.0),
                          child: HorezintalSection(
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHight: MediaQuery.of(context).size.height,
                              rooms: rooms),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, right: 8.0, left: 8.0, bottom: 8.0),
                          child: VerticalRoomsListViewBuilder(
                              rooms: roomss,
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHight: MediaQuery.of(context).size.height),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0, bottom: 18),
                          child: HorizontalEventSlider(
                              screenHight: MediaQuery.of(context).size.height,
                              screenWidth: MediaQuery.of(context).size.width,
                              images: img),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: VerticalRoomsListViewBuilder(
                              rooms: roomss,
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHight: MediaQuery.of(context).size.height),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ));
  }

  void CreateRoom() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("تنبيه"),
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("هل تود انشاء غرفتك"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              String roomID =
                                  "${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                              _firestore.collection('room').doc(roomID).set({
                                'id': userModel.id,
                                'doc': roomID,
                                'owner': _auth.currentUser!.uid
                              }).then((value) {
                                _firestore
                                    .collection('user')
                                    .doc(_auth.currentUser!.uid)
                                    .update({'room': roomID}).then((value) {
                                  setState(() {
                                    userModel.myroom = roomID;
                                  });
                                  Navigator.pop(context);
                                });
                              });
                            },
                            child: const Text("نعم")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("لا"))
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void goToNextPage(context, Widget nextpage) async {
    var refresh = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => nextpage));
    if (refresh) setState(() {});
  }
}
