import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../common/enums.dart';
import '../common/classes.dart';

class StickersProvider with ChangeNotifier {
  List<StickerElement> stickers = [];
  List<StudentElement> students = [];
  int _studentMaxStickers = 1;
  LoadingState _status = LoadingState.loading;
  String _errMsg = "";
  List<Department> _data = [];

  int get studentMaxStickers => _studentMaxStickers;
  String get errMsg => _errMsg;
  LoadingState get status => _status;

  StickersProvider() {
    init();
  }

  void init() async {
    _status = LoadingState.loading;
    notifyListeners();
    _data = (await _fetchData()).data;
    _initStickers();
    _initStudents();
  }

  void _initStickers() async {
    for (var department in _data) {
      for (var grade in department.grades) {
        for (var student in grade.students) {
          for (var category in student.categories) {
            for (var sticker in category.stickers) {
              var element = StickerElement(
                  image: "$baseURL${sticker.url}",
                  title: sticker.desc,
                  author: student.name,
                  avatar: student.avatar,
                  department: department.name,
                  grade: grade.name,
                  category: category.name);
              stickers.add(element);
            }
          }
        }
      }
    }
    notifyListeners();
  }

  void _initStudents() async {
    for (var department in _data) {
      for (var grade in department.grades) {
        for (var student in grade.students) {
          var element = StudentElement(
            name: student.name,
            avatar: student.avatar,
            department: department.name,
            grade: grade.name,
            stickersNumber: stickers
                .where((sticker) => sticker.author == student.name)
                .length,
          );
          students.add(element);
        }
      }
    }
    for (var student in students) {
      if (student.stickersNumber > studentMaxStickers) {
        _studentMaxStickers = student.stickersNumber;
      }
    }
    students.sort((a, b) => b.stickersNumber - a.stickersNumber);
    notifyListeners();
  }

  Future<Response> _fetchData() async {
    final url = Uri.parse('$baseURL/v2/departments/');
    final prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.get(url, headers: {
        "Authorization": prefs.getString("password") ?? "",
      });
    } catch (err) {
      _errMsg = err.toString();
      _status = LoadingState.failure;
      return Response();
    }

    if (response.statusCode == 200) {
      _status = LoadingState.success;
      return Response.fromJson(jsonDecode(response.body));
    } else {
      _errMsg = "HTTP STATUS CODE: ${response.statusCode}";
      _status = LoadingState.failure;
      return Response();
    }
  }
}
