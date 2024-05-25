import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/user_profile_card.dart';

import '../functions/get_friends_profiles.dart';
import '../functions/get_users_profiles.dart';

class FriendsBody extends StatefulWidget {
  const FriendsBody({super.key});

  @override
  State<FriendsBody> createState() => _FriendsBodyState();
}

class _FriendsBodyState extends State<FriendsBody> {
  Stream<List<String>> getUsersIdsStream() {
    return Stream.fromFuture(getFrindsUsersIds());
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
                        "You don't have friends yet!",
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

// class FriendsBody extends StatefulWidget {
//   _FriendsBody createState() => _FriendsBody();
// }

// class _FriendsBody extends State<FriendsBody> {
//   UserModel userModel = UserModel(
//       "email",
//       "name",
//       "gende",
//       "photo",
//       "id",
//       "phonenumber",
//       "devicetoken",
//       "daimond",
//       "vip",
//       "bio",
//       "seen",
//       "lang",
//       "country",
//       "type",
//       "birthdate",
//       "coin",
//       "exp",
//       "level");
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   List<FriendsModel> friendsModels = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('user').where('doc',isEqualTo: _auth.currentUser!.uid).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.blue,
//             ),
//           );
//         }
//         final masseges = snapshot.data?.docs;
//         for (var massege in masseges!.reversed) {
//           userModel.bio = massege.get('bio');
//           userModel.birthdate = massege.get('birthdate');
//           userModel.coin = massege.get('coin');
//           userModel.country = massege.get('country');
//           userModel.daimond = massege.get('daimond');
//           userModel.coin = massege.get('coin');
//           userModel.devicetoken = massege.get('devicetoken');
//           userModel.email = massege.get('email');
//           userModel.exp = massege.get('exp');
//           userModel.gender = massege.get('gender');
//           userModel.id = massege.get('id');
//           userModel.lang = massege.get('lang');
//           userModel.level = massege.get('level');
//           userModel.name = massege.get('name');
//           userModel.phonenumber = massege.get('phonenumber');
//           userModel.photo = massege.get('photo');
//           userModel.seen = massege.get('seen').toString();
//           userModel.type = massege.get('type');
//           userModel.vip = massege.get('vip');
//           userModel.docID = massege.id;
//         }
//         return StreamBuilder<QuerySnapshot>(
//           stream: _firestore
//               .collection('user')
//               .doc(userModel.docID)
//               .collection('friends')
//               .snapshots(),
//           builder: (context, snapshot) {
//             List<String> FriendID = [];
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   backgroundColor: Colors.blue,
//                 ),
//               );
//             }
//             final masseges = snapshot.data?.docs;
//             for (var massege in masseges!.reversed) {
//               FriendID.add(massege.id);
//             }
//             return ListView.builder(
//                 itemCount: FriendID.length,
//                 itemBuilder: (context, index) {
//                   return StreamBuilder<QuerySnapshot>(
//                       stream: _firestore.collection('user').where('doc',isEqualTo: FriendID[index]).snapshots(),
//                       builder: (context,snapshot){
//                         if (!snapshot.hasData) {
//                           return const Center(
//                             child: CircularProgressIndicator(
//                               backgroundColor: Colors.blue,
//                             ),
//                           );
//                         }
//                         final masseges = snapshot.data?.docs;
//                         for (var massege in masseges!.reversed){
//                           FriendsModel ff = FriendsModel(
//                               massege.get('email'),
//                               massege.get('id'),
//                               massege.id,
//                               massege.get('photo'),
//                               massege.get('name'),
//                               massege.get('phonenumber'),
//                               massege.get('gender'));
//                           ff.bio = massege.get('bio');
//                           friendsModels.add(ff);
//                         }
//                         return Padding(
//                           padding:  EdgeInsets.all(8.0),
//                           child: ListTile(
//                             title: Text(friendsModels[index].name),
//                             leading: InkWell(
//                               onTap: (){
//                                 Navigator.of(context).push(
//                                     MaterialPageRoute(builder: (context) => VistorView(friendsModels[index].photo,friendsModels[index].docID)));
//                               },
//                               child: CircleAvatar(
//                                 backgroundImage: CachedNetworkImageProvider(
//                                     friendsModels[index].photo),
//                               ),
//                             ),
//                             subtitle: InkWell(
//                               onTap: (){
//                                 Navigator.of(context).push(
//                                     MaterialPageRoute(builder: (context) => VistorView(friendsModels[index].photo,friendsModels[index].docID)));
//                               },
//                                 child: Text(friendsModels[index].bio)),
//                             trailing: InkWell(
//                               onTap: (){
//                                 Navigator.pop(context);
//                                 Navigator.of(context).push(
//                                     MaterialPageRoute(builder: (context) => ChatBody(friend: friendsModels[index]))
//                                 );
//                               },
//                                 child: Text("دردشة",style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),))
//                           ),
//                         );
//                       }
//                   );
//                 }
//                 );
//           },
//         );
//       },
//     ));
//   }
// }
