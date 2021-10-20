import 'package:flutter/material.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StickersProvider>(builder: (context, provider, child) {
      return ListView(
        children: provider.students
            .map((student) =>
                Card(child: Text("${student.stickersNumber}\t${student.name}")))
            .toList(),
      );
    });
  }
}
