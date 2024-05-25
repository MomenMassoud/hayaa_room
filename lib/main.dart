import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_code_metrics/analyzer_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hayaa_main/features/rooms/states_manager/room_creation/room_creation_cubit.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'core/Utils/app_routes.dart';
import 'features/splash/views/splash_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging =
      FirebaseMessaging.instance; // search about what is firebase messsaging
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin = // search about flutter localNotificationPlugin
  FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher'); // search for that
  var initializationSettingsIOS =
  const IOSInitializationSettings(); //search for that
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(EasyLocalization(supportedLocales: const [
    Locale('en', 'US'),
    Locale('ar', 'DZ'),
  ], path: 'lib/core/Utils/assets/lang', child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: analytics); // search for what is firebase analytics observer
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
  }

  @override // search for this code to understand it
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen": FieldValue.serverTimestamp(),
      });
      //for removing user form room is not working
      String roomJoined = "";
      DocumentSnapshot snapshot =
      await firestore.collection('user').doc(auth.currentUser!.uid).get();
      roomJoined = snapshot.get("roomJoined");
      log(roomJoined);
      //User Leave Room
      if (roomJoined != "") {
        firestore
            .collection('room')
            .doc(roomJoined)
            .collection('user')
            .doc(auth.currentUser!.uid)
            .delete();
      }

      print("object");
    } else if (state == AppLifecycleState.inactive) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen": FieldValue.serverTimestamp(),
      });
      print("object");
    } else {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen": "online",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomCreationCubit(),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: appRoutes,
        initialRoute: SplashView.id,
      ),
    );
  }
}