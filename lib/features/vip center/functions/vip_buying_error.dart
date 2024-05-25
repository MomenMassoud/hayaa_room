import 'package:flutter/material.dart';

void vipBuyingError(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
            title: Text("ناسف"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [Text("لا تملك عملات كافية")],
            ));
      });
}
