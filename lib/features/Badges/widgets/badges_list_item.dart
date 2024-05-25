import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/badge_model.dart';

class BadgesListItem extends StatelessWidget {
  const BadgesListItem({
    super.key,
    required this.screenWidth,
    required this.badgeModel,
    required this.opacity,
    required this.bgImage,
  });

  final double screenWidth;
  final BadgeModel badgeModel;
  final double opacity;
  final String bgImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[700],
      child: BadgeInfo(
          bgImage: bgImage,
          screenWidth: screenWidth,
          opacity: opacity,
          badgeModel: badgeModel),
    );
  }
}

class BadgeInfo extends StatefulWidget {
  BadgeInfo({
    super.key,
    required this.screenWidth,
    required this.opacity,
    required this.badgeModel,
    required this.bgImage,
    this.widgtHieght,
  });

  final double screenWidth;
  final double opacity;
  final BadgeModel badgeModel;
  final String bgImage;
  double? widgtHieght;
  _BadgeInfo createState() => _BadgeInfo();
}

class _BadgeInfo extends State<BadgeInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('gifts').snapshots(),
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
            if (massege.id == widget.badgeModel.gift) {
              widget.badgeModel.Giftphoto = massege.get('photo');
            }
          }
          return Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Opacity(
                    opacity: 0.5,
                    child: SizedBox(
                        width: widget.screenWidth * 0.5,
                        height: widget.widgtHieght ?? widget.screenWidth * 0.5,
                        child: Image(image: AssetImage(widget.bgImage)))),
                Column(
                  children: [
                    SizedBox(
                      width: widget.screenWidth * 0.35,
                      height: widget.screenWidth * 0.30,
                      child: Opacity(
                          opacity: widget.opacity,
                          child: CachedNetworkImage(
                              imageUrl: widget.badgeModel.badgeImage)),
                    ),
                    Text(
                      widget.badgeModel.badgeName,
                      style: TextStyle(
                          color: Colors.brown[100],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  void Allarm(String photo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: widget.badgeModel.done
                  ? Text("مبرك")
                  : Text("معلومات الشارة"),
              content: widget.badgeModel.done
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("تم الحصول هذه الشارة")],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "تحتاج الي ارسال هذه الهدية ${widget.badgeModel.count}"),
                        SizedBox(
                          height: 70,
                        ),
                        CachedNetworkImage(
                            imageUrl: widget.badgeModel.Giftphoto)
                      ],
                    ));
        });
  }
}
