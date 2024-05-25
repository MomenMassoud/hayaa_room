import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/vip%20center/widgets/send_vip.dart';
import '../../../core/Utils/app_images.dart';
import '../functions/buying_vip.dart';
import '../models/feature_model.dart';
import 'feature_item.dart';

class VipSectionFoure extends StatefulWidget {
  const VipSectionFoure({
    super.key,
  });

  @override
  State<VipSectionFoure> createState() => _VipSectionFoure();
}

class _VipSectionFoure extends State<VipSectionFoure> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<FeatureModel> featurs = [
    FeatureModel(
        featureIcon: AppImages.Wearingmedal,
        featureLable: "Wearing medal ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Titlemedal,
        featureLable: "Title medal ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Roomentereffect,
        featureLable: "Room enter effect  ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Flyingcomments,
        featureLable: "Flying comments ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Colorednickname,
        featureLable: "Colored nickname ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Toponlinerankinglist,
        featureLable: "Top Medal",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Upgradelevelfast,
        featureLable: "Upgrade level fast ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.platformwidenotification,
        featureLable: "platform-wide notification ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Exclusivenobletitlecard,
        featureLable: "Exclusive noble title card ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.specialchatbubble,
        featureLable: "special chat bubble",
        active: false),
    FeatureModel(
        featureIcon: AppImages.exclusiverideandmic,
        featureLable: "exclusive ride and mic ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Exclusivegifts,
        featureLable: "Exclusive gifts ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Profilethemeandspecialprofilepagelook,
        featureLable: "Profile theme and special profile page look ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Storediscounts,
        featureLable: "Store discounts",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Sendpicsinthepublicscreen,
        featureLable: "Send pics in the public screen ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Preventbeingtextbanned,
        featureLable: "Prevent being text banned ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Preventbeingkickedoutfromtheroom,
        featureLable: "Prevent being kicked out from the room ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Hideidentityonlists,
        featureLable: "Hide identity on lists ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Sneakingintorooms,
        featureLable: "Sneaking into rooms ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Hidethecountryandtheage,
        featureLable: "Hide the country and the age ",
        active: false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVipPrice();
    getUser();
  }

  int myCoins = 0;
  String myVip = "";
  int myExp = 0;
  void getUser() async {
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        myCoins = int.parse(snap.get('coin'));
        myVip = snap.get("vip");
        myExp = int.parse(snap.get('exp'));
      });
    }
  }

  int price = 0;
  void getVipPrice() async {
    await for (var snap in _firestore
        .collection('vip')
        .where('id', isEqualTo: 'vip4')
        .snapshots()) {
      setState(() {
        price = int.parse(snap.docs[0].get('coin'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHight * 0.22,
          width: screenWidth,
          child: Center(
            child: SizedBox(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                child: const Image(image: AssetImage(AppImages.VIP4))),
          ),
        ),
        Expanded(
          child: ClipPath(
            clipper: CurvedContainerClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHight * 0.05,
                    ),
                    Text("الامتيازات",
                        style: TextStyle(color: Colors.amberAccent[100])),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(featurs.length, (index) {
                            return FeatureItem(
                                screenWidth: screenWidth,
                                featureModel: featurs[index]);
                          }),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHight * 0.08,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: const Border(
                              top: BorderSide(color: Colors.grey, width: 0.6))),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amberAccent),
                              ),
                              onPressed: () {
                                buyingVip(
                                    myCoins: myCoins,
                                    price: price,
                                    myVip: myVip,
                                    sectionVip: "4",
                                    myExp: myExp,
                                    firestore: _firestore,
                                    auth: _auth,
                                    context: context);
                              },
                              child: Text(
                                "شراء",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        22), // Set the border radius
                                    side: const BorderSide(
                                        color: Colors.amberAccent,
                                        width: 1), // Set the border properties
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SendVip('4', price)));
                              },
                              child: const Text(
                                "ارسال",
                                style: TextStyle(color: Colors.amberAccent),
                              )),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$price Coin",
                            style: const TextStyle(
                                color: Colors.amberAccent, fontSize: 20),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CurvedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedContainerClipper oldClipper) => false;
}
