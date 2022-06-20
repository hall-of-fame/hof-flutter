import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:hall_of_fame/view/pages/about.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String password = "";

  SimpleDialog _passwordDialog(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: const Text(
            "New Password",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: TextField(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: const TextStyle(height: 1.0),
            onChanged: (value) => setState(() {
              password = value;
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, "OK");
                  SharedPreferences.getInstance().then(
                    (prefs) => prefs.setString("password", password),
                  );
                },
                child: const Text("OK"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, "Cancel"),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.android,
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).backgroundColor),
      sections: [
        SettingsSection(
          title: const Text("Basics"),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.password),
              title: const Text("Password"),
              value: const Text('API Authentication'),
              onPressed: (context) => showDialog(
                context: context,
                builder: (context) => _passwordDialog(context),
              ),
            )
          ],
        ),
        SettingsSection(
          title: const Text("Others"),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onPressed: (context) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
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
