import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:hall_of_fame/common/enums.dart';
import 'package:hall_of_fame/common/classes.dart';

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
        switch (stickers.status) {
          case LoadingState.loading:
            return Center(child: CircularProgressIndicator());
          case LoadingState.success:
            if (filter.students.length == 0)
              filter.updateStudents(stickers.stickers);
            return ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
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
                ...stickers.stickers
                    .where(
                        (sticker) => filter.students[sticker.author] ?? false)
                    .map((sticker) => StickerCard(sticker))
                    .toList()
              ],
            );
          case LoadingState.failure:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("FAILED"),
                  Container(
                    padding: EdgeInsets.fromLTRB(32, 8, 32, 20),
                    child: Text(stickers.errMsg),
                  ),
                  OutlinedButton(
                    onPressed: stickers.initStickers,
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class StickerCard extends StatelessWidget {
  final StickerElement sticker;

  StickerCard(this.sticker);

  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.green.withAlpha(30),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: sticker.image,
                errorWidget: (context, url, error) => Icon(Icons.error),
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
                          imageUrl: sticker.avatar,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(sticker.author),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(sticker.title),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

    students = {};
    studentsSet.forEach((student) => students[student] = true);
  }
}
