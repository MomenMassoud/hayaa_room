import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/widgets/room_card.dart';

import '../../../models/room_model.dart';

class VerticalRoomsListItem extends StatelessWidget {
  VerticalRoomsListItem({
    super.key,
    required this.screenHight,
    required this.screenWidth,
    required this.roomModel,
    required this.index,
  });
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final double screenHight;
  final double screenWidth;
  final RoomModels roomModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int index;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return RoomCard(roomModel: roomModel);
  }
}

//code for room converted into customwidget roomcard
//  Padding(
//       padding: const EdgeInsets.all(6),
//       child: GestureDetector(
//         onTap: () {
//           if (roomModel.password == "") {
//             _firestore
//                 .collection('room')
//                 .doc(roomModel.doc)
//                 .collection('user')
//                 .doc(_auth.currentUser!.uid)
//                 .set({'id': _auth.currentUser!.uid, 'type': 'normal'}).then(
//                     (value) {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => RoomView(
//                   roomModel.doc,
//                   false,
//                   _auth.currentUser!.displayName.toString(),
//                   _auth.currentUser!.uid,
//                 ),
//               ));
//             });
//           } else {
//             enterRoomPasswordAllarm(
//                 context: context,
//                 roomModel: roomModel,
//                 controller: _controller,
//                 auth: _auth,
//                 firestore: _firestore);
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: CachedNetworkImageProvider(roomModel.photo),
//                 fit: BoxFit.cover),
//             color: Colors.amber,
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10),
//             ),
//           ),
//           height: screenHight * 0.12,
//           width: screenWidth * 0.42,
//         ),
//       ),
//     );
