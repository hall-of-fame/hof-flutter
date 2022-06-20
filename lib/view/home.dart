import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/category.dart';
import 'screens/ranking.dart';

import 'screens/settings.dart';
import 'pages/search.dart';

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
          Consumer<StickersProvider>(builder: (context, provider, child) {
            return IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    stickers: provider.stickers,
                  ),
                ),
              ),
              tooltip: "Search",
              icon: Icon(Icons.search),
            );
          })
        ],
      ),
      body: PageView(
        children: <Widget>[
          WrappedScreen(CategoryScreen()),
          WrappedScreen(RankingScreen()),
          SettingsScreen(),
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

class BottomNavigator extends StatelessWidget {
  final void Function(int) switchTab;
  final int currentIndex;

  BottomNavigator({required this.switchTab, required this.currentIndex});

  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.category),
          label: "Category",
        ),
        NavigationDestination(
          icon: Icon(Icons.leaderboard),
          label: "Ranking",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      onDestinationSelected: (int index) => switchTab(index),
      selectedIndex: currentIndex,
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
