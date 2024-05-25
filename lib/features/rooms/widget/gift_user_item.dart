import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/audince_list_user_modal.dart';

class GiftUserItem extends StatelessWidget {
  const GiftUserItem(
      {super.key, required this.isSelected, required this.userData});
  final bool isSelected;
  final AudinceListUserModal userData;
  @override
  Widget build(BuildContext context) {
    return isSelected
        ? CircleAvatar(
            backgroundColor: const Color(0xff0CDCA2),
            radius: 26,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userData.photo),
              radius: 22,
            ),
          )
        : CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userData.photo),
            radius: 22,
          );
  }
}
