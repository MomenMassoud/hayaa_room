import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../../models/store_model.dart';
import '../functions/buying_with_exp.dart';

class WallpaperStore extends StatefulWidget {
  _WallpaperStore createState() => _WallpaperStore();
}

class _WallpaperStore extends State<WallpaperStore> {
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
            .where('cat', isEqualTo: 'wallpaper')
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
                                store[index].price,
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                false,
                                store[index].docID,
                                store[index].price);
                          }
                          final masseges = snapshot.data?.docs;
                          if (masseges!.isEmpty) {
                            return _buildCard(
                                store[index].price,
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                false,
                                store[index].docID,
                                store[index].price);
                          } else {
                            return _buildCard(
                                ' ${store[index].price}',
                                store[index].photo,
                                store[index].cat,
                                store[index].time,
                                context,
                                true,
                                store[index].docID,
                                store[index].price);
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

  Widget _buildCard(String price, String imgPath, String category, String days,
      BuildContext context, bool buy, String id, String pp) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
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
          children: [
            Text(
              days == "always" ? days : "$days Day",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8),
            Hero(
              tag: imgPath,
              child: Container(
                height: 55,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imgPath),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
            const Divider(
              indent: 10,
              endIndent: 10,
              color: Color(0xFFEBEBEB),
            ),
            ElevatedButton(
              onPressed: () async {
                bool always = false;
                if (days == "always") {
                  always = true;
                }
                // Allarm(id, imgPath, days, always, DateTime.now().toString(),
                //     int.parse(pp));

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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Allarm(String id, String path, String dead, bool always, String time,
      int price) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("سوف تقوم بشراء هذا العنصر هل انت متاكد"),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (coins >= price) {
                              coins = coins - price;

                              //updating current user data
                              await _firestore
                                  .collection("user")
                                  .doc(_auth.currentUser!.uid)
                                  .update({
                                'coin': coins.toString(),
                              });
                              await _firestore
                                  .collection('user')
                                  .doc(_auth.currentUser!.uid)
                                  .collection('mylook')
                                  .doc(id)
                                  .set({
                                'photo': path,
                                'id': id,
                                'dead': dead,
                                'always': always.toString(),
                                'cat': 'wallpaper',
                                'time': DateTime.now().toString(),
                              }).then((value) {
                                Navigator.pop(context);
                                SendDone();
                              });
                            } else {
                              Navigator.pop(context);
                              NotSend();
                            }
                          },
                          child: const Text("شراء")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("الغاء")),
                    ],
                  )
                ],
              ));
        });
  }

  void SendDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("مبروك"),
              content: Container(
                height: 120,
                child: const Center(
                  child: Text("تم شراء العنصر بنجاح"),
                ),
              ));
        });
  }

  void NotSend() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("ناسف"),
              content: Container(
                height: 120,
                child: const Center(
                  child: Text("ناسف برجاء لا تملك عملات كافية"),
                ),
              ));
        });
  }
}


// Padding(
//       padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5.0, right: 5.0),
//       child: InkWell(
//         onTap: () {
//           // Add your onTap logic here
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 3.0,
//                 blurRadius: 5.0,
//               ),
//             ],
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Text(
//                   days == "always" ? days : "$days Day",
//                   style: const TextStyle(
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ),
//               Hero(
//                 tag: imgPath,
//                 child: Container(
//                   height: 75,
//                   width: 75,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: CachedNetworkImageProvider(imgPath),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 7.0),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     price,
//                     style: const TextStyle(
//                       color: Color(0xFFCC8053),
//                       fontFamily: 'Varela',
//                       fontSize: 14.0,
//                     ),
//                   ),
//                   const CircleAvatar(
//                     radius: 8,
//                     backgroundImage: AssetImage(AppImages.gold_coin),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Container(
//                   color: const Color(0xFFEBEBEB),
//                   height: 1.0,
//                 ),
//               ),
//               // Add the button and days here
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       bool always = false;
//                       if (days == "always") {
//                         always = true;
//                       }
//                       Allarm(id, imgPath, days, always,
//                           DateTime.now().toString(), pp);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade300,
//                       foregroundColor: Colors.white,
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: const Text(
//                       'Buy Now',
//                       style: TextStyle(
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                   // You can replace '30 Days' with your desired text
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );