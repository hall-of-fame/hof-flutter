import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hall_of_fame/common/classes.dart';

class StickerCard extends StatelessWidget {
  final StickerElement sticker;
  final bool showAuthor;

  StickerCard({required this.sticker, required this.showAuthor});

  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.green.withAlpha(30),
        onTap: () async {
          final ext = RegExp(r"^.*\.(.*)$")
              .allMatches(sticker.image)
              .toList()[0]
              .group(1);
          final String filename =
              "${sticker.department}-${sticker.grade}-${sticker.author}-${sticker.title}.$ext";
          final String dir = (await getApplicationDocumentsDirectory()).path;
          final String savePath = "$dir/$filename";
          final file = File(savePath);
          if (!(await file.exists())) {
            String url = sticker.image;
            final response = await get(Uri.parse(url));
            await file.writeAsBytes(response.bodyBytes);
          }
          Share.shareFiles([savePath]);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl: sticker.image,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            showAuthor
                ? Container(
                    margin: EdgeInsets.fromLTRB(8, 6, 6, 0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: sticker.avatar,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Text(
                          sticker.author,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                sticker.title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
