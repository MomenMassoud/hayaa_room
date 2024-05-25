import 'package:flutter/material.dart';

void vipBuyingSuccesfully(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
            title: Text("مبرك"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [Text("تم الحصول هذه Vip")],
            ));
      });
}
