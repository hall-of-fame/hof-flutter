import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';

class SearchPage extends StatefulWidget {
  final List<StickerElement> stickers;
  SearchPage({required this.stickers});
  _SearchPageState createState() => _SearchPageState(stickers: this.stickers);
}

class _SearchPageState extends State<SearchPage> {
  final List<StickerElement> stickers;
  List<StickerElement> filteredStickers = [];
  final TextEditingController _controller = TextEditingController();

  _SearchPageState({required this.stickers});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(border: InputBorder.none),
          controller: _controller,
          onChanged: (value) {
            if (value == "") {
              setState(() => filteredStickers = []);
              return;
            }
            List<StickerElement> newFilteredStickers = [];
            stickers.forEach((sticker) {
              if (value
                  .split(" ")
                  .every((keyword) => sticker.title.contains(keyword))) {
                newFilteredStickers.add(sticker);
              }
            });
            setState(() => filteredStickers = newFilteredStickers);
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              this._controller.text = "";
            },
          ),
        ],
      ),
      body: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemCount: filteredStickers.length,
        itemBuilder: (context, index) => StickerCard(
          sticker: filteredStickers[index],
          showAuthor: true,
        ),
      ),
    );
  }
}
