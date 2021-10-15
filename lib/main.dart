import 'package:flutter/material.dart';
import './screens/category.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(primaryColor: Colors.green),
      home: CategoryScreen(),
    );
  }
}

void main() {
  runApp(App());
}
