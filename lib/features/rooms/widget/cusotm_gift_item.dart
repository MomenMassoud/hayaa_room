import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../../../core/Utils/app_images.dart';
import '../../../models/gift_model.dart';

class CustomtGiftItem extends StatelessWidget {
  const CustomtGiftItem(
      {super.key, required this.giftData, required this.isSelected});
  final GiftModel giftData;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xff120C18),
            border: isSelected
                ? Border.all(color: const Color(0xff5CE49C), width: 3)
                : const Border()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            giftData.type == "svga"
                ? SizedBox(
                    height: 45,
                    child: SVGASimpleImage(
                      resUrl: giftData.photo,
                    ),
                  )
                : SizedBox(
                    height: 45,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: giftData.photo,
                    ),
                  ),
            Text(
              giftData.Name,
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(AppImages.gold_coin),
                  radius: 5,
                ),
                const SizedBox(width: 2),
                Text(
                  giftData.price,
                  style: const TextStyle(color: Colors.orangeAccent),
                )
              ],
            )
          ],
        ));
  }
}
