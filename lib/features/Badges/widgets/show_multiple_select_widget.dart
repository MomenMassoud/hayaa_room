import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/show_snack_par.dart';
import '../../rooms/widget/create_alarm_error.dart';
import '../functions/wearing_badges.dart';
import '../views/badges_center.dart';

class MultiSelectedBadgeWidget extends StatefulWidget {
  MultiSelectedBadgeWidget(
      {super.key, required this.myBadges, required this.selectedCounter});
  final List<Map> myBadges;
  int selectedCounter;
  @override
  State<MultiSelectedBadgeWidget> createState() =>
      _MultiSelectedBadgeWidgetState();
}

class _MultiSelectedBadgeWidgetState extends State<MultiSelectedBadgeWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please Choose Your Favorit Badges To wear:",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.myBadges.map((badge) {
                        return CheckboxListTile(
                          activeColor: Colors.deepPurpleAccent,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          title: CachedNetworkImage(
                            alignment: Alignment.centerLeft,
                            height: 45,
                            imageUrl: badge["image"],
                            fit: BoxFit.fitHeight,
                          ),
                          value: badge["isWeared"],
                          onChanged: (value) {
                            if (widget.selectedCounter == 4 &&
                                badge["isWeared"] == false) {
                              allarmError(
                                  "you can only choose 4 badges to wear pls, replace weard badge to another",
                                  context);
                            } else if (widget.selectedCounter == 4 &&
                                badge["isWeared"] == true) {
                              badge["isWeared"] = value;
                              setState(() {
                                widget.selectedCounter--;
                              });
                            } else if (widget.selectedCounter < 4 &&
                                badge["isWeared"] == false) {
                              badge["isWeared"] = value;
                              setState(() {
                                widget.selectedCounter++;
                              });
                            } else if (widget.selectedCounter < 4 &&
                                badge["isWeared"] == true) {
                              badge["isWeared"] = value;
                              setState(() {
                                widget.selectedCounter--;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          widget.selectedCounter != 0
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: widget.myBadges.map((badge) {
                        if (badge["isWeared"] == true) {
                          return Card(
                            elevation: 3,
                            color: Colors.lightBlue,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: badge["image"]),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      badge["isWeared"] = !badge["isWeared"];
                                      setState(() {
                                        widget.selectedCounter--;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox(),
          widget.selectedCounter != 0
              ? const Divider(
                  color: Colors.grey,
                  thickness: 1,
                )
              : const SizedBox(),
          ElevatedButton(
            onPressed: () async {
              List<String> selectedbadges = [];
              widget.myBadges.map((badge) {
                if (badge["isWeared"] == true) {
                  selectedbadges.add(badge["image"]);
                }
              }).toList();

              await wearBadges(selectedbadges);
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return BadgesCenterView();
                },
              ));
              showSnackBar("Succesfully", context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: const Size(150, 50)),
            child: const Text(
              "Apply",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
