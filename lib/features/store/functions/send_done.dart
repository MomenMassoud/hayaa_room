import 'package:flutter/material.dart';

void SendDone(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("مبروك"),
            content: Container(
              height: 120,
              child: Center(
                child: Text("تم ارسال العنصر بنجاح"),
              ),
            ));
      });
}
