import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:svgaplayer_flutter/player.dart';
import '../../../../core/Utils/app_images.dart';
import '../../../../models/firends_model.dart';
import '../../../../models/gift_model.dart';
import '../../../../models/massege_model.dart';
import '../../../../models/recorder_model.dart';
import '../../../../models/user_model.dart';
import '../common/own_audio.dart';
import '../common/own_file.dart';
import '../common/own_gift_card.dart';
import '../common/own_link.dart';
import '../common/own_massege.dart';
import '../common/replay_audio.dart';
import '../common/replay_card.dart';
import '../common/replay_file_card.dart';
import '../common/replay_gift_card.dart';
import '../common/replay_link.dart';
import 'chat_setting.dart';

class ChatBody extends StatefulWidget {
  FriendsModel friend;
  ChatBody(this.friend);
  _ChatBody createState() => _ChatBody();
}

class _ChatBody extends State<ChatBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel userModel;
  late num welthDay;
  late num charmDay;
  late num welthWeak;
  late num charmWeak;
  late num welthMonth;
  late num charmMonth;
  late num welthHalfYear;
  late num cahrmHalfYear;
  String chatID = "";
  bool IsRecording = false;
  bool type = false;
  String msg = "";
  final TextEditingController _controller = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? _image;
  bool _showspinner = false;
  final audioPlayer = AudioPlayer();
  final recordMethod = Recorder();
  String firendType = "";
  String friendAgency = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckType();
    checkContact();

    recordMethod.initRecorder();
  }

  void CheckType() async {
    await for (var snap
        in _firestore.collection('user').doc(widget.friend.docID).snapshots()) {
      print("hhhh");
      firendType = snap.get('type');
      friendAgency = snap.get('myagent');
    }
  }

  void checkContact() async {
    if (_auth.currentUser!.uid.toLowerCase().codeUnits[0] >
        widget.friend.docID.toLowerCase().codeUnits[0]) {
      setState(() {
        chatID = "${_auth.currentUser!.uid}${widget.friend.docID}";
      });
    } else {
      setState(() {
        chatID = "${widget.friend.docID}${_auth.currentUser!.uid}";
      });
    }
    await _firestore
        .collection('chat')
        .where('chatroom', isEqualTo: chatID)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _firestore
            .collection('contacts')
            .doc("${_auth.currentUser!.uid}${widget.friend.docID}")
            .set({
          'owner': _auth.currentUser!.uid,
          'mycontact': widget.friend.docID,
          'lastmsg': '',
          'type': 'msg',
          'time': '',
          'chatroom': chatID,
          'clock': FieldValue.serverTimestamp(),
        }).then((value) {
          _firestore
              .collection('contacts')
              .doc('${widget.friend.docID}${_auth.currentUser!.uid}')
              .set({
            'owner': widget.friend.docID,
            'mycontact': _auth.currentUser!.uid,
            'lastmsg': '',
            'type': 'msg',
            'time': '',
            'chatroom': chatID,
            'clock': FieldValue.serverTimestamp(),
          });
        });
      }
    });
    print(chatID);
  }

  @override
  Widget build(BuildContext context) {
    var IsRecording = recordMethod.isRecording;
    recordMethod.useremail = _auth.currentUser!.uid;
    recordMethod.target = widget.friend.docID;
    recordMethod.isGroup = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.friend.name,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        bottomOpacity: 2,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ChatSetting.id);
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black,
              ))
        ],
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 160,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _auth.currentUser!.email == null
                        ? _firestore
                            .collection('user')
                            .where('email',
                                isEqualTo: _auth.currentUser!.phoneNumber)
                            .snapshots()
                        : _firestore
                            .collection('user')
                            .where('email', isEqualTo: _auth.currentUser!.email)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        userModel = UserModel(
                            "email",
                            "name",
                            "gende",
                            "photo",
                            "id",
                            "phonenumber",
                            "devicetoken",
                            "daimond",
                            "vip",
                            "bio",
                            "seen",
                            "lang",
                            "country",
                            "type",
                            "birthdate",
                            "coin",
                            "exp",
                            "level");

                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed) {
                        userModel.bio = massege.get('bio');
                        userModel.birthdate = massege.get('birthdate');
                        userModel.coin = massege.get('coin');
                        userModel.country = massege.get('country');
                        userModel.daimond = massege.get('daimond');
                        userModel.coin = massege.get('coin');
                        userModel.devicetoken = massege.get('devicetoken');
                        userModel.email = massege.get('email');
                        userModel.exp = massege.get('exp');
                        userModel.gender = massege.get('gender');
                        userModel.id = massege.get('id');
                        userModel.lang = massege.get('lang');
                        userModel.level = massege.get('level');
                        userModel.name = massege.get('name');
                        userModel.phonenumber = massege.get('phonenumber');
                        userModel.photo = massege.get('photo');
                        userModel.seen = massege.get('seen').toString();
                        userModel.type = massege.get('type');
                        userModel.vip = massege.get('vip');
                        userModel.myfamily = massege.get('myfamily');
                        userModel.docID = massege.id;
                        welthDay = massege.get("welthday");
                        welthWeak = massege.get("welthweak");
                        welthMonth = massege.get("welthmonth");
                        welthHalfYear = massege.get("welthhalfyear");
                        log("welthDay:$welthDay");
                        log("welthWeak:$welthWeak");
                        log("welthMonth:$welthMonth");
                        log("welthHalfYear:$welthHalfYear");
                      }
                      return StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('chat')
                            .where('chatroom', isEqualTo: chatID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          List<MessageModel> massegeWidget = [];
                          final masseges = snapshot.data?.docs;
                          for (var massege in masseges!.reversed) {
                            final massegeText = massege.get('msg');
                            final massegetype = massege.get('type');
                            final massegetime = massege.get('time');
                            final sender = massege.get('sender');
                            final seen = massege.get('seen');
                            final delete1 = massege.get('delete1');
                            final delete2 = massege.get('delete2');
                            final MessageModel massegeWidgetdata = MessageModel(
                                massegeText, massegetype, massegetime);
                            if (sender == _auth.currentUser!.uid) {
                              massegeWidgetdata.type = "source";
                            } else {
                              massegeWidgetdata.type = "destination";
                            }
                            massegeWidgetdata.delete1 = delete1;
                            massegeWidgetdata.delete2 = delete2;
                            massegeWidgetdata.typemsg = massegetype;
                            massegeWidgetdata.id = massege.id;
                            massegeWidgetdata.seen = seen;
                            massegeWidget.add(massegeWidgetdata);
                          }
                          return massegeWidget.length > 0
                              ? ListView.builder(
                                  itemCount: massegeWidget.length,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    if (massegeWidget[index].typemsg == "msg") {
                                      if (massegeWidget[index].type ==
                                          "source") {
                                        return OwnMassege(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            massegeWidget[index].id,
                                            false,
                                            massegeWidget[index].seen);
                                      } else {
                                        return ReplyCard(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            false,
                                            "",
                                            massegeWidget[index].id);
                                      }
                                    } else if (massegeWidget[index].typemsg ==
                                        "photo") {
                                      if (massegeWidget[index].type ==
                                          "source") {
                                        return OwnFileCard(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            "photo",
                                            "",
                                            false,
                                            massegeWidget[index].id);
                                      } else {
                                        return ReplayFileCard(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            "photo",
                                            "");
                                      }
                                    } else if (massegeWidget[index].typemsg ==
                                        "record") {
                                      if (massegeWidget[index].type ==
                                          "source") {
                                        return OwnAudio(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            "record",
                                            userModel.photo,
                                            false,
                                            massegeWidget[index].id);
                                      } else {
                                        return ReplayAudio(
                                            massegeWidget[index].message,
                                            massegeWidget[index].time,
                                            "record",
                                            widget.friend.photo);
                                      }
                                    }
                                    if (massegeWidget[index].typemsg ==
                                        "link") {
                                      if (massegeWidget[index].type ==
                                          "source") {
                                        return OwnLink(
                                          massegeWidget[index].message,
                                          massegeWidget[index].time,
                                          massegeWidget[index].id,
                                        );
                                      } else {
                                        return ReplayLink(
                                          massegeWidget[index].message,
                                          massegeWidget[index].time,
                                          massegeWidget[index].id,
                                        );
                                      }
                                    } else {
                                      if (massegeWidget[index].type ==
                                          "source") {
                                        return OwnGiftCard(
                                          massegeWidget[index].message,
                                          massegeWidget[index].typemsg,
                                        );
                                      } else {
                                        return ReplayGiftCard(
                                          massegeWidget[index].message,
                                          massegeWidget[index].typemsg,
                                        );
                                      }
                                    }
                                  })
                              : Center(
                                  child: Text("لا توجد اي محادثة"),
                                );
                        },
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                        margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          controller: _controller,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                type = false;
                              } else if (value == "") {
                                type = false;
                              } else {
                                type = true;
                              }
                              msg = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "اكتب الرسالة هنا"
                                .tr(args: ['اكتب الرسالة هنا']),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      getImages(
                                          ImageSource.gallery,
                                          _auth.currentUser!.uid,
                                          widget.friend.docID);
                                    },
                                    icon: Icon(Icons.photo)),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (builder) => StreamBuilder(
                                          stream: _firestore
                                              .collection("ranklistsduration")
                                              .doc("mainrankduration")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Opps an error has happend:${snapshot.error.toString()}");
                                            } else if (snapshot.hasData) {
                                              final duraionData = snapshot.data;
                                              num day =
                                                  duraionData?.get("day") ?? 0;
                                              num month =
                                                  duraionData?.get("month") ??
                                                      0;
                                              Map<String, dynamic> weak =
                                                  duraionData?.get('weak') ?? 0;
                                              Map<String, dynamic> halfyear =
                                                  duraionData
                                                          ?.get('halfyear') ??
                                                      0;
                                              num weakstartday =
                                                  weak["startday"];
                                              num weakendday = weak["endday"];
                                              num halfyearstartmonth =
                                                  halfyear["startmonth"];
                                              num halfyearendmonth =
                                                  halfyear["endmonth"];
                                              log("day:$day");
                                              log("month:$month");
                                              log("startoftheweak:$weakstartday");
                                              log("endoftheweak:$weakendday");
                                              log("startoftherhalfyear:$halfyearstartmonth");
                                              log("endoftherhalfyear:$halfyearendmonth");
                                              return bottomSheet(
                                                  day: day,
                                                  month: month,
                                                  weakstartday: weakstartday,
                                                  weakendday: weakendday,
                                                  halfyearstartmonth:
                                                      halfyearstartmonth,
                                                  halfyearendmonth:
                                                      halfyearendmonth);
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.card_giftcard))
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    type
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, right: 3, left: 2),
                            child: CircleAvatar(
                              radius: 25,
                              child: IconButton(
                                onPressed: () {
                                  if (type) {
                                    sendMassege(
                                        _controller.text,
                                        _auth.currentUser!.uid,
                                        widget.friend.docID);
                                    setState(() {
                                      type = false;
                                      _controller.clear();
                                    });
                                  }
                                },
                                icon: Icon(Icons.send),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, right: 3, left: 2),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: IconButton(
                                onPressed: () async {
                                  await recordMethod.toggleRecording();
                                  recordMethod.ChatRoomID = chatID;
                                  setState(() {
                                    IsRecording = recordMethod.isRecording;
                                  });
                                },
                                icon: IsRecording
                                    ? const Icon(
                                        Icons.stop_circle,
                                        color: Colors.red,
                                      )
                                    : const Icon(Icons.mic_none),
                              ),
                            ),
                          )
                  ],
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Offstage(
                  //   offstage: !emojiShowing,
                  //   child: SizedBox(
                  //     height: 250,
                  //     child: EmojiPicker(
                  //       textEditingController: _controller,
                  //       config: Config(
                  //         columns: 7,
                  //         emojiSizeMax: 32 *
                  //             (defaultTargetPlatform ==
                  //                 TargetPlatform.iOS
                  //                 ? 1.30
                  //                 : 1.0),
                  //         verticalSpacing: 0,
                  //         horizontalSpacing: 0,
                  //         gridPadding: EdgeInsets.zero,
                  //         bgColor: const Color(0xFFF2F2F2),
                  //         indicatorColor: Colors.blue,
                  //         iconColor: Colors.grey,
                  //         iconColorSelected: Colors.blue,
                  //         backspaceColor: Colors.blue,
                  //         skinToneDialogBgColor: Colors.white,
                  //         skinToneIndicatorColor: Colors.grey,
                  //         enableSkinTones: true,
                  //         recentsLimit: 28,
                  //         replaceEmojiOnLimitExceed: false,
                  //         noRecents: const Text(
                  //           'No Recents',
                  //           style:
                  //           TextStyle(fontSize: 20, color: Colors.black26),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //         loadingIndicator: const SizedBox.shrink(),
                  //         tabIndicatorAnimDuration: kTabScrollDuration,
                  //         categoryIcons: const CategoryIcons(),
                  //         buttonMode: ButtonMode.MATERIAL,
                  //         checkPlatformCompatibility: true,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendMassege(String message, String sourceId, String targetId) async {
    final id = DateTime.now().toString();
    String idd = "$id-$chatID";
    if (message.startsWith("http://") ||
        message.startsWith("https://") ||
        message.startsWith("www.")) {
      await _firestore.collection('chat').doc(idd).set({
        'chatroom': chatID,
        'sender': _auth.currentUser!.uid,
        'type': 'link',
        'time': DateTime.now().toString().substring(10, 16),
        'msg': message,
        'seen': "false",
        "delete1": "false",
        "delete2": "false"
      });
      String idUser = "$sourceId$targetId";
      final docRef = _firestore.collection("contacts").doc(idUser);
      final updates = <String, dynamic>{
        "lastmsg": message,
        'time': DateTime.now().toString().substring(10, 16),
        'type': "msg",
        'clock': FieldValue.serverTimestamp(),
      };
      docRef.update(updates);
      idUser = "$targetId$sourceId";
      final docRef2 = _firestore.collection("contacts").doc(idUser);
      final updates2 = <String, dynamic>{
        "lastmsg": message,
        'time': DateTime.now().toString().substring(10, 16),
        'type': "msg",
        'clock': FieldValue.serverTimestamp(),
      };
      docRef2.update(updates2);

      print(message);
    } else {
      await _firestore.collection('chat').doc(idd).set({
        'chatroom': chatID,
        'sender': _auth.currentUser!.uid,
        'type': 'msg',
        'time': DateTime.now().toString().substring(10, 16),
        'msg': message,
        'seen': "false",
        "delete1": "false",
        "delete2": "false"
      });
      String idUser = "$sourceId$targetId";
      final docRef = _firestore.collection("contacts").doc(idUser);
      final updates = <String, dynamic>{
        "lastmsg": message,
        'time': DateTime.now().toString().substring(10, 16),
        'type': "msg",
        'clock': FieldValue.serverTimestamp(),
      };
      docRef.update(updates);
      idUser = "$targetId$sourceId";
      final docRef2 = _firestore.collection("contacts").doc(idUser);
      final updates2 = <String, dynamic>{
        "lastmsg": message,
        'time': DateTime.now().toString().substring(10, 16),
        'type': "msg",
        'clock': FieldValue.serverTimestamp(),
      };
      docRef2.update(updates2);
      print(message);
    }
    // sendNotification(
    //     widget.us.devicetoken,
    //     widget.source.name,
    //     message
    // );
    print("Massege Send");
    print(chatID);
  }

  Future getImages(ImageSource media, String sourceId, String targetId) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _showspinner = true;
      _image = File(pickedFile!.path);
    });
    img.Image image = img.decodeImage(_image!.readAsBytesSync())!;
    img.Image compressedImage = img.copyResize(image, width: 800);
    File compressedFile = File('${_image!.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(compressedImage));
    final path =
        "chat/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(compressedFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : $urlDownload");
    final id = DateTime.now().toString();
    String idd = "$id-$sourceId";
    print("Massege Send");
    await _firestore.collection('chat').doc(idd).set({
      'chatroom': chatID,
      'sender': _auth.currentUser!.uid,
      'type': 'photo',
      'time': DateTime.now().toString().substring(10, 16),
      'msg': urlDownload,
      'seen': "false",
      "delete1": "false",
      "delete2": "false"
    });
    String idUser = "$sourceId$targetId";
    final docRef = _firestore.collection("contacts").doc(idUser);
    final updates = <String, dynamic>{
      "lastmsg": "photo",
      'time': DateTime.now().toString().substring(10, 16),
      'typeLast': "msg",
      'clock': FieldValue.serverTimestamp(),
    };
    docRef.update(updates);
    idUser = "$targetId$sourceId";
    final docRef2 = _firestore.collection("contacts").doc(idUser);
    final updates2 = <String, dynamic>{
      "lastmsg": "photo",
      'time': DateTime.now().toString().substring(10, 16),
      'typeLast': "msg",
      'clock': FieldValue.serverTimestamp(),
    };
    docRef2.update(updates2);
    setState(() {
      _showspinner = false;
    });
    // setState(() {
    //   Navigator.pop(context);
    //   _showspinner = false;
    // });
    // sendNotification(
    //     widget.us.devicetoken,
    //     widget.source.name,
    //     image!.name
    // );
  }

  Widget bottomSheet(
      {required num day,
      required num month,
      required num weakstartday,
      required num weakendday,
      required num halfyearstartmonth,
      required num halfyearendmonth}) {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('gifts').snapshots(),
              builder: (context, snapshot) {
                List<GiftModel> gifts = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  gifts.add(GiftModel(
                      massege.id,
                      massege.get('name'),
                      massege.get('photo'),
                      massege.get('price'),
                      massege.get('type')));
                }
                return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: gifts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          num newWelthDay = 0;
                          num newWelthWeak = 0;
                          num newWelthMonth = 0;
                          num newWelthHalfYear = 0;
                          num newCharmDay = 0;
                          num newCharmWeak = 0;
                          num newCharmMonth = 0;
                          num newCharmHalfYear = 0;
                          DateTime currenDate = DateTime.now();
                          num currentDay =
                              int.parse(DateFormat("dd").format(currenDate));
                          num currentMonth =
                              int.parse(DateFormat('M').format(currenDate));
                          log("currentday:$currentDay");
                          log("currentmonth:$currentMonth");
                          log("dayonsheet:$day");
                          log("dayonsheet:$month");
                          int coins = int.parse(userModel.coin);
                          int price = int.parse(gifts[index].price);
                          int exp2 = 0;
                          int daimonds = 0;
                          String reciverVip = "0";
                          if (coins >= price) {
                            int exp = int.parse(userModel.exp);
                            if (userModel.vip == "1") {
                              exp = exp + (price * 1.15).toInt();
                            } else if (userModel.vip == "2") {
                              exp = exp + (price * 1.125).toInt();
                            } else if (userModel.vip == "3") {
                              exp = exp + (price * 1.50).toInt();
                            } else if (userModel.vip == "4") {
                              exp = exp + (price * 1.75).toInt();
                            } else {
                              exp = exp + price;
                            }
                            coins = coins - price;
                            if (day == currentDay &&
                                month == currentMonth &&
                                currentDay >= weakstartday &&
                                currentDay <= weakendday &&
                                currentMonth >= halfyearstartmonth &&
                                currentMonth <= halfyearendmonth) {
                              newWelthDay = welthDay + price;
                              newWelthWeak = welthWeak + price;
                              newWelthMonth = welthMonth + price;
                              newWelthHalfYear = welthHalfYear + price;
                              log("all Welth  data   corect");
                            }
                            await _firestore
                                .collection('user')
                                .doc(userModel.docID)
                                .update({
                              'coin': coins.toString(),
                              'exp': exp.toString(),
                              'welthday': newWelthDay,
                              'welthweak': newWelthWeak,
                              "welthmonth": newWelthMonth,
                              "welthhalfyear": newWelthHalfYear,
                            }).then((value) {
                              _firestore
                                  .collection('user')
                                  .doc(widget.friend.docID)
                                  .get()
                                  .then((value) {
                                exp2 = int.parse(value.get('exp2'));
                                daimonds = int.parse(value.get('daimond'));
                                reciverVip = value.get('vip');
                                charmDay = value.get("charmday");
                                charmWeak = value.get("charmweak");
                                charmMonth = value.get("charmmonth");
                                cahrmHalfYear = value.get("charmhalfyear");
                                log("charmDay:$charmDay");
                                log("charmWeak:$charmWeak");
                                log("charmMonth:$charmMonth");
                                log("charmHalfYear:$cahrmHalfYear");
                              }).then((value) {
                                if (day == currentDay &&
                                    month == currentMonth &&
                                    currentDay >= weakstartday &&
                                    currentDay <= weakendday &&
                                    currentMonth >= halfyearstartmonth &&
                                    currentMonth <= halfyearendmonth) {
                                  newCharmDay = charmDay + price;
                                  newCharmWeak = charmWeak + price;
                                  newCharmMonth = charmMonth + price;
                                  newCharmHalfYear = cahrmHalfYear + price;
                                  log("all Charm  data   corect");
                                }
                                daimonds = daimonds + price;
                                int newexp = 0;
                                if (reciverVip == "1") {
                                  newexp = exp2 + (price / 3.47826087).round();
                                } else if (reciverVip == "2") {
                                  newexp = exp2 + (price / 3.55555556).round();
                                } else if (reciverVip == "3") {
                                  newexp = exp2 + (price / 2.66666667).round();
                                } else if (reciverVip == "4") {
                                  newexp = exp2 + (price / 2.28571429).round();
                                } else {
                                  newexp = exp2 + (price / 4).round();
                                }
                                _firestore
                                    .collection('user')
                                    .doc(widget.friend.docID)
                                    .update({
                                  'exp2': newexp.toString(),
                                  'daimond': daimonds.toString(),
                                  "charmday": newCharmDay,
                                  "charmweak": newCharmWeak,
                                  "charmmonth": newCharmMonth,
                                  "charmhalfyear": newCharmHalfYear,
                                }).then((value) {
                                  _firestore
                                      .collection('user')
                                      .doc(widget.friend.docID)
                                      .collection('Mygifts')
                                      .doc()
                                      .set({'id': gifts[index].docID}).then(
                                          (value) {
                                    final id = DateTime.now().toString();
                                    String idd =
                                        "$id-${_auth.currentUser!.uid}";
                                    _firestore.collection('chat').doc(idd).set({
                                      'chatroom': chatID,
                                      'sender': _auth.currentUser!.uid,
                                      'type': gifts[index].type,
                                      'time': DateTime.now()
                                          .toString()
                                          .substring(10, 16),
                                      'msg': gifts[index].photo,
                                      'seen': "false",
                                      "delete1": "false",
                                      "delete2": "false"
                                    });
                                    String idUser =
                                        "${_auth.currentUser!.uid}${widget.friend.docID}";
                                    final docRef = _firestore
                                        .collection("contacts")
                                        .doc(idUser);
                                    final updates = <String, dynamic>{
                                      "lastmsg": "gift",
                                      'time': DateTime.now()
                                          .toString()
                                          .substring(10, 16),
                                      'type': "msg",
                                      'clock': FieldValue.serverTimestamp(),
                                    };
                                    docRef.update(updates);
                                    idUser =
                                        "${widget.friend.docID}${_auth.currentUser!.uid}";
                                    final docRef2 = _firestore
                                        .collection("contacts")
                                        .doc(idUser);
                                    final updates2 = <String, dynamic>{
                                      "lastmsg": "gift",
                                      'time': DateTime.now()
                                          .toString()
                                          .substring(10, 16),
                                      'type': "msg",
                                      'clock': FieldValue.serverTimestamp(),
                                    };
                                    docRef2.update(updates2);
                                  }).then((value) {
                                    if (userModel.myfamily != "") {
                                      _firestore
                                          .collection('family')
                                          .doc(userModel.myfamily)
                                          .collection('count')
                                          .doc()
                                          .set({
                                        'user': userModel.docID,
                                        'day': DateTime.now().day.toString(),
                                        'month':
                                            DateTime.now().month.toString(),
                                        'year': DateTime.now().year.toString(),
                                        'coin': gifts[index].price
                                      }).then((value) {
                                        _firestore
                                            .collection('user')
                                            .doc(widget.friend.docID)
                                            .get()
                                            .then((value) {
                                          String friendfamily =
                                              value.get('myfamily');
                                          if (friendfamily == "") {
                                          } else {
                                            _firestore
                                                .collection('family')
                                                .doc(friendfamily)
                                                .collection('count2')
                                                .doc()
                                                .set({
                                              'user': widget.friend.docID,
                                              'day':
                                                  DateTime.now().day.toString(),
                                              'month': DateTime.now()
                                                  .month
                                                  .toString(),
                                              'year': DateTime.now()
                                                  .year
                                                  .toString(),
                                              'coin': gifts[index].price
                                            });
                                          }
                                        });
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      SendDone();
                                    }
                                  }).then((value) {
                                    print(firendType);
                                    print(friendAgency);
                                    String docs =
                                        "${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                                    if (firendType == "host") {
                                      int lastincome = 0;
                                      _firestore
                                          .collection('agency')
                                          .doc(friendAgency)
                                          .collection('users')
                                          .doc(widget.friend.docID)
                                          .collection('income')
                                          .doc(docs)
                                          .get()
                                          .then((value) {
                                        lastincome =
                                            int.parse(value.get('count')) +
                                                int.parse(gifts[index].price);
                                      }).whenComplete(() {
                                        if (lastincome == 0) {
                                          _firestore
                                              .collection('agency')
                                              .doc(friendAgency)
                                              .collection('users')
                                              .doc(widget.friend.docID)
                                              .collection('income')
                                              .doc(docs)
                                              .set({
                                            'date': DateTime.now().toString(),
                                            'hosttime': '0',
                                            'numberradio': '0',
                                            'count': gifts[index].price,
                                          });
                                        } else {
                                          _firestore
                                              .collection('agency')
                                              .doc(friendAgency)
                                              .collection('users')
                                              .doc(widget.friend.docID)
                                              .collection('income')
                                              .doc(docs)
                                              .update({
                                            'count': lastincome.toString()
                                          });
                                        }
                                      }).then((value) {
                                        _firestore
                                            .collection('user')
                                            .doc(_auth.currentUser!.uid)
                                            .collection('sendgift')
                                            .doc()
                                            .set({
                                          'giftid': gifts[index].docID,
                                          'target': widget.friend.docID
                                        }).then((value) {
                                          Navigator.pop(context);
                                          SendDone();
                                        });
                                      });
                                    }
                                  });
                                });
                              });
                            });
                          } else {
                            SendDisApprove();
                          }
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                gifts[index].type == "svga"
                                    ? CircleAvatar(
                                        radius: 30,
                                        child: SVGASimpleImage(
                                          resUrl: gifts[index].photo,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 30,
                                        child: CachedNetworkImage(
                                            imageUrl: gifts[index].photo),
                                      ),
                                Text(gifts[index].Name),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage(AppImages.gold_coin),
                                      radius: 5,
                                    ),
                                    Text(
                                      gifts[index].price,
                                      style:
                                          TextStyle(color: Colors.orangeAccent),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
            )),
      ),
    );
  }

  void SendDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("مبروك"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم ارسال الهدية بنجاح"),
                ),
              ));
        });
  }

  void SendDisApprove() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ناسف"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("لا تملك العملات الكافية"),
                ),
              ));
        });
  }
}
