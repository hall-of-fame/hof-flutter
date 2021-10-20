import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    return Center(child: Text("Favorite"));
  }
}
