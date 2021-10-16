import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String res = "";
  String status = "LOADING";
  int httpStatusCode = 0;

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
        httpStatusCode = response.statusCode;
        status = "SUCCESS";
      });
    } else {
      setState(() {
        httpStatusCode = response.statusCode;
        status = "FAILED";
      });
    }
  }

  Widget build(BuildContext context) {
    switch (status) {
      case "LOADING":
        return Center(child: CircularProgressIndicator());
      case "SUCCESS":
        return ListView(children: [Text(res)]);
      case "FAILED":
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("FAILED"),
              Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                child: Text("HTTP STATUS CODE: $httpStatusCode"),
              ),
              OutlinedButton(
                  onPressed: () {
                    setState(() => status = "LOADING");
                    fetchData();
                  },
                  child: Text("Retry")),
            ],
          ),
        );
      default:
        return Text("WTF");
    }
  }
}
