import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Center(child: Text("Ranking"));
  }
}
