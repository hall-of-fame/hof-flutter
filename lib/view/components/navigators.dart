import 'package:flutter/material.dart';

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
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: "Category",
        ),
        NavigationDestination(
          icon: Icon(Icons.leaderboard_outlined),
          selectedIcon: Icon(Icons.leaderboard),
          label: "Ranking",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      onDestinationSelected: (int index) => switchTab(index),
      selectedIndex: currentIndex,
    );
  }
}

class RailNavigator extends StatelessWidget {
  final void Function(int) switchTab;
  final int currentIndex;

  const RailNavigator(
      {Key? key, required this.switchTab, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      groupAlignment: -1.0,
      onDestinationSelected: (int index) {
        switchTab(index);
      },
      labelType: NavigationRailLabelType.all,
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text('Category'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.leaderboard_outlined),
          selectedIcon: Icon(Icons.leaderboard),
          label: Text('Ranking'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
