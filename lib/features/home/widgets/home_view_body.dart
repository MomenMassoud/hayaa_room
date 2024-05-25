import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../models/user_model.dart';
import '../../rooms/view/create_room_view.dart';
import '../../rooms/view/room_view.dart';
import '../../search/view/search_view.dart';
import '../views/hot_view.dart';
import '../views/nearby_view.dart';
import '../views/related_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with SingleTickerProviderStateMixin {
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
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    start();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchView.id);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                if (userModel.myroom == "") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const CreateRoomView())).then((value) {
                    start();
                  });
                } else {
                  _firestore
                      .collection('room')
                      .doc(userModel.myroom)
                      .collection('user')
                      .doc(_auth.currentUser!.uid)
                      .set({
                    'id': userModel.id,
                    'type': 'owner',
                    "takeSeatRequst": false
                  }).then((value) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RoomView(
                        userModel.myroom ?? "",
                        true,
                        userModel.name,
                        _auth.currentUser!.uid,
                      ),
                    ));
                  });
                }
              },
              icon: userModel.myroom == ""
                  ? const Icon(
                      Icons.add_home_outlined,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.14,
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.only(right: 10),
            unselectedLabelColor: const Color(0xFFCDCDCD),
            dividerHeight: 0,
            indicatorWeight: 0,
            indicator: const BoxDecoration(),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Tab(
                  child: const Text(
                    "شعبي",
                    style: TextStyle(
                      fontFamily: "Hayah",
                      fontSize: 22,
                    ),
                  ).tr(args: ['شعبي']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Tab(
                  child: const Text(
                    "متعلق",
                    style: TextStyle(
                      fontFamily: "Hayah",
                      fontSize: 20,
                    ),
                  ).tr(args: ['متعلق']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Tab(
                  child: const Text(
                    "مجاورون",
                    style: TextStyle(fontFamily: "Hayah", fontSize: 20),
                  ).tr(args: ['مجاورون']),
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(controller: _tabController, children: const [
        HotViewBody(),
        RelatedView(),
        NearByView(),
      ]),
    );
  }
}
