import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

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
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "New Password",
            ),
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
                  Navigator.pop(context, "Ok");
                },
                child: Text("Ok"),
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
    // return Container(
    //   padding: EdgeInsets.all(24.0),
    //   child: Column(
    //     children: [
    //       Row(
    //         children: [
    //           Container(
    //             padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
    //             child: Icon(Icons.password),
    //           ),
    //           Text("Password"),
    //           Spacer(),
    //           IconButton(
    //             icon: Icon(Icons.edit),
    //             onPressed: () => showDialog(
    //               context: context,
    //               builder: (context) => _passwordDialog(context),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );

    return SettingsList(
      lightTheme: SettingsThemeData(titleTextColor: Colors.green),
      sections: [
        SettingsSection(
          title: Text("Basics"),
          tiles: [
            SettingsTile(
              leading: Icon(Icons.password),
              title: Text("Password"),
              value: Text('API Authentication'),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => _passwordDialog(context),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
