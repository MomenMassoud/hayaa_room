import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'buying_done.dart';
import 'not_send.dart';

void buyingwithexp(
    String id,
    String path,
    String dead,
    bool always,
    String time,
    int price,
    BuildContext context,
    int coins,
    String myVip,
    int myExp,
    String category,
    FirebaseFirestore firestore,
    FirebaseAuth auth) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("ملحوظة"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("سوف تقوم بشراء هذا العنصر هل انت متاكد"),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (coins >= price) {
                            coins = coins - price;
                            if (myVip == "1") {
                              myExp = myExp + (price * 1.15).toInt();
                            } else if (myVip == "2") {
                              myExp = myExp + (price * 1.125).toInt();
                            } else if (myVip == "3") {
                              myExp = myExp + (price * 1.50).toInt();
                            } else if (myVip == "4") {
                              myExp = myExp + (price * 1.75).toInt();
                            } else {
                              myExp = myExp + price;
                            }

                            //updating current user data
                            await firestore
                                .collection("user")
                                .doc(auth.currentUser!.uid)
                                .update({
                              'coin': coins.toString(),
                              'exp': myExp.toString(),
                            });
                            await firestore
                                .collection('user')
                                .doc(auth.currentUser!.uid)
                                .collection('mylook')
                                .where('id', isEqualTo: id)
                                .get()
                                .then((value) {
                              if (value.size == 0) {
                                firestore
                                    .collection('user')
                                    .doc(auth.currentUser!.uid)
                                    .collection('mylook')
                                    .doc(id)
                                    .set({
                                  'photo': path,
                                  'id': id,
                                  'dead': dead,
                                  'cat': category,
                                  'always': always.toString(),
                                  'time': DateTime.now().toString(),
                                }).then((value) {
                                  Navigator.pop(context);
                                  SendDone(context);
                                });
                              } else {
                                int day = int.parse(value.docs[0].get('dead'));
                                day += int.parse(dead);
                                firestore
                                    .collection('user')
                                    .doc(auth.currentUser!.uid)
                                    .collection('mylook')
                                    .doc(id)
                                    .update({'dead': day.toString()}).then(
                                        (value) {
                                  Navigator.pop(context);
                                  SendDone(context);
                                });
                              }
                            });
                          } else {
                            Navigator.pop(context);
                            NotSend(context);
                          }
                        },
                        child: Text("شراء")),
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
