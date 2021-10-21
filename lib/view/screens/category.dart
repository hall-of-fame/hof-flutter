import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/provider.dart';
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
            StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemCount: filteredStickers.length,
              itemBuilder: (context, index) =>
                  StickerCard(filteredStickers[index]),
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            ),
          ],
        );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: sticker.image,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 6, 6, 0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: sticker.avatar,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Text(
                    sticker.author,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                sticker.title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
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
