import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/views/wealth_main_rank_list_view.dart';

import 'charm_main_rank_list_view.dart';

class MainRankListView extends StatefulWidget {
  const MainRankListView({super.key});
  static const id = "MainRankListView";
  @override
  State<MainRankListView> createState() => _MainRankListViewState();
}

class _MainRankListViewState extends State<MainRankListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHieght = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          child: TabBarView(controller: _tabController, children: const [
            WealthMainRankListView(),
            CharmMainRankListView()
          ]),
        ),
        Positioned(
            top: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 22),
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicator:
                            const BoxDecoration(color: Colors.transparent),
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Varela',
                        ),
                        labelColor: Colors.white,
                        labelStyle: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Varela',
                        ),
                        tabs: const [
                          Tab(
                            child: Text(
                              "Wealth",
                            ),
                          ),
                          Tab(
                            child: Text("Charm"),
                          )
                        ]),
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}
