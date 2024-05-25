import 'package:flutter/material.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.userLevel,
    required this.levelImageType,
  });

  final String userLevel;
  final String levelImageType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 55, minHeight: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              levelImageType,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 3),
          child: Text(
            userLevel,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
