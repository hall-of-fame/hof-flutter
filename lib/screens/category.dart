import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class CategoryScreen extends StatefulWidget {
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, String>> data = [];
  Filter filter = Filter();
  String status = "LOADING";
  int httpStatusCode = 0;

  initState() {
    super.initState();
    fetchData();
  }

  void initData(Response response) {
    response.data.forEach(
      (department) => department.grades.forEach(
        (grade) => grade.students.forEach(
          (student) => student.stickers.forEach(
            (sticker) {
              var item = {
                "image": "https://zhongtai521.wang:996${sticker.url}",
                "avatar":
                    "http://q1.qlogo.cn/g?b=qq&nk=${student.avatar}&s=640",
                "author": student.name,
                "title": sticker.desc,
                "department": department.name,
                "grade": grade.name,
              };
              data.add(item);
            },
          ),
        ),
      ),
    );
  }

  void fetchData() async {
    final url = Uri.parse('https://zhongtai521.wang:996/departments/');
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(url, headers: {
      "Authorization": prefs.getString("password") ?? "",
    });

    if (!mounted) return;
    if (response.statusCode == 200) {
      setState(() {
        initData(Response.fromJson(jsonDecode(response.body)));
        filter.updateStudents(data);
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
        return ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            Row(children: [
              ...filter.departments.keys
                  .map(
                    (department) => FilterChip(
                      label: Text(department),
                      selected: filter.departments[department] ?? false,
                      onSelected: (selected) => setState(() {
                        filter.departments[department] = selected;
                        filter.updateStudents(data);
                      }),
                    ),
                  )
                  .toList(),
            ]),
            Row(children: [
              ...filter.grades.keys
                  .map(
                    (grade) => FilterChip(
                      label: Text(grade),
                      selected: filter.grades[grade] ?? false,
                      onSelected: (selected) => setState(() {
                        filter.grades[grade] = selected;
                        filter.updateStudents(data);
                      }),
                    ),
                  )
                  .toList(),
            ]),
            Wrap(children: [
              ...filter.students.keys
                  .map(
                    (student) => FilterChip(
                        label: Text(student),
                        selected: filter.students[student] ?? false,
                        onSelected: (selected) => setState(
                            () => filter.students[student] = selected)),
                  )
                  .toList(),
            ]),
            ...data
                .where((sticker) =>
                    filter.students[sticker['author'] ?? ""] ?? false)
                .map(
                  (sticker) => Card(
                    child: InkWell(
                      splashColor: Colors.green.withAlpha(30),
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: sticker['image'] ?? "",
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        imageUrl: sticker['avatar'] ?? "",
                                      ),
                                    ),
                                  ),
                                  Text(sticker['author'] ?? ""),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Text(sticker['title'] ?? ""),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        );
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
                child: Text("Retry"),
              ),
            ],
          ),
        );
      default:
        return Text("WTF");
    }
  }
}

class Response {
  final List<Department> data;
  Response() : data = [];
  Response.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List)
            .map((department) => Department.fromJson(department))
            .toList();
}

class Department {
  final String name;
  final List<Grade> grades;

  Department(this.name, this.grades);
  Department.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        grades = (json['grades'] as List)
            .map((grade) => Grade.fromJson(grade))
            .toList();
}

class Grade {
  final String name;
  final List<Student> students;

  Grade(this.name, this.students);
  Grade.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        students = (json['students'] as List)
            .map((student) => Student.fromJson(student))
            .toList();
}

class Student {
  final String name;
  final String avatar;
  final List<Sticker> stickers;

  Student(this.name, this.avatar, this.stickers);
  Student.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar = json['avatar'],
        stickers = (json['stickers'] as List)
            .map((sticker) => Sticker.fromJson(sticker))
            .toList();
}

class Sticker {
  final String desc;
  final String url;

  Sticker(this.desc, this.url);

  Sticker.fromJson(Map<String, dynamic> json)
      : desc = json['desc'],
        url = json['url'];
}

class Filter {
  Map<String, bool> departments = {
    "前端": true,
    "后端": true,
    "Android": true,
    "iOS": true,
    "安全": true,
    "运维": true,
    "产品": true,
    "视觉": true,
  };
  Map<String, bool> grades = {
    "17": true,
    "18": true,
    "19": true,
    "20": true,
    "21": true,
  };
  Map<String, bool> students = {};
  void updateStudents(List<Map<String, String>> data) {
    var studentsSet = Set<String>();
    data.forEach((sticker) {
      if ((departments[sticker['department'] ?? ""] ?? false) &&
          (grades[sticker['grade'] ?? ""] ?? false)) {
        studentsSet.add(sticker['author'] ?? "");
      }
    });

    students = {};
    studentsSet.forEach((student) => students[student] = true);
  }
}
