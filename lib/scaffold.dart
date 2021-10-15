import 'package:flutter/material.dart';

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
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;
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
      onTap: (int index) => setState(() {
        _selectedIndex = index;
      }),
      currentIndex: _selectedIndex,
    );
  }
}
