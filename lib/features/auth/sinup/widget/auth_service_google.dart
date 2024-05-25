import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/Utils/helper/device_info_getter.dart';
import '../../models/device_info.dart';

class AuthServiceGoogle {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Random random = Random();
  // signInWithGoogle() async {
  //   //interactive SignIn
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //   // auth request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //   //credaintial
  //   final credential = GoogleAuthProvider.credential(
  //       accessToken: gAuth.accessToken, idToken: gAuth.idToken);
  //   //let signin
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .then((value) {
  //     String id = "";
  //     _firestore
  //         .collection('user')
  //         .where('email', isEqualTo: _auth.currentUser!.email)
  //         .get()
  //         .then((value) {
  //       if (value.size == 0) {
  //         for (int i = 0; i < 8; i++) {
  //           int randomNumber = random.nextInt(10);
  //           id = "$id$randomNumber";
  //         }
  //         _firestore.collection('user').doc(_auth.currentUser!.uid).set({
  //           'name': _auth.currentUser?.displayName,
  //           'email': _auth.currentUser?.email,
  //           'gender': "male",
  //           'bio': "Hi,I Use Hayaa",
  //           'photo': _auth.currentUser?.photoURL,
  //           'room': '',         // this added to avoid error room in the docment not found
  //           'seen': 'online',
  //           'devicetoken': '',
  //           'country': "US",
  //           'lang': 'en',
  //           'coin': '250',
  //           'vip': '0',
  //           'level': '0',
  //           'level2': '0',
  //           'birthdate': '',
  //           'phonenumber': '',
  //           'type': 'normal',
  //           'doc': _auth.currentUser!.uid,
  //           'id': id,
  //           'exp': '0',
  //           'exp2': '0',
  //           'daimond': '0',
  //           'myagent': '',
  //           'mybubble': '',
  //           'mycar': '',
  //           'myframe': '',
  //           'myfamily': ''
  //         });
  //       }
  //     });
  //   });
  // }

  // my google sign in method
  // Future<String?> signInWithGoogle() async {
  //   try {
  //     //interactive SignIn
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       // auth request
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //       //credaintial
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       // Once signed in, return the UserCredential
  //       await FirebaseAuth.instance
  //           .signInWithCredential(credential)
  //           .then((value) {
  //         String id = "";
  //         //create id manual
  //         _firestore
  //             .collection('user')
  //             .where('email', isEqualTo: auth.currentUser!.email)
  //             .get()
  //             .then((value) {
  //           if (value.size == 0) {
  //             for (int i = 0; i < 8; i++) {
  //               int randomNumber = random.nextInt(10);
  //               id = "$id$randomNumber";
  //             }
  //             print(id);

  //             //for storing user data in fire base
  //           }
  //         });
  //         return id;
  //       });
  //     } else {
  //       // User canceled the sign-in process
  //       // Handle the cancellation or display an error message to the user
  //       throw Exception('Google sign-in was canceled by the user ');
  //     }
  //   } catch (e) {
  //     // Handle the specific error scenarios
  //     if (e is PlatformException) {
  //       if (e.code == 'sign_in_canceled') {
  //         // User canceled the sign-in process
  //         // Handle the cancellation or display an error message to the user
  //         throw Exception('Google sign-in was canceled by the user  ');
  //       } else if (e.code == '12501') {
  //         // Google Play services availability issue or invalid configuration
  //         // Handle the error or display an error message to the user
  //         throw Exception('Google sign-in failed try Again Later');
  //       } else {
  //         // Other platform-specific error occurred
  //         // Handle the error or display an error message to the user
  //         throw Exception(
  //             'An error occurred during Google sign-in: try Again Later');
  //       }
  //     } else {
  //       // Non-platform-specific error occurred
  //       // Handle the error or display an error message to the user
  //       throw Exception(
  //           'An error occurred during Google sign-in: try Again Later');
  //     }
  //   }
  // }

  Future<String?> signInWithGoogle() async {
    Completer<String?> completer = Completer<String?>();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          String id = "";

          _firestore
              .collection('user')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .get()
              .then((value) {
            if (value.size == 0) {
              for (int i = 0; i < 8; i++) {
                int randomNumber = random.nextInt(10);
                id = "$id$randomNumber";
              }
              print(id);

              completer.complete(id);
            } else {
              completer.complete(null);
            }
          });
        });
      } else {
        throw Exception('Google sign-in was canceled by the user');
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'sign_in_canceled') {
          throw Exception('Google sign-in was canceled by the user');
        } else if (e.code == '12501') {
          throw Exception('Google sign-in failed. Please try again later.');
        } else {
          throw Exception(
              'An error occurred during Google sign-in. Please try again later.');
        }
      } else {
        throw Exception(
            'An error occurred during Google sign-in. Please try again later.');
      }
    }

    return completer.future;
  }
}

Future<void> storeUserData(FirebaseAuth auth, String id, String country,
    String gender, String birthdate, String bio) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('user');
  DeviceInfo deviceInfo = await DeviceInfoGetters.basicDeviceInfo();
//print(deviceInfo.deviceIMEI);
  print(deviceInfo.id);
  print(deviceInfo.deviceName);
  print(deviceInfo.devicePlatform);
  print(deviceInfo.platformVersion);
  print(deviceInfo.appVersion);
  DateTime? registrationTime;
  String? lastProvider;
  User? user = auth.currentUser;
  if (user != null) {
    registrationTime = user.metadata.creationTime!;
    List<UserInfo> providerData = user.providerData;
    if (providerData.isNotEmpty) {
      lastProvider = providerData[0].providerId;
      print('Last Provider: $lastProvider');
    }
  }

  // store user data
  await users.doc(auth.currentUser!.uid).set({
    'name': auth.currentUser?.displayName,
    'email': auth.currentUser?.email,
    'gender': gender,
    'bio': bio,
    // 'photo': auth.currentUser?.photoURL,
    'photo': gender.toLowerCase() == "male"
        ? "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/usersPhoto%2Fp2.jpg?alt=media&token=6cfc7718-4e53-4d76-b253-7db698a548e9"
        : "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/usersPhoto%2Fp1.jpg?alt=media&token=ef4077ac-75b5-46fd-a9fd-5f634fe9367a",
    'room': '', // this added to avoid error room in the docment not found
    'seen': 'online',
    'devicetoken': '',
    'country': "US",
    "acualCountry": country,
    'lang': 'en',
    'coin': '250',
    'vip': '0',
    'level': '0',
    'level2': '0',
    'birthdate': birthdate,
    'phonenumber': '',
    'type': 'normal',
    'doc': auth.currentUser?.uid,
    'id': id,
    'exp': '0',
    'exp2': '0',
    'daimond': '0',
    'myagent': '',
    'mybubble': '',
    'mycar': '',
    'myframe': '',
    'myfamily': '',
    // 'deviceIMEI': deviceInfo.deviceIMEI,
    'deviceId': deviceInfo.id,
    'deviceName': deviceInfo.deviceName,
    'devicePlatform': deviceInfo.devicePlatform,
    'platformVersion': deviceInfo.platformVersion,
    'appVersion': deviceInfo.appVersion,
    'isPhysicaleDevice': deviceInfo.isPhysicaleDevice,
    'registrationTime': registrationTime.toString(),
    "lastProvider": lastProvider,
    //mainranklistcounting
    'charmday': 0,
    'welthday': 0,
    'charmweak': 0,
    'welthweak': 0,
    'charmmonth': 0,
    'welthmonth': 0,
    'charmhalfyear': 0,
    'welthhalfyear': 0,
  });
}
