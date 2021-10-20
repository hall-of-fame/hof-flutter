import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: ListTile(
          title: Text("Password"),
          leading: Icon(Icons.password),
          trailing: Icon(Icons.edit),
          onTap: () => showDialog(
            context: context,
            builder: _passwordDialog,
          ),
        ),
      ),
    );
  }
}
