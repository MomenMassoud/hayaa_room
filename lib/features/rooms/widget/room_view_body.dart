import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hayaa_main/features/rooms/data/models/vip_model.dart';
import 'package:hayaa_main/features/rooms/widget/audince_sheet.dart';
import 'package:hayaa_main/features/rooms/widget/defult_room_message.dart';
import 'package:hayaa_main/features/rooms/widget/gifts_bottom_sheet.dart';
import 'package:hayaa_main/features/rooms/widget/m4_video_player.dart';
import 'package:hayaa_main/features/rooms/widget/taking_seat_bootom_sheat.dart';
import 'package:hayaa_main/features/rooms/widget/vip_room_message.dart';
import 'package:hayaa_main/models/user_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/gift_model.dart';
import 'constant.dart';

class RoomViewBody extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String username;
  final String userid;
  final layoutMode = LayoutMode.defaultLayout;
  RoomViewBody(
      {Key? key,
        required this.roomID,
        required this.isHost,
        required this.username,
        required this.userid})
      : super(key: key);
  _RoomViewBody createState() => _RoomViewBody();
}

class _RoomViewBody extends State<RoomViewBody> {
  bool openchat = true;
  List<int> lockedSeats = []; // List to store locked seat indexes
  List<String> userSeats = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String framePhoto = "";
  final isSeatClosedNotifier = ValueNotifier<bool>(false);
  final isRequestingNotifier = ValueNotifier<bool>(false);
  final controller = ZegoLiveAudioRoomController();
  List<String> musicPath = [];
  List<String> musicname = [];
  DateTime? seatOccupiedTime;
  bool viewMusic = false;
  String viewID = "";
  String bio = "";
  String layoutSeats = "";
  String roomPhoto = '';
  String wallpaper =
      "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462";
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  String pass = "";
  String giftMedia = "";
  String carMedia = "";
  String cartype = "";
  String gifttype = "";
  String myType = "";
  String MytypeInRoom = "";
  late UserModel currentUserData;
  late num welthDay;
  late num welthWeak;
  late num welthMonth;
  late num welthHalfYear;

  String lock = "lib/core/Utils/assets/images/icon/lock_8497362.png";
  @override
  void initState() {
    super.initState();
    setUserInRoom();
    getMyCar();
    getWallpaper();
    UserBlock();
  }
  String RoomPhoto="";
  void setUserInRoom() async {
    await for (var snap in _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        MytypeInRoom = snap.get('type');
      });
    }
  }
  String myphotoAva="";

  void getMyCar() async {
    int uservip = 0;
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        myType = snap.get('type');
        myphotoAva=snap.get('photo');
        uservip = int.parse(snap.get("vip"));
        log("userVip: $uservip");
      });

      if (uservip != 0) {
        await for (var vipsnap
        in _firestore.collection("vip").doc("vip$uservip").snapshots()) {
          setState(() {
            carMedia = vipsnap.get('joinvedio');
            cartype = vipsnap.get('vediotype');
            _firestore.collection('room').doc(widget.roomID).update({
              'car': carMedia,
              'cartype': cartype,
            });
            try {
              Future.delayed(Duration(
                  seconds: int.parse(vipsnap.get("videoduration"))))
                  .then((value) {
                setState(() {
                  carMedia = "";
                });
                _firestore
                    .collection('room')
                    .doc(widget.roomID)
                    .update({'car': '', 'cartype': ''}).then((value) {
                  controller.message.send('Join to Room');
                });
              });
            } catch (e) {
              Future.delayed(const Duration(seconds: 6)).then((value) {
                setState(() {
                  carMedia = "";
                });
                _firestore
                    .collection('room')
                    .doc(widget.roomID)
                    .update({'car': '', 'cartype': ''}).then((value) {
                  controller.message.send('Join to Room');
                });
              });
            }
          });
        }
      } else {
        await for (var snapp in _firestore
            .collection('store')
            .doc(snap.get('mycar'))
            .snapshots()) {
          setState(() {
            carMedia = snapp.get('photo');
            cartype = snapp.get('type');
            _firestore.collection('room').doc(widget.roomID).update({
              'car': carMedia,
              'cartype': cartype,
            });
            Future.delayed(const Duration(seconds: 4)).then((value) {
              setState(() {
                carMedia = "";
              });
              _firestore
                  .collection('room')
                  .doc(widget.roomID)
                  .update({'car': '', 'cartype': ''}).then((value) {
                controller.message.send('Join to Room');
              });
            });
          });
        }
      }
    }
  }

  void getWallpaper() async {
    await for (var snap
    in _firestore.collection('room').doc(widget.roomID).snapshots()) {
      setState(() {
        wallpaper = snap.get('wallpaper');
        viewID = snap.get('id');
        bio = snap.get('bio');
        layoutSeats = snap.get('seat');
        pass = snap.get('password');
        giftMedia = snap.get('gift');
        carMedia = snap.get('car');
        roomPhoto = snap.get('photo');
      });
    }
  }

  void UserBlock() async {
    if (!widget.isHost) {
      await for (var snap in _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('block')
          .where('id', isEqualTo: _auth.currentUser!.uid)
          .snapshots()) {
        if (snap.size != 0) {
          controller.leave(context, showConfirmation: false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .where('doc', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String Mycar = "";
        String Myframe = "";
        String Mywallpaper = "";
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        currentUserData = UserModel(
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
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed) {
          Mycar = massege.get('mycar');
          Myframe = massege.get('myframe');
          currentUserData.coin = massege.get('coin');
          currentUserData.exp = massege.get('exp');
          currentUserData.vip = massege.get('vip');
          welthDay = massege.get("welthday");
          welthWeak = massege.get("welthweak");
          welthMonth = massege.get("welthmonth");
          welthHalfYear = massege.get("welthhalfyear");
        }
        return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('store')
                .where('id', isEqualTo: Myframe)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed) {
                framePhoto = massege.get('photo');
              }
              return SafeArea(
                  child: ZegoUIKitPrebuiltLiveAudioRoom(
                    appID: 881787793,
                    // Fill in the appID that you get from ZEGOCLOUD Admin Console.
                    appSign:
                    "52465f95763cc73bf8c917fc8deedb829ecbe362f0cd7bdfbeac61e33c75aead",
                    // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
                    userID: widget.username,
                    userName: widget.userid,
                    roomID: viewID,
                    config: widget.isHost
                        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
                      ..onLeaveConfirmation = (context) async {
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                                title: const Text("Leave Confirm",
                                    style: TextStyle(color: Colors.white70)),
                                content: const Text("Are you sure Leave from room",
                                    style: TextStyle(color: Colors.white70)),
                                actions: [
                                  ElevatedButton(
                                    child: const Text(
                                      "Cancel",
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  ElevatedButton(
                                    child: const Text("Exit"),
                                    onPressed: () async {
                                      _firestore
                                          .collection('room')
                                          .doc(widget.roomID)
                                          .collection('user')
                                          .doc(_auth.currentUser!.uid)
                                          .delete()
                                          .then((value) {
                                        Navigator.of(context).pop(true);
                                      });
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                      ..background = background()
                      ..useSpeakerWhenJoining = true
                      ..seatConfig = ZegoLiveAudioRoomSeatConfig(
                          backgroundBuilder: (context, size, user, extraInfo) {
                            return Container(
                              color: Colors.transparent,
                            );
                          },
                          foregroundBuilder: (context, size, user, extraInfo) {
                            return Container(
                              color: Colors.transparent,
                            );
                          },
                          closeIcon: Image.asset(lock),
                          openIcon: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fsofa_6458474.png?alt=media&token=dff6124f-805c-4386-bd95-394c4fa611f7"))
                      ..seatConfig.avatarBuilder =
                          (context, size, user, extraInfo) {
                        if (user!.id == _auth.currentUser!.uid) {
                          return Stack(
                            children: [
                              Container(
                                width: size.width * 2,
                                child: CircleAvatar(
                                  maxRadius: size.width + 100,
                                  backgroundImage:
                                  CachedNetworkImageProvider(framePhoto),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              // Display the second image on the right
                              Center(
                                child: Container(
                                  width: size.width - 20 - 3.5,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        myphotoAva),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('user')
                                .where('doc', isEqualTo: user!.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              String userPhoto = "";
                              String userFrame = "";
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              }
                              final masseges = snapshot.data?.docs;
                              for (var massege in masseges!.reversed) {
                                userPhoto = massege.get('photo');
                                userFrame = massege.get('myframe');
                              }
                              return StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection('store')
                                      .where('id', isEqualTo: userFrame)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    String userFramePhoto = "";
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                    }
                                    final masseges = snapshot.data?.docs;
                                    for (var massege in masseges!.reversed) {
                                      userFramePhoto = massege.get('photo');
                                    }
                                    return Stack(
                                      children: [
                                        Container(
                                          width: size.width * 2,
                                          child: CircleAvatar(
                                            maxRadius: size.width + 100,
                                            backgroundImage:
                                            CachedNetworkImageProvider(
                                                userFramePhoto),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                        // Display the second image on the right
                                        Center(
                                          child: Container(
                                            width: size.width - 20 - 3.5,
                                            child: CircleAvatar(
                                              backgroundImage:
                                              CachedNetworkImageProvider(
                                                  userPhoto),
                                              backgroundColor: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        }
                      }
                      ..inRoomMessageConfig = ZegoInRoomMessageConfig(
                        height: MediaQuery.of(context).size.height * 0.5,
                        showAvatar: false,
                        itemBuilder: (context, message, extraInfo) {
                          if (message.message.contains("Join")) {
                            return FutureBuilder(
                              future: _firestore
                                  .collection("user")
                                  .doc(message.user.id)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final int userVip =
                                  int.parse(snapshot.data!.get("vip"));
                                  if (userVip != 0) {
                                    return FutureBuilder(
                                      future: _firestore
                                          .collection("vip")
                                          .doc("vip$userVip")
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final Map<String, dynamic> json =
                                          snapshot.data!.data()!;
                                          final VipModel vipData =
                                          VipModel.fromJson(json);
                                          return VipRoomMessage(
                                              auth: _auth,
                                              message: message.message,
                                              vipMessageFrame: vipData.joinFrame,
                                              vipNameColor: vipData.nameColor);
                                        } else if (snapshot.hasError) {
                                          log("Getting vip data error is ${snapshot.error.toString()} ");
                                          return const SizedBox();
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    return DefultRoomMessage(
                                      auth: _auth,
                                      message: message.message,
                                      userNameColor: const Color(0xffCB9B69),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  log("Getting vip value error ${snapshot.error.toString()}");
                                  return const SizedBox();
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          } else {
                            return DefultRoomMessage(
                              auth: _auth,
                              message: message.message,
                              userNameColor: const Color(0xffCB9B69),
                            );
                          }
                        },
                      )
                      ..layoutConfig.rowConfigs = layoutSeats == '9'
                          ? [
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 1,
                            alignment:
                            ZegoLiveAudioRoomLayoutAlignment.center),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment:
                            ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment:
                            ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                      ]
                          : layoutSeats == '11'
                          ? [
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 1,
                            alignment:
                            ZegoLiveAudioRoomLayoutAlignment.center),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 2,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                      ]
                          : [
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 1,
                            alignment:
                            ZegoLiveAudioRoomLayoutAlignment.center),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(
                            count: 4,
                            alignment: ZegoLiveAudioRoomLayoutAlignment
                                .spaceAround),
                      ]
                      ..bottomMenuBarConfig.audienceButtons = const [
                        ZegoMenuBarButtonName
                            .showMemberListButton, //i dont now what is doing
                        ZegoMenuBarButtonName.applyToTakeSeatButton,
                      ]
                      ..onSeatClicked = (index, user) {
                        print("Value ${isSeatOpen(index)}");
                        if (widget.isHost) {
                          if (isSeatOpen(index) && user == null) {
                            openSeat(index);
                          } else {
                            if (user == null) {
                              closeSeat(index);
                            }
                            if (user!.id != _auth.currentUser!.uid) {
                              ChangeMemberValue(user.id, user.name);
                            }
                          }
                        } else {
                          if (MytypeInRoom == "admin") {
                            if (isSeatOpen(index) && user == null) {
                              openSeat(index);
                            } else {
                              if (user == null) {
                                closeSeat(index);
                              } else {
                                if (user!.id != _auth.currentUser!.uid) {
                                  ChangeMemberValue(user.id, user.name);
                                } else {
                                  RemoveMe();
                                }
                              }
                            }
                          } else {
                            if (user!.id == _auth.currentUser!.uid) {
                              RemoveMe();
                            }
                          }
                        }
                      }
                      ..onSeatsChanged = (
                          Map<int, ZegoUIKitUser> takenSeats,
                          List<int> untakenSeats,
                          ) {
                        if (isRequestingNotifier.value) {
                          if (takenSeats.values
                              .map((e) => e.id)
                              .toList()
                              .contains(widget.userid)) {
                            /// on the seat now
                            isRequestingNotifier.value = false;
                          }
                        }
                      }
                      ..onSeatTakingRequestFailed = () async {
                        DocumentSnapshot snapshot = await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .get();
                        int numberOfTakingSeatRequst = 0;
                        numberOfTakingSeatRequst =
                            int.parse(snapshot.get("numberOfTakingSeatRequst"));
                        if (numberOfTakingSeatRequst > 0) {
                          --numberOfTakingSeatRequst;
                        }
                        await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .update({
                          'numberOfTakingSeatRequst':
                          numberOfTakingSeatRequst.toString()
                        });
                      }
                      ..onSeatTakingRequestRejected = () {
                        isRequestingNotifier.value = false;
                      }
                      ..onSeatTakingRequested = (ZegoUIKitUser audience) async {
                        debugPrint('on seat taking requested, audience:$audience');
                        _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .collection('user')
                            .doc(audience.id)
                            .update({"takeSeatRequst": true});

                        DocumentSnapshot snapshot = await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .get();
                        int numberOfTakingSeatRequst = 0;
                        numberOfTakingSeatRequst =
                            int.parse(snapshot.get("numberOfTakingSeatRequst"));
                        ++numberOfTakingSeatRequst;
                        await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .update({
                          'numberOfTakingSeatRequst':
                          numberOfTakingSeatRequst.toString()
                        });
                        isRequestingNotifier.value = false;
                      }
                      ..onSeatTakingRequestCanceled =
                          (ZegoUIKitUser audience) async {
                        _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .collection('user')
                            .doc(audience.id)
                            .update({"takeSeatRequst": false});

                        DocumentSnapshot snapshot = await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .get();
                        int numberOfTakingSeatRequst = 0;
                        numberOfTakingSeatRequst =
                            int.parse(snapshot.get("numberOfTakingSeatRequst"));
                        --numberOfTakingSeatRequst;
                        await _firestore
                            .collection('room')
                            .doc(widget.roomID)
                            .update({
                          'numberOfTakingSeatRequst':
                          numberOfTakingSeatRequst.toString()
                        });
                      }
                      ..onInviteAudienceToTakeSeatFailed = () {
                        debugPrint('on invite audience to take seat failed');
                      }
                      ..onSeatsChanged = (
                          Map<int, ZegoUIKitUser> takenSeats,
                          List<int> untakenSeats,
                          ) {
                        debugPrint(
                          'on seats changed, taken seats: $takenSeats, untaken seats: $untakenSeats',
                        );
                        setState(() {
                          userSeats.clear();
                        });
                        takenSeats.forEach((seatIndex, user) {
                          setState(() {
                            userSeats.add(user.id);
                          });
                          debugPrint('Seat $seatIndex is taken by user: $user');
                          if (user.id == _auth.currentUser!.uid &&
                              myType == "host") {
                            print("Start Time ===================");
                            seatOccupiedTime = DateTime.now();
                          }

                          // Do whatever you need with the updated list of users in seats
                          debugPrint('Users currently in seats: $userSeats');
                        });
                        if (userSeats.contains(_auth.currentUser!.uid) == false) {
                          print("user lefttttttttttttttttttttt");
                          if (seatOccupiedTime != null) {
                            DateTime now = DateTime.now();
                            Duration timeSpent = now.difference(seatOccupiedTime!);
                            print(
                                'User spent ${timeSpent.inMinutes} minutes in the seat.');
                            // Reset the seatOccupiedTime
                            seatOccupiedTime = null;
                            String myagent = "";
                            _firestore
                                .collection('user')
                                .doc(_auth.currentUser!.uid)
                                .get()
                                .then((value) {
                              myagent = value.get('myagent');
                            }).then((value) {
                              int lastincome = 0;
                              String docs =
                                  "${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                              _firestore
                                  .collection('agency')
                                  .doc(myagent)
                                  .collection('users')
                                  .doc(_auth.currentUser!.uid)
                                  .collection('income')
                                  .doc(docs)
                                  .get()
                                  .then((value) {
                                lastincome = int.parse(value.get('hosttime')) +
                                    timeSpent.inMinutes;
                              }).whenComplete(() {
                                if (lastincome == 0) {
                                  _firestore
                                      .collection('agency')
                                      .doc(myagent)
                                      .collection('users')
                                      .doc(_auth.currentUser!.uid)
                                      .collection('income')
                                      .doc(docs)
                                      .set({
                                    'count': '0',
                                    'date': DateTime.now().toString(),
                                    'hosttime': timeSpent.inMinutes.toString(),
                                    'numberradio':
                                    timeSpent.inMinutes >= 60 ? '1' : '0',
                                  });
                                } else {
                                  _firestore
                                      .collection('agency')
                                      .doc(myagent)
                                      .collection('users')
                                      .doc(_auth.currentUser!.uid)
                                      .collection('income')
                                      .doc(docs)
                                      .update({
                                    'hosttime': lastincome.toString(),
                                    'numberradio': lastincome >= 60 ? '1' : '0',
                                  });
                                }
                              });
                            });
                          }
                        }
                      }
                      ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                        maxCount: 7,
                        showInRoomMessageButton: openchat,
                        audienceExtendButtons: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
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
                                            num day = duraionData?.get("day") ?? 0;
                                            num month =
                                                duraionData?.get("month") ?? 0;
                                            Map<String, dynamic> weak =
                                                duraionData?.get('weak') ?? 0;
                                            Map<String, dynamic> halfyear =
                                                duraionData?.get('halfyear') ?? 0;
                                            num weakstartday = weak["startday"];
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
                                            return GiftsBottomSheet(
                                              roomId: widget.roomID,
                                              currentUserData: currentUserData,
                                              welthDay: welthDay,
                                              welthWeak: welthWeak,
                                              welthMonth: welthMonth,
                                              welthHalfYear: welthHalfYear,
                                              day: day,
                                              month: month,
                                              weakstartday: weakstartday,
                                              weakendday: weakendday,
                                              halfyearstartmonth:
                                              halfyearstartmonth,
                                              halfyearendmonth: halfyearendmonth,
                                              controller: controller,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.card_giftcard,
                                    color: Colors.black,
                                  ))),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (builder) => AudinceBottomSheet(
                                          roomDocId: widget.roomID,
                                          isHost: widget.isHost,
                                          isAdmin: MytypeInRoom == "admin",
                                          roomController: controller,
                                        ));
                                  },
                                  icon: const Icon(
                                    Iconsax.profile_2user5,
                                    color: Colors.black,
                                  ))),
                        ],
                        speakerExtendButtons: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
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
                                            num day = duraionData?.get("day") ?? 0;
                                            num month =
                                                duraionData?.get("month") ?? 0;
                                            Map<String, dynamic> weak =
                                                duraionData?.get('weak') ?? 0;
                                            Map<String, dynamic> halfyear =
                                                duraionData?.get('halfyear') ?? 0;
                                            num weakstartday = weak["startday"];
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
                                            return GiftsBottomSheet(
                                              roomId: widget.roomID,
                                              currentUserData: currentUserData,
                                              welthDay: welthDay,
                                              welthWeak: welthWeak,
                                              welthMonth: welthMonth,
                                              welthHalfYear: welthHalfYear,
                                              day: day,
                                              month: month,
                                              weakstartday: weakstartday,
                                              weakendday: weakendday,
                                              halfyearstartmonth:
                                              halfyearstartmonth,
                                              halfyearendmonth: halfyearendmonth,
                                              controller: controller,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.card_giftcard,
                                    color: Colors.black,
                                  ))),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (builder) => AudinceBottomSheet(
                                          roomDocId: widget.roomID,
                                          isHost: widget.isHost,
                                          isAdmin: MytypeInRoom == "admin",
                                          roomController: controller,
                                        ));
                                  },
                                  icon: const Icon(
                                    Iconsax.profile_2user5,
                                    color: Colors.black,
                                  ))),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                  const AssetImage(AppImages.music),
                                  child: InkWell(
                                      onTap: () {
                                        controller?.media
                                            .pickPureAudioFile()
                                            .then((value) {
                                          Navigator.pop(context);
                                          musicPath.add(value[0].path.toString());
                                          musicname.add(value[0].name);
                                          showModalBottomSheet(
                                              backgroundColor: Colors.transparent,
                                              context: context,
                                              builder: (builder) => MyMusic());
                                        });
                                      },
                                      child: Container())),
                              const Text(
                                "Play Music",
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                        ],
                        hostExtendButtons: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 130,
                                                  width: 130,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 120,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                            gradient:
                                                            const LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                colors: [
                                                                  Color(0xffDDA1EB),
                                                                  Color(0xff7998FA)
                                                                ])),
                                                        child:roomPhoto==""? Icon(
                                                          Icons.person_2_rounded,
                                                          size: 55,
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                        ):CachedNetworkImage(imageUrl: roomPhoto),
                                                      ),
                                                      const Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                          Colors.white,
                                                          child: CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                            Colors.green,
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                    size: 30,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(16),
                                                  color: Colors.grey.shade200),
                                              child: TextFormField(
                                                  enabled: false,
                                                  initialValue: bio,
                                                  decoration: const InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.all(15),
                                                      suffixIcon: Icon(Icons
                                                          .edit_calendar_sharp),
                                                      disabledBorder:
                                                      InputBorder.none)),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Room announcement",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(width: 4),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.edit_calendar_sharp,
                                                    size: 22,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Please input the announcement",
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.grey),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Room admin",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(width: 4),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: const CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: Colors.black,
                                                    child: CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor: Colors.white,
                                                      child: Icon(
                                                        Icons.question_mark,
                                                        size: 22,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.settings)),
                          ),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(AppImages.gift),
                              child: InkWell(
                                  onTap: () {
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
                                            num day = duraionData?.get("day") ?? 0;
                                            num month =
                                                duraionData?.get("month") ?? 0;
                                            Map<String, dynamic> weak =
                                                duraionData?.get('weak') ?? 0;
                                            Map<String, dynamic> halfyear =
                                                duraionData?.get('halfyear') ?? 0;
                                            num weakstartday = weak["startday"];
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
                                            return GiftsBottomSheet(
                                              roomId: widget.roomID,
                                              currentUserData: currentUserData,
                                              welthDay: welthDay,
                                              welthWeak: welthWeak,
                                              welthMonth: welthMonth,
                                              welthHalfYear: welthHalfYear,
                                              day: day,
                                              month: month,
                                              weakstartday: weakstartday,
                                              weakendday: weakendday,
                                              halfyearstartmonth:
                                              halfyearstartmonth,
                                              halfyearendmonth: halfyearendmonth,
                                              controller: controller,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  child: Container())),
                          //audince list
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (builder) => AudinceBottomSheet(
                                      roomDocId: widget.roomID,
                                      isHost: widget.isHost,
                                      isAdmin: MytypeInRoom == "admin",
                                      roomController: controller,
                                    ));
                              },
                              icon: const Icon(
                                Iconsax.profile_2user5,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          //taking seat requsting list
                          StreamBuilder(
                            stream: _firestore
                                .collection("room")
                                .doc(widget.roomID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                int numberOfTakingSeatRequst = 0;

                                numberOfTakingSeatRequst = int.parse(
                                    snapshot.data!.get('numberOfTakingSeatRequst'));

                                return Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (builder) =>
                                                  TakingSeatBootomSheat(
                                                    roomDocId: widget.roomID,
                                                    isHost: widget.isHost,
                                                    isAdmin:
                                                    MytypeInRoom == "admin",
                                                    roomController: controller,
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.back_hand_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    numberOfTakingSeatRequst > 0
                                        ? const Positioned(
                                      right: 20,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 6,
                                      ),
                                    )
                                        : const SizedBox()
                                  ],
                                );
                              } else {
                                return Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (builder) =>
                                                  AudinceBottomSheet(
                                                    roomDocId: widget.roomID,
                                                    isHost: widget.isHost,
                                                    isAdmin:
                                                    MytypeInRoom == "admin",
                                                    roomController: controller,
                                                  ));
                                        },
                                        icon: const Icon(
                                          Iconsax.profile_2user5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: pass == ""
                                      ? InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        SetPassword();
                                      },
                                      child: const Icon(
                                        Icons.password,
                                        color: Colors.black,
                                      ))
                                      : IconButton(
                                      onPressed: () async {
                                        _firestore
                                            .collection('room')
                                            .doc(widget.roomID)
                                            .update({'password': ''}).then(
                                                (value) {
                                              controller.message.send(
                                                  'Remove Password from Room');
                                              setState(() {
                                                pass = "";
                                              });
                                              Navigator.pop(context);
                                            });
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline))),
                              pass == ""
                                  ? const Text(
                                "Set Password To Room",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8),
                              )
                                  : const Text(
                                "Remove Password To Room",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                  const AssetImage(AppImages.music),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) => MyMusic());
                                      },
                                      child: Container())),
                              const Text(
                                "Play Music",
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(AppImages.wallpaper),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) => MyWallpaper());
                                      },
                                      child: Container())),
                              const Text(
                                "Change Room Wallpaper",
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundImage:
                                  const AssetImage(AppImages.layout),
                                  backgroundColor: Colors.white,
                                  child: InkWell(
                                      onTap: () {
                                        ShowNumberSeat();
                                      },
                                      child: Container())),
                              const Text(
                                "Change Seat Number in Room",
                                style: TextStyle(color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                          controller.media.getCurrentProgress() != 0
                              ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                    onPressed: () async {
                                      print("done");
                                      await controller.media
                                          .stop()
                                          .whenComplete(() {
                                        print("done");
                                      });
                                      await controller.media.pause();
                                    },
                                    icon: const Icon(Icons.music_off_sharp)),
                              ),
                              const Text(
                                "Stop Media",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8),
                              )
                            ],
                          )
                              : Container(),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          openchat? CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(onPressed: (){
                              setState(() {
                                openchat=false;
                              });
                              controller.message.send("Close Chat");
                            }, icon: Icon(Icons.message)),
                          ):CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(onPressed: (){
                              setState(() {
                                openchat=true;
                              });
                              controller.message.send("Open Chat");
                            }, icon: Icon(Icons.message)),
                          ),
                             openchat? Text("Close Chat"):Text("Open Chat")
                            ],
                          ),
                        ],
                        speakerButtons: [
                          ZegoMenuBarButtonName.toggleMicrophoneButton,
                        ],
                        hostButtons: [
                          ZegoMenuBarButtonName.toggleMicrophoneButton,
                          ZegoMenuBarButtonName.closeSeatButton,
                        ],
                        audienceButtons: [
                          ZegoMenuBarButtonName.applyToTakeSeatButton,
                        ],
                      ),
                    controller: controller,
                  ));
            });
      },
    );
  }

  // Function to check if a seat is open
  bool isSeatOpen(int seatIndex) {
    return lockedSeats.contains(seatIndex);
  }

  // Function to open a seat
  void openSeat(int seatIndex) {
    if (widget.isHost && isSeatOpen(seatIndex)) {
      // Implement logic to open the seat
      setState(() {
        lockedSeats.remove(seatIndex);
        print("Opennnnnnnnnnn");
      });
      controller.openSeats(
          targetIndex:
          seatIndex); // You may need to implement this method in your ZegoLiveAudioRoomController
      debugPrint('Host opened seat $seatIndex');
      controller.message.send("Open Seat ${seatIndex +1}");
    }
  }

  // Function to close a seat
  void closeSeat(int seatIndex) {
    if (widget.isHost && !isSeatOpen(seatIndex)) {
      // Implement logic to close the seat
      setState(() {
        lockedSeats.add(seatIndex);
      });
      controller.closeSeats(
          targetIndex:
          seatIndex); // You may need to implement this method in your ZegoLiveAudioRoomController
      controller.message.send("Close Seat${seatIndex + 1}");
      debugPrint('Host closed seat $seatIndex');
    }
  }

  Widget connectButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isSeatClosedNotifier,
      builder: (context, isSeatClosed, _) {
        return isSeatClosed
            ? ValueListenableBuilder<bool>(
          valueListenable: isRequestingNotifier,
          builder: (context, isRequesting, _) {
            return isRequesting
                ? ElevatedButton(
              onPressed: () {
                controller.cancelSeatTakingRequest().then((result) {
                  isRequestingNotifier.value = false;
                });
              },
              child: const Text('Cancel'),
            )
                : ElevatedButton(
              onPressed: () {
                controller.applyToTakeSeat().then((result) {
                  isRequestingNotifier.value = result;
                });
              },
              child: const Text('Request'),
            );
          },
        )
            : Container();
      },
    );
  }

  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  bool isAttributeHost(Map<String, String>? userInRoomAttributes) {
    return (userInRoomAttributes?[attributeKeyRole] ?? "") ==
        ZegoLiveAudioRoomRole.host.index.toString();
  }

  Widget backgroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    if (!isAttributeHost(user!.inRoomAttributes as Map<String, String>?)) {
      return Container();
    }

    return Positioned(
      top: -8,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image:
            DecorationImage(image: CachedNetworkImageProvider(framePhoto))),
      ),
    );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(wallpaper == ""
                    ? "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462"
                    : wallpaper)),
          ),
        ),
        ListTile(
          title: Text(
            bio,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "ID : ${viewID}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        giftMedia != ""
            ? Center(
          child: gifttype != "svga"
              ? CachedNetworkImage(
            imageUrl: giftMedia,
          )
              : SVGASimpleImage(
            resUrl: giftMedia,
          ),
        )
            : Container(),
        carMedia != ""
            ? Center(
            child: cartype == "svga"
                ? SVGASimpleImage(
              resUrl: carMedia,
            )
                : cartype == "mp4"
                ? M4VideoPlayer(videoUrl: carMedia)
                : CachedNetworkImage(
              imageUrl: carMedia,
            ))
            : Container(),
      ],
    );
  }

  void SetPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تعين كلمة سر"),
              content: Container(
                  child: SizedBox(
                    height: 478,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  6,
                                      (index) => SizedBox(
                                    width: 40.0,
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          _focusNodes[index + 1].requestFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () async {
                                  String passs = _controllers
                                      .map((controller) => controller.text)
                                      .join();
                                  _firestore
                                      .collection('room')
                                      .doc(widget.roomID)
                                      .update({
                                    'password': passs,
                                  }).then((value) {
                                    setState(() {
                                      pass = passs;
                                      for (int i = 0;
                                      i < _controllers.length;
                                      i++) {
                                        _controllers[i].clear();
                                      }
                                    });
                                    controller.message.send('Set Password to Room');
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text('Save Password'),
                              ),
                            ],
                          )),
                    ),
                  )));
        });
  }

  Widget MyWallpaper() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin: EdgeInsets.all(18),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .doc(_auth.currentUser!.uid)
                  .collection('mylook')
                  .where('cat', isEqualTo: 'wallpaper')
                  .snapshots(),
              builder: (context, snapshot) {
                List<String> wallpapersDoc = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  wallpapersDoc.add(massege.get('id'));
                }
                return GridView.builder(
                    itemCount: wallpapersDoc.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection("store")
                            .where('id', isEqualTo: wallpapersDoc[index])
                            .snapshots(),
                        builder: (context, snapshot) {
                          String wallpaperPhoto = "";
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          final masseges = snapshot.data?.docs;
                          for (var massege in masseges!.reversed) {
                            wallpaperPhoto = massege.get('photo');
                          }
                          return InkWell(
                            onTap: () async {
                              await _firestore
                                  .collection('room')
                                  .doc(widget.roomID)
                                  .update({'wallpaper': wallpaperPhoto}).then(
                                      (value) {
                                    controller.message
                                        .send('Change Wallpaper of Room');
                                    setState(() {
                                      wallpaper = wallpaperPhoto;
                                    });
                                  });
                            },
                            child: CircleAvatar(
                              radius: 30,
                              child:
                              CachedNetworkImage(imageUrl: wallpaperPhoto),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        },
                      );
                    });
              },
            )),
      ),
    );
  }

  Widget MyMusic() {
    return Column(
      children: [
        controller?.media.getCurrentProgress()==0?ElevatedButton(onPressed: (){
          controller?.media
              .pickPureAudioFile()
              .then((value) {
            Navigator.pop(context);
            musicPath.add(value[0].path.toString());
            musicname.add(value[0].name);
          });
        }, child: Text("Choose From Device")):Column(
          children: [
            ElevatedButton(onPressed: (){
              controller?.media
                  .pickPureAudioFile()
                  .then((value) {
                Navigator.pop(context);
                musicPath.add(value[0].path.toString());
                musicname.add(value[0].name);
              });
            }, child: Text("Choose From Device")),
            ElevatedButton(onPressed: (){
              controller?.media
                  .pause();
            }, child: Text("Stop"))

          ],
        ),
        SizedBox(
          height: 278,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.black,
            margin: EdgeInsets.all(18),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: ListView.builder(
                  itemCount: musicPath.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        musicname[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              viewMusic = true;
                            });
                            controller.media.play(filePathOrURL: musicPath[index]);
                            controller.message
                                .send('Play music ${musicPath[index]}');
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                          )),
                    );
                  },
                )),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin: const EdgeInsets.all(18),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              backgroundColor: Colors.black,
                              context: context,
                              builder: (builder) => bottomSheet2(gifts[index]));
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                gifts[index].type == "svga"
                                    ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: SVGASimpleImage(
                                    resUrl: gifts[index].photo,
                                  ),
                                )
                                    : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: CachedNetworkImage(
                                      imageUrl: gifts[index].photo),
                                ),
                                Text(
                                  gifts[index].Name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage:
                                      AssetImage(AppImages.gold_coin),
                                      radius: 5,
                                    ),
                                    Text(
                                      gifts[index].price,
                                      style: const TextStyle(
                                          color: Colors.orangeAccent),
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

  String mycoin = "";
  String myexp = "";
  String myfamily = "";
  Widget bottomSheet2(GiftModel gift) {
    return SizedBox(
      height: 478,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin: EdgeInsets.all(18),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
              itemCount: userSeats.length,
              itemBuilder: (context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('user')
                      .where("doc", isEqualTo: userSeats[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    String type = "";
                    String name = "";
                    String photo = "";
                    String framedoc = "";
                    String framephoto = "";
                    String agent = "";
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    final masseges = snapshot.data?.docs;
                    for (var massege in masseges!.reversed) {
                      name = massege.get('name');
                      photo = massege.get("photo");
                      framedoc = massege.get("myframe");
                      type = massege.get('type');
                      agent = massege.get('myagent');
                      if (userSeats[index] == _auth.currentUser!.uid) {
                        mycoin = massege.get('coin');
                        myexp = massege.get('exp');
                        myfamily = massege.get('myfamily');
                      }
                    }
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('store')
                          .where("id", isEqualTo: framedoc)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        for (var massege in masseges!.reversed) {
                          framephoto = massege.get('photo');
                        }
                        return userSeats[index] == _auth.currentUser!.uid
                            ? Container()
                            : ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                CachedNetworkImageProvider(photo),
                                radius: 12,
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                backgroundImage:
                                CachedNetworkImageProvider(
                                    framephoto),
                                radius: 12,
                                backgroundColor: Colors.transparent,
                              )
                            ],
                          ),
                          onTap: () async {
                            int coins = int.parse(mycoin);
                            int price = int.parse(gift.price);
                            double exp2 = 0;
                            int daimonds = 0;
                            if (coins >= price) {
                              int exp = int.parse(myexp);
                              exp = exp + price;
                              coins = coins - price;
                              await _firestore
                                  .collection('user')
                                  .doc(_auth.currentUser!.uid)
                                  .update({
                                'coin': coins.toString(),
                                'exp': exp.toString(),
                              }).then((value) {
                                _firestore
                                    .collection('user')
                                    .doc(userSeats[index])
                                    .get()
                                    .then((value) {
                                  exp2 = double.parse(value.get('exp2'));
                                  daimonds =
                                      int.parse(value.get('daimond'));
                                }).then((value) {
                                  daimonds = daimonds + price;
                                  double newexp = (exp2) + (daimonds / 4);
                                  _firestore
                                      .collection('user')
                                      .doc(userSeats[index])
                                      .update({
                                    'exp2': newexp.toString(),
                                    'daimond': daimonds.toString(),
                                  }).then((value) {
                                    _firestore
                                        .collection('user')
                                        .doc(userSeats[index])
                                        .collection('Mygifts')
                                        .doc()
                                        .set({'id': gift.docID}).then(
                                            (value) {
                                          _firestore
                                              .collection('user')
                                              .doc(userSeats[index])
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
                                                'user': userSeats[index],
                                                'day': DateTime.now()
                                                    .day
                                                    .toString(),
                                                'month': DateTime.now()
                                                    .month
                                                    .toString(),
                                                'year': DateTime.now()
                                                    .year
                                                    .toString(),
                                                'coin': gift.price
                                              });
                                            }
                                          });
                                        }).then((value) {
                                      String docs =
                                          "${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                                      if (type == "host") {
                                        int lastincome = 0;
                                        _firestore
                                            .collection('agency')
                                            .doc(agent)
                                            .collection('users')
                                            .doc(userSeats[index])
                                            .collection('income')
                                            .doc(docs)
                                            .get()
                                            .then((value) {
                                          lastincome = int.parse(
                                              value.get('count')) +
                                              int.parse(gift.price);
                                        }).whenComplete(() {
                                          if (lastincome == 0) {
                                            _firestore
                                                .collection('agency')
                                                .doc(agent)
                                                .collection('users')
                                                .doc(userSeats[index])
                                                .collection('income')
                                                .doc(docs)
                                                .set({
                                              'date': DateTime.now()
                                                  .toString(),
                                              'hosttime': '0',
                                              'numberradio': '0',
                                              'count': gift.price,
                                            });
                                          } else {
                                            _firestore
                                                .collection('agency')
                                                .doc(agent)
                                                .collection('users')
                                                .doc(userSeats[index])
                                                .collection('income')
                                                .doc(docs)
                                                .update({
                                              'count':
                                              lastincome.toString()
                                            });
                                          }
                                          SendDone();
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        SendDone();
                                        Navigator.pop(context);
                                      }
                                    }).then((value) {
                                      Navigator.pop(context);
                                      controller.message.send(
                                          "Send ${gift.Name} to User ${name}");
                                      _firestore
                                          .collection('room')
                                          .doc(widget.roomID)
                                          .update({
                                        'gift': gift.photo,
                                        'gifttype': gift.type
                                      });
                                      setState(() {
                                        giftMedia = gift.photo;
                                        gifttype = gift.type;
                                      });
                                      SendDone();
                                      Future.delayed(
                                          const Duration(seconds: 4))
                                          .then((value) {
                                        _firestore
                                            .collection('room')
                                            .doc(widget.roomID)
                                            .update({
                                          'gift': "",
                                          'gifttype': ""
                                        });
                                        setState(() {
                                          giftMedia = "";
                                          gifttype = "";
                                        });
                                      }).then((value) {
                                        String docGift =
                                            "${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                                        _firestore
                                            .collection('room')
                                            .doc(widget.roomID)
                                            .collection('gift')
                                            .doc(docGift)
                                            .set({
                                          'giftdoc': gift.docID,
                                          'sender':
                                          _auth.currentUser!.uid,
                                          'recever': userSeats[index]
                                        }).then((value) {
                                          _firestore
                                              .collection('user')
                                              .doc(_auth.currentUser!.uid)
                                              .collection('sendgift')
                                              .doc()
                                              .set({
                                            'giftid': gift.docID,
                                            'target': userSeats[index]
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            } else {
                              SendDisApprove();
                            }
                          },
                        );
                      },
                    );
                  },
                );
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

  void UpdateBio() {
    TextEditingController controllerBio = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تحديث عنوان الغرفة"),
              content: Container(
                  height: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'ادخل عنوان الغرفة الجديد',
                        ),
                        controller: controllerBio,
                      ),
                      ElevatedButton(onPressed: () {}, child: Text("تحديث"))
                    ],
                  )));
        });
  }

  void ChangeMemberValue(String id, String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  height: 220,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('room')
                        .doc(widget.roomID)
                        .collection('user')
                        .snapshots(),
                    builder: (context, snapshot) {
                      String TpUser = "";
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed) {
                        if (massege.get('id') == id) {
                          TpUser = massege.get('type');
                        }
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MytypeInRoom == "owner"
                              ? ElevatedButton(
                              onPressed: () async {
                                if (TpUser == "admin") {
                                  await _firestore
                                      .collection('room')
                                      .doc(widget.roomID)
                                      .collection('user')
                                      .doc(id)
                                      .update({'type': 'admin'}).then(
                                          (value) {
                                        controller.message
                                            .send("Make ${name} as Co-Host");
                                        Navigator.pop(context);
                                      });
                                } else {
                                  await _firestore
                                      .collection('room')
                                      .doc(widget.roomID)
                                      .collection('user')
                                      .doc(id)
                                      .update({'type': 'normal'}).then(
                                          (value) {
                                        controller.message
                                            .send("Make ${name} as User");
                                        Navigator.pop(context);
                                      });
                                }
                              },
                              child: TpUser == "normal"
                                  ? Text("Make a Host")
                                  : Text("Make A Normal"))
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                controller.turnMicrophoneOn(false, userID: id);
                                Navigator.pop(context);
                              },
                              child: Text("Mute This Member")),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await _firestore
                                    .collection("room")
                                    .doc(widget.roomID)
                                    .collection('user')
                                    .doc(id)
                                    .delete()
                                    .then((value) {
                                  controller.message
                                      .send('Kikout ${name} from room');
                                  Navigator.pop(context);
                                });
                              },
                              child: Text("Kick out")),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _firestore
                                    .collection('room')
                                    .doc(widget.roomID)
                                    .collection('block')
                                    .doc(id)
                                    .set({'id': id}).then((value) {
                                  ZegoUIKit().removeUserFromRoom(
                                    [id],
                                  ).then((result) {
                                    _firestore
                                        .collection("room")
                                        .doc(widget.roomID)
                                        .collection('user')
                                        .doc(id)
                                        .delete()
                                        .then((value) {
                                      controller.message
                                          .send('Block ${name} in room');
                                    });
                                  });
                                });
                              },
                              child: Text("Block")),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  )));
        });
  }

  void RemoveMe() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Remove From Seat"),
              content: Container(
                  height: 220,
                  child: ElevatedButton(
                      onPressed: () {
                        controller
                            .removeSpeakerFromSeat(_auth.currentUser!.uid);
                      },
                      child: Text("UnTake Seat"))));
        });
  }

  void ShowNumberSeat() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تحدديد عدد المايكات"),
              content: Container(
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            _firestore
                                .collection('room')
                                .doc(widget.roomID)
                                .update({'seat': '9'}).then((value) {
                              setState(() {
                                layoutSeats = '9';
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Text('9')),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            _firestore
                                .collection('room')
                                .doc(widget.roomID)
                                .update({'seat': '11'}).then((value) {
                              setState(() {
                                layoutSeats = '11';
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Text('11')),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            _firestore
                                .collection('room')
                                .doc(widget.roomID)
                                .update({'seat': '13'}).then((value) {
                              setState(() {
                                layoutSeats = '13';
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Text('13')),
                    ],
                  )));
        });
  }
}

void onMemberListMoreButtonPressed(
    ZegoUIKitUser user,
    BuildContext context,
    bool isHost,
    FirebaseFirestore firestore,
    String roomID,
    ZegoLiveAudioRoomController controller) {
  showModalBottomSheet(
    backgroundColor: const Color(0xff111014),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
      final listMenu = isHost
          ? [
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
            ZegoUIKit().removeUserFromRoom(
              [user.id],
            ).then((result) {
              firestore
                  .collection("room")
                  .doc(roomID)
                  .collection('user')
                  .doc(user.id)
                  .delete()
                  .then((value) {
                controller.message.send('Kikout ${user.name} from room');
              });
            });
          },
          child: Text(
            'Kick Out ${user.name}',
            style: textStyle,
          ),
        ),
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
            firestore
                .collection('room')
                .doc(roomID)
                .collection('block')
                .doc(user.id)
                .set({'id': user.id}).then((value) {
              ZegoUIKit().removeUserFromRoom(
                [user.id],
              ).then((result) {
                firestore
                    .collection("room")
                    .doc(roomID)
                    .collection('user')
                    .doc(user.id)
                    .delete()
                    .then((value) {
                  controller.message.send('Block ${user.name} in room');
                });
              });
            });
          },
          child: Text(
            'Block ${user.name}',
            style: textStyle,
          ),
        ),
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();

            controller?.inviteAudienceToTakeSeat(user.id).then((result) {
              debugPrint('invite audience to take seat result:$result');
            });
          },
          child: Text(
            'Invite ${user.name} to take seat',
            style: textStyle,
          ),
        ),
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: textStyle,
          ),
        ),
      ]
          : [];
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listMenu.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 60,
                child: Center(child: listMenu[index]),
              );
            },
          ),
        ),
      );
    },
  );
}