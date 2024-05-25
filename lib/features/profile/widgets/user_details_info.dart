import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class UserDetailsInfo extends StatelessWidget {
  const UserDetailsInfo({
    super.key,
    required this.userModel,
    required this.fans,
  });
  final UserModel userModel;
  final String fans;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ID: ${userModel.id}",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () async {
                await FlutterClipboard.copy(userModel.id).whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Copyed ID"),
                    showCloseIcon: true,
                  ));
                });
              },
              child: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 16,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
          child: VerticalDivider(
            color: Colors.grey,
            thickness: 2.5,
          ),
        ),
        Text(
          userModel.acualCountry ?? "Egypt",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(
          height: 15,
          child: VerticalDivider(
            color: Colors.grey,
            thickness: 2.5,
          ),
        ),
        Text(
          "Fans:$fans",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(
          height: 15,
          child: VerticalDivider(
            color: Colors.grey,
            thickness: 2.5,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.28,
          child: Text(
            userModel.seen,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
