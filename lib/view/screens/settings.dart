import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hall_of_fame/view/pages/about.dart';
import 'package:hall_of_fame/provider/theme.dart';

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
                    (instance) => instance.setString("password", password),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 8),
          child: Text(
            "Normal",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text("Password"),
          subtitle: const Text('API Authentication'),
          onTap: () => showDialog(
            context: context,
            builder: (context) => _passwordDialog(context),
          ),
        ),
        Consumer<ThemeProvider>(
          builder: (context, theme, _) => PopupMenuButton(
            onSelected: (ThemeMode mode) {
              theme.mode = mode;
            },
            itemBuilder: (context) => [
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
            child: ListTile(
              title: const Text("Theme"),
              subtitle: Text((() {
                switch (theme.mode) {
                  case ThemeMode.system:
                    return "Follow System";
                  case ThemeMode.light:
                    return "Light Mode";
                  case ThemeMode.dark:
                    return "Dark Mode";
                }
              })()),
              leading: const Icon(Icons.light_mode),
            ),
          ),
        ),
        Divider(
            thickness: 1,
            color: Theme.of(context).dividerColor.withOpacity(.3)),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 8),
          child: Text(
            "Others",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text("About"),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ),
            )
          },
        ),
      ],
    );
  }
}

class SettingsHeader extends StatelessWidget implements PreferredSizeWidget {
  const SettingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text("Settings"));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
