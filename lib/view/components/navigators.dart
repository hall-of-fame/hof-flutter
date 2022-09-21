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
