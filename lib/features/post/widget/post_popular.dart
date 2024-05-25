import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:hayaa_main/features/post/widget/post_card.dart';

import '../data/post_modal.dart';

class PostPopular extends StatefulWidget {
  _PostPopular createState() => _PostPopular();
}

class _PostPopular extends State<PostPopular> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: PaginateFirestore(
          query: _firestore.collection('post').orderBy("day", descending: true),
          itemBuilderType: PaginateBuilderType.listView,
          itemsPerPage: 15,
          isLive: true,
          physics: const BouncingScrollPhysics(),
          initialLoader: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          onEmpty: const Text(
            "No posts are created yet!",
            style: TextStyle(fontSize: 24),
          ),
          onError: (e) => Center(
            child: Text(e.toString()),
          ),
          bottomLoader: const Center(
              child: CircularProgressIndicator(color: Colors.lightBlue)),
          itemBuilder: (context, snapshot, index) {
            final Map<String, dynamic> json =
                snapshot[index].data() as Map<String, dynamic>;
            PostModal postModal = PostModal.fromJson(json);

            return PostCard(
              postModal,
              postModal.commetnCounter,
              postModal.likesCounter,
              postId: snapshot[index].id,
            );
          },
        ));
  }
}


// StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('post').snapshots(),
//         builder: (context, snapshot) {
//           List<PostModal> posts = [];
//           if (!snapshot.hasData) {}
//           final masseges = snapshot.data?.docs;
//           for (var massege in masseges?.reversed ?? snapshot.data!.docs) {
//             String ownername = massege.get('owner_name');
//             String owneremail = massege.get('owner_email');
//             String ownerphoto = massege.get('owner_photo');
//             String day = massege.get('day');
//             String month = massege.get('month');
//             String year = massege.get('year');
//             String text = massege.get('text');
//             String photo = massege.get('photo');
//             bool view = false;
//             if (owneremail != _auth.currentUser!.uid.toString()) {
//               view = true;
//             }
//             PostModal postModel = PostModal(
//               ownerName: ownername,
//               ownerEmail: owneremail,
//               ownerPhoto: ownerphoto,
//               text: text,
//               photo: photo,
//               day: day,
//               month: month,
//               year: year,
//               followButton: view,
//             );
//             postModel.id = massege.id;
//             posts.add(postModel);
//           }
//           return ListView.builder(
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: _firestore
//                       .collection('post')
//                       .doc(posts[index].id)
//                       .collection('like')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     int likeCounter = 0;
//                     if (!snapshot.hasData) {
//                       // return const Center(
//                       //   child: CircularProgressIndicator(
//                       //     backgroundColor: Colors.blue,
//                       //   ),
//                       // );
//                     }
//                     final masseges = snapshot.data?.docs;
//                     likeCounter = masseges?.length ?? 0;
//                     int i = 0;
//                     for (var massege in masseges!.reversed) {
//                       String email = massege.get('email');
//                       String photo = massege.get('photo');
//                       String name = massege.get('name');
//                       LikeModal love =
//                           LikeModal(email: email, name: name, photo: photo);
//                       love.id = massege.id;
//                       if (_auth.currentUser!.uid == love.id) {
//                         posts[index].like = true;
//                         posts[index].indexLike = i;
//                       }

//                       posts[index].likes.add({_auth.currentUser!.uid: love});
//                       i++;
//                     }
//                     return StreamBuilder<QuerySnapshot>(
//                       stream: _firestore
//                           .collection('post')
//                           .doc(posts[index].id)
//                           .collection('comment')
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         int commentsCounter = 0;
//                         if (!snapshot.hasData) {
//                           // return const Center(
//                           //   child: CircularProgressIndicator(
//                           //     backgroundColor: Colors.blue,
//                           //   ),
//                           // );
//                         }
//                         final masseges = snapshot.data?.docs;
//                         commentsCounter = masseges?.length ?? 0;
//                         for (var massege in masseges!.reversed) {
//                           String email = massege.get('email');
//                           String photo = massege.get('photo');
//                           String name = massege.get('name');
//                           String comment = massege.get('comment');
//                           CommentModel love = CommentModel(
//                               email: email,
//                               name: name,
//                               photo: photo,
//                               comment: comment);
//                           love.id = massege.id;
//                           posts[index]
//                               .comments
//                               .add({_auth.currentUser!.uid: love});
//                         }
//                         return PostCard(
//                             posts[index], commentsCounter, likeCounter);
//                       },
//                     );
//                   },
//                 );
//               });
//         },
//       ),