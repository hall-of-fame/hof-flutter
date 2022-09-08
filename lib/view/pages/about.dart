import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String version = '0.3.1';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    color: Colors.white,
                    child: Image.asset(
                      "assets/logo.png",
                      width: 120,
                    ),
                  ),
                ),
                Container(margin: const EdgeInsets.all(8.0)),
                const Text(
                  "Hall of Fame",
                  style: TextStyle(fontSize: 24),
                ),
                Container(margin: const EdgeInsets.all(2.0)),
                const Text(
                  "Version: $version",
                  style: TextStyle(color: Colors.grey),
                ),
                Container(margin: const EdgeInsets.all(8.0)),
                const Text(
                  "Made with Flutter, by Redrock",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text("Github Repository"),
            onTap: () => launchUrlString(
              "https://github.com/hall-of-fame/hof-flutter",
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
    );
  }
}
