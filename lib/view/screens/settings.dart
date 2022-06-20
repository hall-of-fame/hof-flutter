import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:hall_of_fame/view/pages/about.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String password = "";

  SimpleDialog _passwordDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Text(
            "New Password",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(height: 1.0),
            onChanged: (value) => setState(() {
              password = value;
            }),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("password", password);
                  Navigator.pop(context, "OK");
                },
                child: Text("OK"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, "Cancel"),
                child: Text("Cancel"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.android,
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).backgroundColor),
      sections: [
        SettingsSection(
          title: Text("Basics"),
          tiles: [
            SettingsTile(
              leading: Icon(Icons.password),
              title: Text("Password"),
              value: Text('API Authentication'),
              onPressed: (context) => showDialog(
                context: context,
                builder: (context) => _passwordDialog(context),
              ),
            )
          ],
        ),
        SettingsSection(
          title: Text("Others"),
          tiles: [
            SettingsTile.navigation(
              leading: Icon(Icons.info),
              title: Text("About"),
              onPressed: (context) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                )
              },
            )
          ],
        )
      ],
    );
  }
}
