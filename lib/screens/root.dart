import 'package:flutter/material.dart';
import '../scaffold.dart';
import "./category.dart";
import "./ranking.dart";
import "./favorite.dart";

class RootScreen extends StatefulWidget {
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hall of Fame"),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: "Search",
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: PageView(
        children: <Widget>[
          CategoryScreen(),
          RankingScreen(),
          FavoriteScreen(),
        ],
        controller: _pageController,
        onPageChanged: (index) => setState(() => _pageIndex = index),
      ),
      bottomNavigationBar: BottomNavigator(
        selectTab: (index) => _pageController.jumpToPage(index),
        selectedIndex: _pageIndex,
      ),
    );
  }
}
