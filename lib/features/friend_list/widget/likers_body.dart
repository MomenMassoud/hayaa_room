import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/user_profile_card.dart';

import '../functions/get_fans_ids.dart';
import '../functions/get_users_profiles.dart';

class LikerBody extends StatefulWidget {
  _LikerBody createState() => _LikerBody();
}

class _LikerBody extends State<LikerBody> {
  Stream<List<String>> getUsersIdsStream() {
    return Stream.fromFuture(getFansUsersIds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: getUsersIdsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String>? usersIds = snapshot.data;
              // Render your UI using the relatedUsers list
              return FutureBuilder(
                future: getFrinsProfils(usersIds!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: ListView.builder(
                          itemCount: usersIds.length,
                          itemBuilder: (context, index) {
                            return UserProfileCard(
                                userData: snapshot.data![index]);
                          },
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text(
                        "You don't have fans yet!",
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
