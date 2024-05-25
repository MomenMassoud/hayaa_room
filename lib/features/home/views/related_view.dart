import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../functions/get_related_users.dart';
import '../widgets/room_card.dart';

class RelatedView extends StatefulWidget {
  const RelatedView({super.key});

  @override
  State<RelatedView> createState() => _RelatedViewState();
}

class _RelatedViewState extends State<RelatedView> {
  Stream<List<String>> getRelatedUsersStream() {
    return Stream.fromFuture(getRelatedUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: getRelatedUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String>? relatedUsers = snapshot.data;
              // Render your UI using the relatedUsers list
              return FutureBuilder(
                future: getrealtedRooms(relatedUsers!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return RoomCard(roomModel: snapshot.data![index]);
                        },
                      );
                    } else {
                      return const Center(
                          child: Text(
                        "Your Frinds Have No Rooms Yet",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ));
                    }
                  } else if (snapshot.hasError) {
                    return Text(
                        "OOps! an error has occoured ${snapshot.toString()}");
                  } else {
                    return const SizedBox();
                  }
                },
              );
            } else if (snapshot.hasError) {
              // Handle error state
              return Text(
                "Opps an error happend with message ${snapshot.toString()}",
              );
            } else {
              // Show a loading indicator
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ));
            }
          },
        ),
      ),
    );
  }
}
