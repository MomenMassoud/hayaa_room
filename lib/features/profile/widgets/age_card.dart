import 'package:flutter/material.dart';

class AgeCard extends StatelessWidget {
  const AgeCard({
    super.key,
    required this.age,
    required this.gender,
  });
  final int age;
  final String gender;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: Colors.lightBlue, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gender.toLowerCase() == "male" ? Icons.male : Icons.female,
            size: 22,
            color: Colors.white,
          ),
          Text(
            age.toString(),
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
