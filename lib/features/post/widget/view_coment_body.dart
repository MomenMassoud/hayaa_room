import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/comment_model.dart';
import '../data/post_modal.dart';
import '../services/add_comment.dart';

class ViewComment extends StatefulWidget {
  final String postID;
  final PostModal postData;
  ViewComment(this.postID, this.postData);
  _ViewComment createState() => _ViewComment();
}

class _ViewComment extends State<ViewComment> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //UserModel user=UserModel("email", "name", "bio", "id", "gender", "devicetoken", "photo", "seen");
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('post')
              .doc(widget.postID)
              .collection('comment')
              .orderBy(
                "creationTime",
              )
              .snapshots(),
          builder: (context, snapshot) {
            List<CommentModel> comments = [];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              String email = massege.get('email');
              String photo = massege.get('photo');
              String name = massege.get('name');
              String comment = massege.get('comment');
              String creationTime = massege.get('creationTime');
              CommentModel love = CommentModel(
                  email: email,
                  name: name,
                  photo: photo,
                  comment: comment,
                  creationTime: creationTime);
              love.id = massege.id;
              comments.add(love);
            }
            return comments.isNotEmpty
                ? ListView.builder(
                    itemCount: comments.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(comments[index].name),
                              subtitle: Text(comments[index].comment),
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundImage: CachedNetworkImageProvider(
                                    comments[index].photo),
                              ),
                            ),
                            TextFormField(
                              controller: _controller,
                              cursorColor: Colors.blue[900],
                              onChanged: (value) {},
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  hintText: "قم بكتباة التعليق",
                                  filled: true,
                                  fillColor: Colors
                                      .grey[100], // Change the background color
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      try {
                                        log(widget.postID);

                                        // FirebaseService()
                                        //     .storeDataInSubcollection(
                                        //         parentCollectionName: 'post',
                                        //         parentDocumentId: widget.postID,
                                        //         subcollectionName: 'comment',
                                        //         documentId:
                                        //             _auth.currentUser!.uid,
                                        //         data: CommentModel(
                                        //                 email: _auth
                                        //                     .currentUser!
                                        //                     .email!,
                                        //                 name: _auth.currentUser!
                                        //                     .displayName!,
                                        //                 photo: _auth
                                        //                     .currentUser!
                                        //                     .photoURL
                                        //                     .toString(),
                                        //                 comment: _controller
                                        //                     .value.text)
                                        //             .toJson())
                                        //     .then((value) => setState(() {
                                        //           _controller.clear();
                                        //         }));
                                        await _firestore
                                            .collection('post')
                                            .doc(widget.postID)
                                            .collection('comment')
                                            .doc(
                                                "${DateTime.now().toString()}-${_auth.currentUser!.uid}")
                                            .set({
                                          'email': _auth.currentUser!.email,
                                          'photo': _auth.currentUser!.photoURL
                                              .toString(),
                                          'name':
                                              _auth.currentUser!.displayName,
                                          'comment': _controller.value.text,
                                          'creationTime':
                                              DateTime.now().toString()
                                        }).then((value) {
                                          setState(() {
                                            _controller.clear();
                                          });
                                        });
                                        await addComment(
                                            widget.postID,
                                            widget.postData.toJson(),
                                            comments.length);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    icon: const Icon(Icons.send),
                                  )),
                            ),
                          ],
                        );
                      } else {
                        return ListTile(
                          title: Text(comments[index].name),
                          subtitle: Text(comments[index].comment),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundImage: CachedNetworkImageProvider(
                                comments[index].photo),
                          ),
                        );
                      }
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: _controller,
                        cursorColor: Colors.blue[900],
                        onChanged: (value) {},
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "قم بكتباة التعليق",
                            fillColor:
                                Colors.black, // Change the background color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                log(widget.postID);
                                try {
                                  // FirebaseService()
                                  //     .storeDataInSubcollection(
                                  //         parentCollectionName: 'post',
                                  //         parentDocumentId: widget.postID,
                                  //         subcollectionName: 'comment',
                                  //         documentId: _auth.currentUser!.uid,
                                  //         data: CommentModel(
                                  //                 email:
                                  //                     _auth.currentUser!.email!,
                                  //                 name: _auth.currentUser!
                                  //                     .displayName!,
                                  //                 photo: _auth
                                  //                     .currentUser!.photoURL
                                  //                     .toString(),
                                  //                 comment:
                                  //                     _controller.value.text)
                                  //             .toJson())
                                  //     .then((value) => setState(() {
                                  //           _controller.clear();
                                  //         }));
                                  await _firestore
                                      .collection('post')
                                      .doc(widget.postID)
                                      .collection('comment')
                                      .doc(
                                          "${DateTime.now().toString()}-${_auth.currentUser!.uid}")
                                      .set({
                                    'email': _auth.currentUser!.email,
                                    'photo':
                                        _auth.currentUser!.photoURL.toString(),
                                    'name': _auth.currentUser!.displayName,
                                    'comment': _controller.value.text,
                                    'creationTime': DateTime.now().toString()
                                  }).then((value) {
                                    setState(() {
                                      _controller.clear();
                                    });
                                  });
                                  await addComment(
                                      widget.postID,
                                      widget.postData.toJson(),
                                      comments.length);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              icon: Icon(Icons.send),
                            )),
                      ),
                    ],
                  );
          }),
    );
  }
}
