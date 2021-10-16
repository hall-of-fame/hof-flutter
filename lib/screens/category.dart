import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String res = "";
  // 0 loading, 1 success, 2 failed
  int status = 0;

  initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final url = Uri.parse('https://zhongtai521.wang:996/departments/');
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(url, headers: {
      "Authorization": prefs.getString("password") ?? "",
    });

    if (response.statusCode == 200) {
      setState(() {
        res = response.body;
        status = 1;
      });
    } else {
      setState(() {
        status = 2;
      });
    }
  }

  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(status.toString()),
        Text(res),
      ],
    );
  }
}
