import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';

class StudentPage extends StatefulWidget {
  final StudentElement student;
  final List<StickerElement> stickers;

  StudentPage({required this.student, required this.stickers});

  _StudentPageState createState() =>
      _StudentPageState(student: this.student, stickers: this.stickers);
}

class _StudentPageState extends State<StudentPage> {
  final StudentElement student;
  final List<StickerElement> stickers;

  _StudentPageState({required this.student, required this.stickers});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: Card(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          imageUrl: student.avatar,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(student.name),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "年级: ${student.grade}",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "部门: ${student.department}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          MasonryGridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: stickers.length,
            itemBuilder: (context, index) => StickerCard(
              sticker: stickers[index],
              showAuthor: false,
            ),
          ),
        ],
      ),
    );
  }
}
