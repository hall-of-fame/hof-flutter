import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'view/home.dart';
import 'common/provider.dart';

const Color m3BaseColor = Color(0xff6750a4);

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hall of Fame",
      theme: ThemeData(
        colorSchemeSeed: m3BaseColor,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => StickersProvider(),
        child: HomePage(),
      ),
    );
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(App());
}
