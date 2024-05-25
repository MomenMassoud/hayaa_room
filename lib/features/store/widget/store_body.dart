import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'car_store.dart';
import 'freams_store.dart';
import 'head_store.dart';
import 'wallpaper_store.dart';

class StoreBody extends StatefulWidget {
  _StoreBody createState() => _StoreBody();
}

class _StoreBody extends State<StoreBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text('مركز تجاري',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 30.0,
                      color: Color(0xFF545D68)))
              .tr(args: ['مركز تجاري']),
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: const Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 45.0),
              unselectedLabelColor: const Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: const Text('خلفيات',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )).tr(args: ['رمز تعبيري']),
                ),
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
            WallpaperStore(),
            CarStoreList(),
            FrameStore(),
            HeadStore(),
          ],
        ),
      ),
    );
  }
}
