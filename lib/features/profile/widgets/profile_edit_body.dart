import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/profile/widgets/user_details_info.dart';
import '../../../models/user_model.dart';
import '../../Badges/views/badges_center.dart';
import '../../friend_list/widget/level_card.dart';
import '../../friend_list/widget/vip_card.dart';
import '../../mylook/view/my_look_view.dart';
import '../../store/widget/store_body.dart';
import '../functions/calculate_user_age.dart';
import '../functions/get_current_user_profile.dart';
import '../functions/get_user_cars.dart';
import '../functions/get_user_gifts.dart';
import 'age_card.dart';
import 'cars_section.dart';
import 'items_section.dart';
import 'modefiy_user_data.dart';

class ProfileEditBody extends StatefulWidget {
  const ProfileEditBody({super.key, required this.fans, this.isVisitor});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditBody createState() => _ProfileEditBody();
  final String fans;
  final bool? isVisitor;
}

class _ProfileEditBody extends State<ProfileEditBody>
    with SingleTickerProviderStateMixin {
  Stream<UserModel> getCurrrentUserProfile() {
    return Stream.fromFuture(getCurrentUserProfileData());
  }

  bool isRefrshed = false;
  void navigateReturnRefreshValue(Widget distination) async {
    final returnedValue = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => distination),
    );

    // Handle the returned value from the second view
    if (returnedValue != null) {
      setState(() {
        isRefrshed = returnedValue; // Update the state variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHight = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: getCurrrentUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel userModel = snapshot.data!;
          return FutureBuilder(
            future: getUserCars(),
            builder: (context, snapshot) {
              final List<String> userCars = snapshot.data ?? [];
              return FutureBuilder(
                future: getUsergifts(),
                builder: (context, snapshot) {
                  List<String> userGiftsPhotos = [];
                  userGiftsPhotos = snapshot.data ?? [];
                  return Scaffold(
                    body: Stack(
                      children: [
                        Container(
                          height: screenHight * 0.50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(userModel
                                  .photo), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Scaffold(
                          appBar: AppBar(
                            iconTheme: const IconThemeData(color: Colors.white),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            title: Text(
                              userModel.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            actions: [
                              widget.isVisitor == null
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          navigateReturnRefreshValue(
                                              ModefiyUserData(
                                            userData: userModel,
                                          ));
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit_calendar,
                                      ))
                                  : widget.isVisitor == false
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              navigateReturnRefreshValue(
                                                  ModefiyUserData(
                                                userData: userModel,
                                              ));
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.edit_calendar,
                                          ))
                                      : const SizedBox()
                            ],
                          ),
                          backgroundColor: Colors.transparent,
                          body: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 15),
                                      child: CircleAvatar(
                                        radius: 48,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  userModel.photo),
                                          radius: 45,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      userModel.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        AgeCard(
                                          age:
                                              calculateAge(userModel.birthdate),
                                          gender: userModel.gender,
                                        ),
                                        const SizedBox(width: 4),
                                        userModel.vip != "0"
                                            ? VipCard(vipValue: userModel.vip)
                                            : const SizedBox(),
                                        const SizedBox(width: 4),
                                        LevelCard(
                                          userLevel: userModel.level,
                                          levelImageType:
                                              "lib/core/Utils/assets/images/wealth&charm badges/wealth126-150.png",
                                        ),
                                        const SizedBox(width: 4),
                                        LevelCard(
                                          userLevel: userModel.level2,
                                          levelImageType:
                                              "lib/core/Utils/assets/images/wealth&charm badges/charm 126-150.png",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    UserDetailsInfo(
                                      userModel: userModel,
                                      fans: widget.fans,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          ItemsSection(
                                              onPressed: () {
                                                navigateReturnRefreshValue(
                                                    const BadgesCenterView());
                                              },
                                              itemsPhotos:
                                                  userModel.wearingBadges,
                                              itemSectionName: 'الشارات',
                                              noDataState: "لا توجد اي شارات",
                                              righPart: true),
                                          const SizedBox(height: 12),
                                          CarsSection(
                                            carsItemPhotos: userCars,
                                            onManageTap: () {
                                              navigateReturnRefreshValue(
                                                  MyLookView());
                                            },
                                            onBuyTap: () {
                                              navigateReturnRefreshValue(
                                                  StoreBody());
                                            },
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          ItemsSection(
                                              isScrool: true,
                                              itemsPhotos: userGiftsPhotos,
                                              itemSectionName: "هدية",
                                              noDataState:
                                                  "لا توجد هدايا متاحة حاليا",
                                              righPart: false),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "معلومة عني",
                                                style: TextStyle(fontSize: 18),
                                              ).tr(args: ['معلومة عني']),
                                              const SizedBox(height: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                constraints:
                                                    const BoxConstraints(
                                                        minHeight: 120),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Text(userModel.bio),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 12)
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Opps somthing wrong check your network!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.lightBlue,
          ));
        }
      },
    );
  }
}
