import 'package:app/screens/guest/places_list.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeFeed extends StatefulWidget {
  HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: Center(
                child: TabBar(
                  isScrollable: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black45,
                  indicator: MaterialIndicator(
                      bottomLeftRadius: 0,
                      bottomRightRadius: 0,
                      topLeftRadius: 100,
                      topRightRadius: 100),
                  tabs: const [
                    Tab(text: 'Popular'),
                    Tab(text: 'New'),
                    Tab(text: 'Top Rated'),
                  ],
                ),
              )),
          body: TabBarView(
            children: [
              PlacesList(
                arguments: const {
                  "mode": "popular",
                },
              ),
              PlacesList(
                arguments: const {
                  "mode": "new",
                },
              ),
              PlacesList(
                arguments: const {
                  "mode": "top_rated",
                },
              ),
            ],
          )),
    );
  }
}
