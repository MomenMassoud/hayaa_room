import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ItemsSection extends StatelessWidget {
  ItemsSection({
    super.key,
    required this.itemsPhotos,
    required this.itemSectionName,
    required this.noDataState,
    required this.righPart,
    this.isScrool = false,
    this.onPressed,
  });
  final List<dynamic> itemsPhotos;
  bool isScrool = false;
  final String itemSectionName;
  final String noDataState;
  final bool righPart;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              itemSectionName,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ).tr(args: [itemSectionName]),
            const Spacer(),
            righPart
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("رؤية المزيد").tr(args: ['رؤية المزيد']),
                      IconButton(
                          onPressed: onPressed,
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                          )),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 6),
        itemsPhotos.isNotEmpty
            ? SizedBox(
                height: 75,
                child: ListView.builder(
                  itemCount: itemsPhotos.length,
                  scrollDirection: Axis.horizontal,
                  physics: isScrool
                      ? const ScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width * 0.215,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  itemsPhotos[index])),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text(noDataState).tr(args: [noDataState]),
      ],
    );
  }
}
