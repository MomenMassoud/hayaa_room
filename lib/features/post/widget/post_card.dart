import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/post/widget/view_coment_body.dart';

import '../../../core/widgets/show_snack_par.dart';
import '../../chat/widget/common/view_photo.dart';
import '../../profile/views/visitor_.view.dart';
import '../data/post_modal.dart';
import '../services/add_like.dart';
import '../services/delete_like.dart';

class PostCard extends StatefulWidget {
  PostModal post;
  int commentCounter;
  int likeCounter;
  final String postId;

  PostCard(this.post, this.commentCounter, this.likeCounter,
      {super.key, required this.postId});
  _PostCard createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    bool isLike = widget.post.likes.containsKey(_auth.currentUser!.uid!);
    final currentLocale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 7.0, left: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VistorView(
                      widget.post.ownerPhoto, currentLocale.languageCode)));
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(widget.post.ownerPhoto),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.post.ownerName,
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Text(
                    "${widget.post.day}/${widget.post.month}/${widget.post.year}")
              ],
            ),
          ),
          widget.post.text.isNotEmpty
              ? const SizedBox(height: 5)
              : const SizedBox(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.13,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.38,
                child: Text(
                  widget.post.text,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
          widget.post.text.isNotEmpty
              ? const SizedBox(height: 8)
              : const SizedBox(),
          widget.post.photo == "none"
              ? Container()
              : Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.13),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ViewPhoto(widget.post.photo)));
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.25,
                            maxWidth: MediaQuery.of(context).size.width * 0.42),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(6),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.post.photo,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
          Row(
            children: [
              Text(widget.likeCounter.toString()),
              IconButton(
                  onPressed: () async {
                    if (isLike == true) {
                      try {
                        await delteLike(widget.postId, _auth.currentUser!.uid,
                            widget.post.toJson());
                        log("delete");
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        showSnackBar(e.toString(), context);
                      }

                      setState(() {
                        isLike = false;
                      });
                    } else {
                      try {
                        // AddLikeServices addLikeServices = AddLikeServices();
                        // Map<String, LikeModal> newLike = {
                        //   _auth.currentUser!.uid: LikeModal(
                        //       email: _auth.currentUser!.email!,
                        //       name: _auth.currentUser!.displayName!,
                        //       photo: _auth.currentUser!.photoURL!)
                        // };

                        // Retrieve the list from Firestore
                        // List<Map<String, dynamic>> dataList =
                        //     await addLikeServices
                        //         .getListFromFirestore(widget.post.id);

                        // // Add the new map to the list
                        // dataList.add(newLike);

                        // Update the list in Firestore
                        // await addLikeServices.updateListInFirestore(
                        //     dataList: dataList,
                        //     likesCounter: widget.post.likesCounter,
                        //     postId: widget.post.id);

                        await addlike(
                            widget.postId,
                            widget.post.toJson(),
                            {
                              "email": _auth.currentUser!.email!,
                              "name": _auth.currentUser!.displayName!,
                              "photo": _auth.currentUser!.photoURL!
                            },
                            _auth.currentUser!.uid);
                        log("add");
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        showSnackBar(e.toString(), context);
                      }
                      // await _firestore
                      //     .collection('post')
                      //     .doc(widget.post.id)
                      //     .collection('like')
                      //     .doc(_auth.currentUser!.uid)
                      //     .set({
                      //   'email': _auth.currentUser!.email,
                      //   'name': _auth.currentUser!.displayName,
                      //   'photo': _auth.currentUser!.photoURL.toString(),
                      // });
                      setState(() {
                        isLike = true;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.recommend,
                    color: isLike ? Colors.red : Colors.grey,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                ViewComment(widget.postId, widget.post)));
                  },
                  icon: const Icon(
                    Icons.comment_rounded,
                    color: Colors.grey,
                  )),
              Text(widget.commentCounter.toString()),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 0.4,
            ),
          ),
        ],
      ),
    );
  }

//   void AddLike() async {
//     if (widget.post.like == true) {
//       try {} catch (e) {
//         showSnackBar(e.toString(), context);
//       }

//       log("delete");
//       setState(() {
//         widget.post.like = false;
//       });
//     } else {
//       try {
//         await addLike(postId: widget.post.id, docId: _auth.currentUser!.uid);
//       } catch (e) {
//         // ignore: use_build_context_synchronously
//         showSnackBar(e.toString(), context);
//       }
//       // await _firestore
//       //     .collection('post')
//       //     .doc(widget.post.id)
//       //     .collection('like')
//       //     .doc(_auth.currentUser!.uid)
//       //     .set({
//       //   'email': _auth.currentUser!.email,
//       //   'name': _auth.currentUser!.displayName,
//       //   'photo': _auth.currentUser!.photoURL.toString(),
//       // });
//       setState(() {
//         widget.post.like = true;
//       });
//       log("add");
//     }
//   }
}
