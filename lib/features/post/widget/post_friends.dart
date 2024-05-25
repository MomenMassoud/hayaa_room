import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostFriends extends StatefulWidget {
  _PostFriends createState() => _PostFriends();
}

class _PostFriends extends State<PostFriends> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18.0),
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('user')
//             .doc(_auth.currentUser!.uid)
//             .collection('friends')
//             .snapshots(),
//         builder: (context, snapshot) {
//           List<UserModel> users = [];
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.blue,
//               ),
//             );
//           }
//           final masseges = snapshot.data?.docs;
//           for (var massege in masseges!.reversed) {
//             final us = UserModel(
//                 "email",
//                 "name",
//                 "gender",
//                 "photo",
//                 " massege.get('id')",
//                 "phonenumber",
//                 "devicetoken",
//                 "daimond",
//                 "vip",
//                 "bio",
//                 "seen",
//                 "lang",
//                 "country",
//                 "type",
//                 "birthdate",
//                 "coin",
//                 "exp",
//                 "level");
//             us.docID = massege.id;
//             users.add(us);
//           }
//           return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: _firestore
//                       .collection('user')
//                       .where('doc', isEqualTo: users[index].id)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           backgroundColor: Colors.blue,
//                         ),
//                       );
//                     }
//                     final masseges = snapshot.data?.docs;
//                     for (var massege in masseges!.reversed) {
//                       users[index].docID = massege.id;
//                     }
//                     return StreamBuilder<QuerySnapshot>(
//                       stream: _firestore
//                           .collection('post')
//                           .where('owner_email', isEqualTo: users[index].docID)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         List<PostModal> posts = [];
//                         if (!snapshot.hasData) {
//                           return const Center(
//                             child: CircularProgressIndicator(
//                               backgroundColor: Colors.blue,
//                             ),
//                           );
//                         }
//                         final masseges = snapshot.data?.docs;
//                         for (var massege in masseges!.reversed) {
//                           String ownername = massege.get('owner_name');
//                           String owneremail = massege.get('owner_email');
//                           String ownerphoto = massege.get('owner_photo');
//                           String day = massege.get('day');
//                           String month = massege.get('month');
//                           String year = massege.get('year');
//                           String text = massege.get('text');
//                           String photo = massege.get('photo');
//                           bool view = false;
//                           if (owneremail != _auth.currentUser!.uid.toString()) {
//                             view = true;
//                           }
//                           PostModal postModel = PostModal(
//                             ownerName: ownername,
//                             ownerEmail: owneremail,
//                             ownerPhoto: ownerphoto,
//                             text: text,
//                             photo: photo,
//                             day: day,
//                             month: month,
//                             year: year,
//                             followButton: view,
//                           );
//                           postModel.id = massege.id;
//                           posts.add(postModel);
//                         }
//                         if (index == users.length - 1) {
//                           return Container(
//                             height: 2000,
//                             child: ListView.builder(
//                                 itemCount: posts.length,
//                                 itemBuilder: (context, indexx) {
//                                   return StreamBuilder<QuerySnapshot>(
//                                     stream: _firestore
//                                         .collection('post')
//                                         .doc(posts[indexx].id)
//                                         .collection('like')
//                                         .snapshots(),
//                                     builder: (context, snapshot) {
//                                       int likeCounter = 0;
//                                       if (!snapshot.hasData) {
//                                         return const Center(
//                                           child: CircularProgressIndicator(
//                                             backgroundColor: Colors.blue,
//                                           ),
//                                         );
//                                       }
//                                       final masseges = snapshot.data?.docs;
//                                       likeCounter = masseges!.length;
//                                       int i = 0;
//                                       for (var massege in masseges!.reversed) {
//                                         String email = massege.get('email');
//                                         String photo = massege.get('photo');
//                                         String name = massege.get('name');
//                                         LikeModal love = LikeModal(
//                                             email: email,
//                                             name: name,
//                                             photo: photo);
//                                         love.id = massege.id;
//                                         if (_auth.currentUser!.uid == love.id) {
//                                           posts[indexx].like = true;
//                                           posts[indexx].indexLike = i;
//                                         }
//                                         posts[indexx].likes[_auth.currentUser!.uid]= love;
//                                         i++;
//                                       }
//                                       return StreamBuilder<QuerySnapshot>(
//                                         stream: _firestore
//                                             .collection('post')
//                                             .doc(posts[indexx].id)
//                                             .collection('comment')
//                                             .snapshots(),
//                                         builder: (context, snapshot) {
//                                           int commentCounter = 0;
//                                           if (!snapshot.hasData) {
//                                             return const Center(
//                                               child: CircularProgressIndicator(
//                                                 backgroundColor: Colors.blue,
//                                               ),
//                                             );
//                                           }
//                                           final masseges = snapshot.data?.docs;
//                                           commentCounter = masseges!.length;
//                                           for (var massege
//                                               in masseges!.reversed) {
//                                             String email = massege.get('email');
//                                             String photo = massege.get('photo');
//                                             String name = massege.get('name');
//                                             String comment =
//                                                 massege.get('comment');
//                                             CommentModel love = CommentModel(
//                                                 email: email,
//                                                 name: name,
//                                                 photo: photo,
//                                                 comment: comment);
//                                             love.id = massege.id;
//                                             posts[indexx].comments[_auth.currentUser!.uid]= love;
//                                           }
//                                           print("Post ${posts.length}");
//                                           return Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: PostCard(posts[indexx],
//                                                 commentCounter, likeCounter),
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 }),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       },
//                     );
//                   },
//                 );
//               });
//         },
//       ),
//     );
//   }
// }
