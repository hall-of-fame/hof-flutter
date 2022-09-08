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
  final String? avatar;
  final List<Category> categories;

  Student(this.name, this.avatar, this.categories);
  Student.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar = json['avatar'],
        categories = (json['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
}

class Category {
  final String name;
  final List<Sticker> stickers;

  Category(this.name, this.stickers);
  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
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

class StudentElement {
  final String name;
  final String? avatar;
  final String department;
  final String grade;
  final int stickersNumber;

  StudentElement({
    required this.name,
    required this.avatar,
    required this.department,
    required this.grade,
    required this.stickersNumber,
  });
}

class StickerElement {
  final String author;
  final String image;
  final String? avatar;
  final String title;
  final String department;
  final String grade;

  StickerElement({
    required this.author,
    required this.image,
    required this.avatar,
    required this.title,
    required this.department,
    required this.grade,
  });
}
