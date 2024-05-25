import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'my_avatar.dart';
import 'my_bubble.dart';
import 'my_car.dart';

class MyLookBody extends StatefulWidget {
  _MyLookBody createState() => _MyLookBody();
}

class _MyLookBody extends State<MyLookBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        return Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text('مظهري',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 30.0,
                      color: Color(0xFF545D68)))
              .tr(args: ['مظهري']),
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: const Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 45.0),
              unselectedLabelColor: const Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: const Text('السيارات',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )).tr(args: ['السيارات']),
                ),
                Tab(
                  child: const Text('مول الراس',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )).tr(args: ['مول الراس']),
                ),
                Tab(
                  child: const Text('فقاعه',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )).tr(args: ['فقاعه']),
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            MyCar(),
            MyAvatar(),
            MyBubble(),
          ],
        ),
      ),
    );
  }
}
