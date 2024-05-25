import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import '../../chat/widget/group/family_rank_list/family_body.dart';
import '../views/events_view.dart';
import '../views/main_rank_list_view.dart';
import 'gradient_rounded_container.dart';

class SubScreensSection extends StatelessWidget {
  const SubScreensSection({
    super.key,
    required this.screenHight,
    required this.screenWidth,
    required this.evetsImages,
  });

  final double screenHight;
  final double screenWidth;
  final List<String> evetsImages;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, MainRankListView.id);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.indigo,
                  colorTwo: Colors.green),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child: const Image(image: AssetImage(AppImages.trophy))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "جينيس",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.017),
                    ).tr(args: ['جينيس']),
                  )
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsView(eventsImages: evetsImages),
                ));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.orange,
                  colorTwo: Colors.deepOrange),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child:
                          const Image(image: AssetImage(AppImages.megaPhone))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "الفعاليات",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.018),
                    ).tr(args: ['الفعاليات']),
                  )
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FamilyBody()));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.purple,
                  colorTwo: Colors.pink),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child: const Image(image: AssetImage(AppImages.badge))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "العائلة",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.018),
                    ).tr(args: ['العائلة']),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
