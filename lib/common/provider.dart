import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './enums.dart';
import './classes.dart';

class StickersProvider with ChangeNotifier {
  List<StickerElement> stickers = [];
  List<StudentElement> students = [];
  int studentMaxStickers = 1;
  LoadingState status = LoadingState.loading;
  String errMsg = "";
  List<Department> _data = [];

  StickersProvider() {
    init();
  }

  void init() async {
    status = LoadingState.loading;
    _data = (await _fetchData()).data;
    initStickers();
    initStudents();
  }

  void initStickers() async {
    _data.forEach(
      (department) => department.grades.forEach(
        (grade) => grade.students.forEach(
          (student) => student.stickers.forEach(
            (sticker) {
              var element = StickerElement(
                image: "https://zhongtai521.wang:996${sticker.url}",
                avatar: "http://q1.qlogo.cn/g?b=qq&nk=${student.avatar}&s=640",
                author: student.name,
                title: sticker.desc,
                department: department.name,
                grade: grade.name,
              );
              stickers.add(element);
            },
          ),
        ),
      ),
    );
    notifyListeners();
  }

  void initStudents() async {
    _data.forEach(
      (department) => department.grades.forEach(
        (grade) => grade.students.forEach(
          (student) {
            var element = StudentElement(
              name: student.name,
              avatar: "http://q1.qlogo.cn/g?b=qq&nk=${student.avatar}&s=640",
              department: department.name,
              grade: grade.name,
              stickersNumber: stickers
                  .where((sticker) => sticker.author == student.name)
                  .length,
            );
            students.add(element);
          },
        ),
      ),
    );
    students.forEach((student) {
      if (student.stickersNumber > studentMaxStickers) {
        studentMaxStickers = student.stickersNumber;
      }
    });
    students.sort((a, b) => b.stickersNumber - a.stickersNumber);
    notifyListeners();
  }

  Future<Response> _fetchData() async {
    final url = Uri.parse('https://zhongtai521.wang:996/departments/');
    final prefs = await SharedPreferences.getInstance();
    var response;
    try {
      response = await http.get(url, headers: {
        "Authorization": prefs.getString("password") ?? "",
      });
    } catch (err) {
      errMsg = err.toString();
      status = LoadingState.failure;
      return Response();
    }

    if (response.statusCode == 200) {
      status = LoadingState.success;
      return Response.fromJson(jsonDecode(response.body));
    } else {
      errMsg = "HTTP STATUS CODE: ${response.statusCode}";
      status = LoadingState.failure;
      return Response();
    }
  }
}
