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

class StickerElement {
  String author;
  String image;
  String avatar;
  String title;
  String department;
  String grade;

  StickerElement({
    required this.author,
    required this.image,
    required this.avatar,
    required this.title,
    required this.department,
    required this.grade,
  });
}
