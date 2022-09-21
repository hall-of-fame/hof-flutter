import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/category.dart';
import 'screens/ranking.dart';
import 'screens/settings.dart';

import 'components/navigators.dart';

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
      body: Row(
        children: [
          MediaQuery.of(context).orientation == Orientation.landscape
              ? RailNavigator(
                  switchTab: (index) => _pageController.jumpToPage(index),
                  currentIndex: _pageIndex,
                )
              : Container(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              children: const <Widget>[
                WrappedScreen(CategoryScreen()),
                WrappedScreen(RankingScreen()),
                SettingsScreen(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? BottomNavigator(
                  switchTab: (index) => _pageController.jumpToPage(index),
                  currentIndex: _pageIndex,
                )
              : null,
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
