import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';

class StudentPage extends StatefulWidget {
  final StudentElement student;
  final List<StickerElement> stickers;

  const StudentPage({
    Key? key,
    required this.student,
    required this.stickers,
  }) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.student.name)),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageUrl: widget.student.avatar,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(widget.student.name),
                  ],
                ),
                Container(width: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "年级: 20${widget.student.grade}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "部门: ${widget.student.department}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MasonryGridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: widget.stickers.length,
            itemBuilder: (context, index) => StickerCard(
              sticker: widget.stickers[index],
              showAuthor: false,
            ),
          ),
        ],
      ),
    );
  }
}
