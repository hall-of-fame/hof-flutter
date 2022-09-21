import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/sticker_card.dart';

import '../../utils/utils.dart';

class StudentPage extends StatefulWidget {
  final StudentElement student;
  final Map<String, List<StickerElement>> stickers;

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
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: ClipOval(
                    child: widget.student.avatar == null
                        ? const Icon(Icons.error)
                        : CachedNetworkImage(
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            imageUrl: widget.student.avatar!,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error)),
                  ),
                ),
                Container(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 8),
                        Text(
                          widget.student.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(label: Text(widget.student.department)),
                        Container(width: 8),
                        Chip(label: Text("20${widget.student.grade}")),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          DefaultTabController(
            length: widget.stickers.length,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: widget.stickers.entries
                        .map((e) => Tab(text: e.key))
                        .toList(),
                    isScrollable: true,
                    labelColor: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: widget.stickers.entries
                          .map(
                            (e) => SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                                child: MasonryGridView.count(
                                  crossAxisCount: getCrossAxisCount(context),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  itemCount: widget.stickers[e.key]!.length,
                                  itemBuilder: (context, index) => StickerCard(
                                    sticker: widget.stickers[e.key]![index],
                                    showAuthor: false,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
