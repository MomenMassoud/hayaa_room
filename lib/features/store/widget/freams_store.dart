import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/store/widget/send_item_store.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../../../core/Utils/app_images.dart';
import '../../../models/store_model.dart';
import '../functions/buying_with_exp.dart';

class FrameStore extends StatefulWidget {
  _FrameStore createState() => _FrameStore();
}

class _FrameStore extends State<FrameStore> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int coins = 0;
  String myVip = "";
  int myExp = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        coins = int.parse(snap.get('coin'));
        myVip = snap.get("vip");
        myExp = int.parse(snap.get('exp'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('store')
            .where('cat', isEqualTo: 'frame')
            .snapshots(),
        builder: (context, snapshot) {
          List<StoreModel> store = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            store.add(StoreModel(
                massege.get('photo'),
                massege.get('type'),
                massege.id,
                massege.get('price'),
                massege.get('time'),
                massege.get('cat')));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 10, left: 10),
            child: store.isNotEmpty
                ? GridView.builder(
                    itemCount: store.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('user')
                            .doc(_auth.currentUser!.uid)
                            .collection('mylook')
                            .where('id', isEqualTo: store[index].docID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return _buildCard(
                                '${store[index].price}',
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                false,
                                store[index].docID,
                                store[index].price,
                                store[index].type,
                                store[index]);
                          }
                          final masseges = snapshot.data?.docs;
                          if (masseges!.isEmpty) {
                            return _buildCard(
                                '${store[index].price}',
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                false,
                                store[index].docID,
                                store[index].price,
                                store[index].type,
                                store[index]);
                          } else {
                            return _buildCard(
                                '${store[index].price}',
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                true,
                                store[index].docID,
                                store[index].price,
                                store[index].type,
                                store[index]);
                          }
                        },
                      );
                    })
                : const Center(
                    child: Text("لا يوجد بيانات"),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCard(
      String price,
      String imgPath,
      String category,
      String days,
      BuildContext context,
      bool buy,
      String id,
      String pp,
      String type,
      StoreModel ss) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          // Add your onTap logic here
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  days == "always" ? days : "$days Day",
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
              type == "svga"
                  ? CircleAvatar(
                      radius: 32,
                      child: SVGASimpleImage(
                        resUrl: imgPath,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: imgPath,
                      width: 50,
                      height: 40,
                    ),
              const SizedBox(height: 7.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFCC8053),
                      fontFamily: 'Varela',
                      fontSize: 14.0,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 8,
                    backgroundImage: AssetImage(AppImages.gold_coin),
                  )
                ],
              ),
              const Spacer(),
              Container(
                color: const Color(0xFFEBEBEB),
                height: 1.0,
              ),
              // Add the button and days here
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool always = false;
                      if (days == "always") {
                        always = true;
                      }
                      buyingwithexp(
                          id,
                          imgPath,
                          days,
                          always,
                          DateTime.now().toString(),
                          int.parse(pp),
                          context,
                          coins,
                          myVip,
                          myExp,
                          category,
                          _firestore,
                          _auth);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 10, // Set the font size of the text
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendItemStore(ss)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 10, // Set the font size of the text
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
