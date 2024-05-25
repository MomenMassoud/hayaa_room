import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key, required this.eventsImages});
  final List<String> eventsImages;
  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHight,
        width: screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    AssetImage("lib/core/Utils/assets/images/wallpaper.jpeg"))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.31),
                  const Text(
                    "Events",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: screenHight * 0.89,
                child: ListView.builder(
                  itemCount: widget.eventsImages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: screenHight * 0.20,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                                widget.eventsImages[index])),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
