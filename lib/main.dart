import 'package:flutter/material.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(primaryColor: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: Text("Hall of Fame")),
        body: Center(child: Text("Hello World")),
      ),
    );
  }
}

void main() {
  runApp(App());
}
