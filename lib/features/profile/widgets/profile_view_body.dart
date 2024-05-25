import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../models/user_model.dart';
import '../../Badges/views/badges_center.dart';
import '../../agencies/views/agency_agent_view.dart';
import '../../agencies/views/agency_host_view.dart';
import '../../agencies/views/agency_join_view.dart';
import '../../chat/widget/group/family_rank_list/view_all_family_body.dart';
import '../../chat/widget/group/myfamily/my_family_body.dart';
import '../../friend_list/view/visitor_view.dart';
import '../../friend_list/widget/friend_list_body.dart';
import '../../mylook/view/my_look_view.dart';
import '../../recharge_coins/views/recharge_view.dart';
import '../../salery/view/salery_view.dart';
import '../../setting/views/setting_view.dart';
import '../../store/view/store_view.dart';
import '../../user_leve/view/user_level_view.dart';
import '../../vip center/views/vip_center_view.dart';
import '../views/profile_edit_view.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({
    super.key,
  });
  _ProfileViewBody createState() => _ProfileViewBody();
}

class _ProfileViewBody extends State<ProfileViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: _auth.currentUser!.email == null
              ? _firestore
                  .collection('user')
                  .where('email', isEqualTo: _auth.currentUser!.phoneNumber)
                  .snapshots()
              : _firestore
                  .collection('user')
                  .where('email', isEqualTo: _auth.currentUser!.email)
                  .snapshots(),
          builder: (context, snapshot) {
            UserModel userModel = UserModel(
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
            if (!snapshot.hasData) {
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
              userModel.docID = massege.id;
              userModel.myfamily = massege.get('myfamily');
              context.setLocale(Locale(userModel.lang, userModel.country));
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .doc(userModel.docID)
                  .collection('friends')
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
                userModel.sizeFirends = masseges!.length.toInt();
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('user')
                      .doc(userModel.docID)
                      .collection('following')
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
                    userModel.sizefollowing = masseges!.length.toInt();
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('user')
                          .doc(userModel.docID)
                          .collection('fans')
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
                        userModel.sizefans = masseges!.length.toInt();
                        return StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('user')
                              .doc(userModel.docID)
                              .collection('visitor')
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
                              userModel.sizevisitors = masseges.length;
                            }
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.appInformationColors100,
                                    AppColors.appInformationColors700
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  stops: [0.2, 0.9],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 190.0,
                                        bottom: 30,
                                        right: 10,
                                        left: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  userModel.photo),
                                          radius: 50,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.52,
                                              child: Text(
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                userModel.name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("ID: ${userModel.id}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                                IconButton(
                                                    onPressed: () async {
                                                      await FlutterClipboard
                                                              .copy(
                                                                  userModel.id)
                                                          .whenComplete(() {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content:
                                                              Text("Copyed ID"),
                                                          showCloseIcon: true,
                                                        ));
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.copy,
                                                      size: 13,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return ProfileEditView(
                                                      fans: userModel.sizefans
                                                          .toString());
                                                },
                                              ));
                                            },
                                            icon: const Icon(Icons
                                                .arrow_forward_ios_rounded))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FriendListBody(
                                                                    userModel)));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        userModel.sizeFirends
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                      const Text("اصدقاء",
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                              ))
                                                          .tr(args: ['اصدقاء'])
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FriendListBody(
                                                                    userModel)));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          userModel
                                                              .sizefollowing
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      22)),
                                                      const Text("تمت المتابعة",
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                          )).tr(args: [
                                                        'تمت المتابعة'
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FriendListBody(
                                                                    userModel)));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          userModel.sizefans
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      22)),
                                                      const Text("المعجبون",
                                                              style: TextStyle(
                                                                  fontSize: 17))
                                                          .tr(args: [
                                                        'المعجبون'
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        VisitorView.id);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          userModel.sizevisitors
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      22)),
                                                      const Text("عدد الزوار",
                                                              style: TextStyle(
                                                                  fontSize: 17))
                                                          .tr(args: [
                                                        'عدد الزوار'
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0,
                                                left: 8.0,
                                                top: 3.0),
                                            child: ListTile(
                                              title: const Text(
                                                "اعادة الشحن",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['اعادة الشحن']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.wallet,
                                                color: Colors.yellow,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, RechargeView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8.0),
                                            child: ListTile(
                                              title: const Text(
                                                "ماسات",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['دخل']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.diamond_outlined,
                                                color: Colors.blue,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, SaleryView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8.0),
                                            child: ListTile(
                                              title: const Text(
                                                "مستوي المستخدم",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['مستوي المستخدم']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.stars_sharp,
                                                color: Colors.purpleAccent,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, UserLevelView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8.0),
                                            child: ListTile(
                                              title: const Text(
                                                "الوكالات",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['الوكالات']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.favorite,
                                                color: Colors.greenAccent,
                                              ),
                                              onTap: () {
                                                print(userModel.type);
                                                if (userModel.type == "agent") {
                                                  Navigator.pushNamed(context,
                                                      AgencyAgentView.id);
                                                } else if (userModel.type ==
                                                    "host") {
                                                  Navigator.pushNamed(context,
                                                      AgencyHostView.id);
                                                } else {
                                                  Navigator.pushNamed(context,
                                                      AgencyJoiningView.id);
                                                }
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8.0),
                                            child: ListTile(
                                              title: const Text(
                                                "مركز VIP",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['مركز VIP']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.spa_outlined,
                                                color: Colors.brown,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const VipCenterView()));
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8.0),
                                            child: ListTile(
                                              title: const Text(
                                                "الشارات",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['الشارات']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.badge,
                                                color: Colors.orange,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    BadgesCenterView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            child: ListTile(
                                              title: const Text(
                                                "مركز تجاري",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['مركز تجاري']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.storefront_sharp,
                                                color: Colors.greenAccent,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, StoreView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            child: ListTile(
                                              title: const Text(
                                                "مظهري",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['مظهري']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.backpack,
                                                color: Colors.greenAccent,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, MyLookView.id);
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            child: ListTile(
                                              title: const Text(
                                                "العائلة",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['العائلة']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.home_sharp,
                                                color: Colors.purple,
                                              ),
                                              onTap: () {
                                                if (userModel.myfamily == "") {
                                                  Navigator.pushNamed(context,
                                                      ViewAllFamilyBody.id);
                                                } else {
                                                  Navigator.pushNamed(
                                                      context, MyFamilyBody.id);
                                                }
                                              },
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            child: ListTile(
                                              title: const Text(
                                                "خدمة العملاء",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['خدمة العملاء']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.support_agent,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, left: 8),
                                            child: ListTile(
                                              title: const Text(
                                                "الاعدادات",
                                                style: TextStyle(fontSize: 19),
                                              ).tr(args: ['الاعدادات']),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12,
                                              ),
                                              leading: const Icon(
                                                Icons.settings,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, SettingView.id);
                                              },
                                            ),
                                          ),
                                          Divider(
                                            thickness: 0.2,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
