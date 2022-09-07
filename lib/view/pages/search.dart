import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:hall_of_fame/common/classes.dart';
import 'package:hall_of_fame/view/components/StickerCard.dart';

class SearchPage extends StatefulWidget {
  final List<StickerElement> stickers;

  const SearchPage(this.stickers, {Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<StickerElement> filteredStickers = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search in quotations...",
          ),
          controller: _controller,
          onChanged: (value) {
            if (value == "") {
              setState(() => filteredStickers = []);
              return;
            }
            List<StickerElement> newFilteredStickers = [];
            for (var sticker in widget.stickers) {
              if (value.split(" ").every(
                    (keyword) => sticker.title
                        .toLowerCase()
                        .contains(keyword.toLowerCase()),
                  )) {
                newFilteredStickers.add(sticker);
              }
            }
            setState(() => filteredStickers = newFilteredStickers);
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              _controller.text = "";
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
