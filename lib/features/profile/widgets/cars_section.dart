import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CarsSection extends StatelessWidget {
  const CarsSection(
      {super.key,
      required this.carsItemPhotos,
      this.onBuyTap,
      this.onManageTap});
  final List<dynamic> carsItemPhotos;
  final void Function()? onBuyTap;
  final void Function()? onManageTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "السيارات",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ).tr(args: ["السيارات"]),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("ادارة").tr(args: ["ادارة"]),
                IconButton(
                    onPressed: onManageTap,
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                    )),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        carsItemPhotos.isNotEmpty
            ? SizedBox(
                height: 75,
                child: ListView.builder(
                  itemCount:
                      carsItemPhotos.length > 4 ? 4 : carsItemPhotos.length,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
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
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 10),
                          child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: carsItemPhotos[index]),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: onBuyTap,
                          child: const Icon(
                            Icons.add,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "يشتري",
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ).tr(args: ['يشتري'])
                      ],
                    ),
                    const SizedBox(width: 30),
                    const Text("لا توجد سيارات").tr(args: ['لا توجد سيارات'])
                  ],
                ),
              )
      ],
    );
  }
}
