import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hall_of_fame/common/provider.dart';

class RankingScreen extends StatefulWidget {
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StickersProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: provider.students
              .asMap()
              .entries
              .map(
                (entry) => Card(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                child: Text(
                                  (entry.key + 1).toString(),
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    imageUrl: entry.value.avatar,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(entry.value.name),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "年级: ${entry.value.grade}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "部门: ${entry.value.department}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: ProgressBar(
                                entry.value.stickersNumber,
                                provider.studentMaxStickers,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              width: 48,
                              child: Text(
                                entry.value.stickersNumber.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int ratio;
  final int length;

  ProgressBar(this.ratio, this.length);

  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          Expanded(
            flex: length - ratio,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
