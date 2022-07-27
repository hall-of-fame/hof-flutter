import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/category.dart';
import 'screens/ranking.dart';
import 'screens/settings.dart';

import 'package:hall_of_fame/provider/stickers.dart';
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
      appBar: const <PreferredSizeWidget>[
        CategoryHeader(),
        RankingHeader(),
        SettingsHeader(),
      ][_pageIndex],
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
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: currentIndex == 0
              ? const Icon(Icons.category)
              : const Icon(Icons.category_outlined),
          label: "Category",
        ),
        NavigationDestination(
          icon: currentIndex == 1
              ? const Icon(Icons.leaderboard)
              : const Icon(Icons.leaderboard_outlined),
          label: "Ranking",
        ),
        NavigationDestination(
          icon: currentIndex == 2
              ? const Icon(Icons.settings)
              : const Icon(Icons.settings_outlined),
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
