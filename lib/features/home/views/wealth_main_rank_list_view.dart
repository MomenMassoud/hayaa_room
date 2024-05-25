import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/views/wealth_daily_rank_list.dart';
import 'package:hayaa_main/features/home/views/wealth_monthly_rank_list.dart';
import 'package:hayaa_main/features/home/views/wealth_weakly_rank_list.dart';

import '../../../core/Utils/app_images.dart';

class WealthMainRankListView extends StatefulWidget {
  const WealthMainRankListView({super.key});

  @override
  State<WealthMainRankListView> createState() => _WealthMainRankListViewState();
}

class _WealthMainRankListViewState extends State<WealthMainRankListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHieght = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: screenHieght * 0.48),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  image: AssetImage(AppImages.welthStage1))),
        ),
        Padding(
          padding: EdgeInsets.only(top: screenHieght * 0.08),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: screenWidth * 0.76,
                  height: screenHieght * 0.046,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(45)),
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.white,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      controller: _tabController,
                      splashBorderRadius: BorderRadius.circular(20),
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Varela',
                      ),
                      labelColor: Colors.deepPurple,
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Varela',
                      ),
                      tabs: const [
                        Tab(
                          child: Text("Daily"),
                        ),
                        Tab(
                          child: Text("Weekly"),
                        ),
                        Tab(
                          child: Text("Monthly"),
                        )
                      ]),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: screenHieght * 0.867,
                child: TabBarView(controller: _tabController, children: [
                  WealthDailyRankList(),
                  WealthWeaklyRankList(),
                  WealthMonthlyRankList()
                ]),
              )
            ],
          ),
        )
      ],
    ));
  }
}
