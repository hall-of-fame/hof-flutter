import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/category.dart';
import 'screens/ranking.dart';
import 'screens/favorite.dart';

import 'pages/settings.dart';
import 'pages/about.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:hall_of_fame/common/enums.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          WrappedScreen(CategoryScreen()),
          WrappedScreen(RankingScreen()),
          FavoriteScreen(),
        ],
        controller: _pageController,
        onPageChanged: (index) => setState(() => _pageIndex = index),
      ),
      bottomNavigationBar: BottomNavigator(
        switchTab: (index) => _pageController.jumpToPage(index),
        currentIndex: _pageIndex,
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              "Hall of Fame",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigator extends StatelessWidget {
  final void Function(int) switchTab;
  final int currentIndex;

  BottomNavigator({required this.switchTab, required this.currentIndex});

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: "Category",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: "Ranking",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Favorite",
        ),
      ],
      onTap: (int index) => switchTab(index),
      currentIndex: currentIndex,
    );
  }
}

class WrappedScreen extends StatelessWidget {
  final Widget innerScreen;

  WrappedScreen(this.innerScreen);

  Widget build(BuildContext context) {
    return Consumer<StickersProvider>(builder: (context, provider, child) {
      print(provider.status);
      switch (provider.status) {
        case LoadingState.loading:
          return Center(child: CircularProgressIndicator());
        case LoadingState.success:
          return this.innerScreen;
        case LoadingState.failure:
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("FAILED"),
                Container(
                  padding: EdgeInsets.fromLTRB(32, 8, 32, 20),
                  child: Text(provider.errMsg),
                ),
                OutlinedButton(
                  onPressed: provider.init,
                  child: Text("Retry"),
                ),
              ],
            ),
          );
      }
    });
  }
}
