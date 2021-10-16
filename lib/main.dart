import 'package:flutter/material.dart';
import './screens/category.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ),
      ),
      home: CategoryScreen(),
    );
  }
}

void main() {
  runApp(App());
}
