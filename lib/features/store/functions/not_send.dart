import 'package:flutter/material.dart';

void NotSend(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("ناسف"),
            content: Container(
              height: 120,
              child: Center(
                child: Text("ناسف برجاء لا تملك عملات كافية"),
              ),
            ));
      });
}
