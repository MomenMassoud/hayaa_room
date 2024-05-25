import 'package:flutter/material.dart';


import '../../../../../core/Utils/app_images.dart';
import '../../../model/group_rand_card.dart';
import '../other_card.dart';
import '../top_card.dart';


class FamilyRaceBody extends StatefulWidget{
  _FamilyRaceBody createState()=>_FamilyRaceBody();
}

class _FamilyRaceBody extends State<FamilyRaceBody>{
  List<GroupRandCard> cards = [
    GroupRandCard(
        cardImge: AppImages.img3,
        rating: 'Top 3',
        strokColor: Colors.purpleAccent,
        userImge: AppImages.momen,
        userName: "Player 66"),
    GroupRandCard(
        cardImge: AppImages.img1,
        rating: 'Top 2',
        strokColor: Colors.brown.withOpacity(0.5),
        userImge: AppImages.p3,
        userName: "Player 44"),
    GroupRandCard(
        ratingColor: Colors.cyan,
        cardImge: AppImages.img2,
        rating: 'Top 1',
        strokColor: Colors.amber,
        userImge: AppImages.p2,
        userName: "Player 22")
  ];
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.brown,
            Colors.blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 160,
              child: ListView(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, children: [
                      TopCard(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          cardModel: cards[1],coin: "",coinPic: true),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: TopCard(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            cardModel: cards[2],coin: "",coinPic: true),
                      ),
                      TopCard(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          cardModel: cards[0],coin: "",coinPic: true),
                    ],
                    ),
                  ),
                  OtherCard("Family", "4", "family bio", "11M",AppImages.p1),
                  OtherCard("Family", "5", "family bio", "11M",AppImages.p2),
                  OtherCard("Family", "6", "family bio", "11M",AppImages.p3),
                  OtherCard("Family", "7", "family bio", "11M",AppImages.p1),
                  OtherCard("Family", "8", "family bio", "11M",AppImages.momen),
                  OtherCard("Family", "9", "family bio", "11M",AppImages.p1),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text("انشاء عائلة")
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}