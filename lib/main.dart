import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/ranking.dart';
import 'provider/stickers.dart';
import 'provider/theme.dart';
import 'view/root.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp(
        title: "Hall of Fame",
        themeMode: theme.mode,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
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
