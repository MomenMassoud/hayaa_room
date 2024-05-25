import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/firends_model.dart';
import '../../store/functions/buying_done.dart';
import '../../store/functions/not_send.dart';

class SendVip extends StatefulWidget {
  String vip;
  int vipCoin;
  SendVip(this.vip, this.vipCoin, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SendVip createState() => _SendVip();
}

class _SendVip extends State<SendVip> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();
  String value = "";
  String myID = "";
  String myName = "";
  String myPhoto = "";
  int myCoins = 0;
  String myVip = "";
  int myExp = 0;
  int exp2 = 0;
  String reciverVip = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        myID = value.get('id');
        myName = value.get('name');
        myPhoto = value.get('photo');
        myCoins = int.parse(value.get('coin'));
        myVip = value.get("vip");
        myExp = int.parse(value.get("exp"));
      });
    });
  }

  void performSearch(String searchTerm) {
    // Add your search logic here
    print('Searching for: $searchTerm');
    setState(() {
      value = searchTerm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ID',
              ),
              onChanged: performSearch,
            ),
          ),
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .where('id', isGreaterThanOrEqualTo: value)
                  .where('id', isLessThanOrEqualTo: value + '\uf8ff')
                  .snapshots(),
              builder: (context, snapshot) {
                List<FriendsModel> searchfriends = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  String em = massege.get('id');
                  if (em == myID) {
                  } else {
                    FriendsModel friend = FriendsModel(
                        massege.get('email'),
                        massege.get('id'),
                        massege.id,
                        massege.get('photo'),
                        massege.get('name'),
                        massege.get('phonenumber'),
                        massege.get('gender'));
                    friend.bio = massege.get('bio');
                    searchfriends.add(friend);
                  }
                }
                return searchfriends.length == 0
                    ? const Text("No Data Found")
                    : ListView.builder(
                        itemCount: searchfriends.length,
                        itemBuilder: (context, index) {
                          if (searchfriends[index].id == myID) {
                            return const Text("");
                          } else {
                            return ListTile(
                              onTap: () {
                                Allarm(searchfriends[index]);
                              },
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    searchfriends[index].photo),
                              ),
                              title: Text(searchfriends[index].name),
                              subtitle: Text(searchfriends[index].bio),
                              trailing: ElevatedButton(
                                  onPressed: () {
                                    Allarm(searchfriends[index]);
                                  },
                                  child: const Text("Send")),
                            );
                          }
                        });
              },
            ),
          ),
        ],
      ),
    );
  }

  void Allarm(FriendsModel friend) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("سوف تقوم ارسال هذا العنصر هل انت متاكد"),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            int month = now.month + 1;
                            DateTime end = DateTime(
                                now.year,
                                month,
                                now.day,
                                now.hour,
                                now.minute,
                                now.second,
                                now.millisecond,
                                now.microsecond);
                            if (myCoins >= widget.vipCoin) {
                              myCoins = myCoins - widget.vipCoin;
                              if (myVip == "1") {
                                myExp = myExp + (widget.vipCoin * 1.15).toInt();
                              } else if (myVip == "2") {
                                myExp =
                                    myExp + (widget.vipCoin * 1.125).toInt();
                              } else if (myVip == "3") {
                                myExp = myExp + (widget.vipCoin * 1.50).toInt();
                              } else if (myVip == "4") {
                                myExp = myExp + (widget.vipCoin * 1.75).toInt();
                              } else {
                                myExp = myExp + widget.vipCoin;
                              }

                              _firestore
                                  .collection('user')
                                  .doc(_auth.currentUser!.uid)
                                  .update({
                                'coin': myCoins.toString(),
                                'exp': myExp.toString(),
                              }).then((value) {
                                _firestore
                                    .collection('user')
                                    .doc(_auth.currentUser!.uid)
                                    .collection('payment')
                                    .doc()
                                    .set({
                                  'bio': 'send ${widget.vip} to ${friend.name}',
                                  'date': DateTime.now().toString(),
                                  'pay': 'out',
                                  'type': 'coin',
                                  'value': widget.vipCoin.toString(),
                                }).then((value) {
                                  log(friend.docID);
                                  _firestore
                                      .collection("user")
                                      .doc(friend.docID)
                                      .get()
                                      .then((value) {
                                    setState(() {
                                      exp2 = int.parse(value.get("exp2"));

                                      reciverVip = value.get("vip");
                                    });

                                    log("exp2:$exp2");
                                    log("reciverVip:$reciverVip");
                                    // updating exp2  with new value
                                    if (reciverVip == "1") {
                                      exp2 = exp2 +
                                          (widget.vipCoin / 3.47826087).round();
                                    } else if (reciverVip == "2") {
                                      exp2 = exp2 +
                                          (widget.vipCoin / 3.55555556).round();
                                    } else if (reciverVip == "3") {
                                      exp2 = exp2 +
                                          (widget.vipCoin / 2.66666667).round();
                                    } else if (reciverVip == "4") {
                                      exp2 = exp2 +
                                          (widget.vipCoin / 2.28571429).round();
                                    } else {
                                      exp2 =
                                          exp2 + (widget.vipCoin / 4).round();
                                    }

                                    _firestore
                                        .collection('user')
                                        .doc(friend.docID)
                                        .update({
                                      'vip': widget.vip,
                                      'vip_end': end.toString(),
                                      'exp2': exp2.toString(),
                                    }).then((value) {
                                      Navigator.pop(context);
                                      SendDone(context);
                                    });
                                  });
                                });
                              });
                            } else {
                              Navigator.pop(context);
                              NotSend(context);
                            }
                          },
                          child: Text("ارسال")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("الغاء")),
                    ],
                  )
                ],
              ));
        });
  }
}
