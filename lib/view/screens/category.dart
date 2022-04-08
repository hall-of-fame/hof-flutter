import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';

class CategoryScreen extends StatefulWidget {
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Filter filter = Filter();

  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StickersProvider>(
      builder: (context, stickers, child) {
        if (filter.students.length == 0)
          filter.updateStudents(stickers.stickers);
        final filteredStickers = stickers.stickers
            .where((sticker) => filter.students[sticker.author] ?? false)
            .toList();
        return ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text("Departments"),
            Wrap(children: [
              ...filter.departments.keys
                  .map(
                    (department) => Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FilterChip(
                        selectedColor: Colors.green,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        label: Text(department),
                        selected: filter.departments[department] ?? false,
                        onSelected: (selected) => setState(() {
                          filter.departments[department] = selected;
                          filter.updateStudents(stickers.stickers);
                        }),
                      ),
                    ),
                  )
                  .toList(),
            ]),
            Text("Grades"),
            Wrap(children: [
              ...filter.grades.keys
                  .map(
                    (grade) => Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FilterChip(
                        selectedColor: Colors.green,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        label: Text(grade),
                        selected: filter.grades[grade] ?? false,
                        onSelected: (selected) => setState(() {
                          filter.grades[grade] = selected;
                          filter.updateStudents(stickers.stickers);
                        }),
                      ),
                    ),
                  )
                  .toList(),
            ]),
            Text("Students"),
            filter.students.length == 0
                ? Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(
                      "None is available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Wrap(children: [
                    ...filter.students.keys
                        .map(
                          (student) => Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: FilterChip(
                              selectedColor: Colors.green,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              label: Text(student),
                              selected: filter.students[student] ?? false,
                              onSelected: (selected) => setState(
                                () => filter.students[student] = selected,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ]),
            MasonryGridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemCount: filteredStickers.length,
              itemBuilder: (context, index) => StickerCard(
                sticker: filteredStickers[index],
                showAuthor:
                    filter.students.values.where((student) => student).length ==
                            1
                        ? false
                        : true,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Filter {
  Map<String, bool> departments = {
    "前端": false,
    "后端": false,
    "Android": false,
    "iOS": false,
    "安全": false,
    "运维": false,
    "产品": false,
    "视觉": false,
  };
  Map<String, bool> grades = {
    "17": false,
    "18": false,
    "19": false,
    "20": false,
    "21": false,
  };
  Map<String, bool> students = {};
  void updateStudents(List<StickerElement> stickers) {
    var studentsSet = Set<String>();
    stickers.forEach((sticker) {
      if ((departments[sticker.department] ?? false) &&
          (grades[sticker.grade] ?? false)) {
        studentsSet.add(sticker.author);
      }
    });
    print(studentsSet);
    Map<String, bool> tempStudents = {};
    studentsSet.forEach((String student) => tempStudents[student] = false);
    students.forEach((key, value) {
      if (tempStudents.containsKey(key)) tempStudents[key] = value;
    });
    students = tempStudents;
  }
}
