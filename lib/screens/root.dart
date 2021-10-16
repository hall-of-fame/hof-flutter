import 'package:flutter/material.dart';
import '../scaffold.dart';
import "./category.dart";
import "./ranking.dart";
import "./favorite.dart";

class RootScreen extends StatefulWidget {
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  void selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  final tabList = <Widget>[
    CategoryScreen(),
    RankingScreen(),
    FavoriteScreen(),
  ];

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
      body: tabList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigator(
        selectTab: selectTab,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
