import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/root.dart';
import './common/provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ),
      ),
      home: ChangeNotifierProvider(
        create: (context) => StickersProvider(),
        child: RootScreen(),
      ),
    );
  }
}

void main() {
  runApp(App());
}
