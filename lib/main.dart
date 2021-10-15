import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
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

class Navigation extends StatefulWidget {
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
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

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(primaryColor: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: Text("Hall of Fame")),
        drawer: MyDrawer(),
        body: Center(child: Text("Hello World")),
        bottomNavigationBar: Navigation(),
      ),
    );
  }
}

void main() {
  runApp(App());
}
