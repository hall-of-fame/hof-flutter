import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/home.dart';
import 'common/provider.dart';

const Color m3BaseColor = Color(0xff6750a4);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp(
        title: "Hall of Fame",
        themeMode: theme.mode,
        theme: ThemeData(
          colorSchemeSeed: m3BaseColor,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: m3BaseColor,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: ChangeNotifierProvider(
          create: (context) => StickersProvider(),
          child: ChangeNotifierProvider<RankingProvider>(
            create: (_) => RankingProvider(),
            child: const HomePage(),
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initStatusBar();
  final mode = await getInitialThemeMode();

  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (_) => ThemeProvider(mode),
    child: const App(),
  ));
}

void initStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

Future<ThemeMode> getInitialThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final theme = prefs.getString('theme');
  if (theme == "system") {
    return ThemeMode.system;
  } else if (theme == "light") {
    return ThemeMode.light;
  } else if (theme == "dark") {
    return ThemeMode.dark;
  } else {
    prefs.setString('theme', 'system');
    return ThemeMode.system;
  }
}
