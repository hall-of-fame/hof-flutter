import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String version = '0.2.0';

class AboutScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 120,
                  ),
                ),
                Container(margin: EdgeInsets.all(8.0)),
                Text(
                  "Hall of Fame",
                  style: TextStyle(fontSize: 24),
                ),
                Container(margin: EdgeInsets.all(2.0)),
                Text(
                  "Version: $version",
                  style: TextStyle(color: Colors.grey),
                ),
                Container(margin: EdgeInsets.all(8.0)),
                Text(
                  "Made with Flutter, by Redrock",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text("Github Repository"),
              onTap: () => launchUrlString(
                "https://github.com/hall-of-fame/hof-flutter-md",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
