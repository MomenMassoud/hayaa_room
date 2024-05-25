import 'package:flutter/material.dart';

class VipCard extends StatelessWidget {
  const VipCard({
    super.key,
    required this.vipValue,
  });

  final String vipValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: Text(
        "VIP$vipValue",
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 14,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
