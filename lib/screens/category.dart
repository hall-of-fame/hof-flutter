import 'package:flutter/material.dart';
import '../scaffold.dart';

class CategoryScreen extends StatelessWidget {
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
      body: Center(child: Text("Hello World")),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
