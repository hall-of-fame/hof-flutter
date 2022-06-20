import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/category.dart';
import 'screens/ranking.dart';

import 'screens/settings.dart';
import 'pages/search.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:hall_of_fame/common/enums.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hall of Fame"),
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
              icon: const Icon(Icons.search),
            );
          })
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        children: const <Widget>[
          WrappedScreen(CategoryScreen()),
          WrappedScreen(RankingScreen()),
          SettingsScreen(),
        ],
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

  const BottomNavigator(
      {Key? key, required this.switchTab, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const <NavigationDestination>[
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

  const WrappedScreen(this.innerScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StickersProvider>(builder: (context, provider, child) {
      switch (provider.status) {
        case LoadingState.loading:
          return const Center(child: CircularProgressIndicator());
        case LoadingState.success:
          return innerScreen;
        case LoadingState.failure:
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("FAILED"),
                Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
                  child: Text(provider.errMsg),
                ),
                OutlinedButton(
                  onPressed: provider.init,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
      }
    });
  }
}
