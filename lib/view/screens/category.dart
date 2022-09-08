import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';
import 'package:hall_of_fame/provider/stickers.dart';

import '../pages/search.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Filter filter = Filter();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StickersProvider>(
      builder: (context, stickers, child) {
        if (filter.students.isEmpty) filter.updateStudents(stickers.stickers);
        final filteredStickers = stickers.stickers
            .where((sticker) => filter.students[sticker.author] ?? false)
            .toList();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Departments",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(children: [
              ...filter.departments.keys
                  .map(
                    (department) => Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FilterChip(
                        label: Text(department),
                        side: BorderSide(color: Theme.of(context).dividerColor),
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
            Text(
              "Grades",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(children: [
              ...filter.grades.keys
                  .map(
                    (grade) => Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: FilterChip(
                        label: Text(grade),
                        side: BorderSide(color: Theme.of(context).dividerColor),
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
            filter.students.isEmpty
                ? Column(
                    children: [
                      Container(height: 72),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                          maxHeight: 360,
                        ),
                        child: Image.asset("assets/category_placeholder.png"),
                      ),
                      Container(height: 12),
                      Text(
                        "No member matches your filter.",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Container(height: 72),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Students",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Wrap(children: [
                        ...filter.students.keys
                            .map(
                              (student) => Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: FilterChip(
                                  label: Text(student),
                                  side: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  selected: filter.students[student] ?? false,
                                  onSelected: (selected) => setState(
                                    () => filter.students[student] = selected,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ]),
                    ],
                  ),
            MasonryGridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
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

class CategoryHeader extends StatelessWidget implements PreferredSizeWidget {
  const CategoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Category"),
      actions: [
        Consumer<StickersProvider>(builder: (context, provider, child) {
          return IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(provider.stickers),
              ),
            ),
            tooltip: "Search",
            icon: const Icon(Icons.search),
          );
        })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
    var studentsSet = <String>{};
    for (var sticker in stickers) {
      if ((departments[sticker.department] ?? false) &&
          (grades[sticker.grade] ?? false)) {
        studentsSet.add(sticker.author);
      }
    }
    Map<String, bool> tempStudents = {};
    for (var student in studentsSet) {
      tempStudents[student] = false;
    }
    students.forEach((key, value) {
      if (tempStudents.containsKey(key)) tempStudents[key] = value;
    });
    students = tempStudents;
  }
}
