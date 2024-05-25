import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../features/rooms/view/room_view.dart';
import '../../models/room_model.dart';
import '../widgets/show_snack_par.dart';

void enterRoomPasswordAllarm(
    {required BuildContext context,
    required RoomModels roomModel,
    required TextEditingController controller,
    required FirebaseFirestore firestore,
    required FirebaseAuth auth}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("ملحوظة"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "ادخل كلمة السر:",
                  ),
                  controller: controller,
                ),
                const SizedBox(height: 70),
                ElevatedButton(
                    onPressed: () {
                      if (roomModel.password == controller.text) {
                        firestore
                            .collection('room')
                            .doc(roomModel.doc)
                            .collection('user')
                            .doc(auth.currentUser!.uid)
                            .set({
                          'id': auth.currentUser!.uid,
                          'type': 'normal'
                        }).then((value) {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RoomView(
                              roomModel.doc,
                              false,
                              auth.currentUser!.displayName.toString(),
                              auth.currentUser!.uid,
                            ),
                          ));
                        });
                      } else {
                        showSnackBar("password is not correct", context);
                      }
                    },
                    child: const Text("ادخال")),
              ],
            ));
      });
}
