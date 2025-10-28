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

  const StickerCard({
    Key? key,
    required this.sticker,
    required this.showAuthor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
          SharePlus.instance.share(ShareParams(files: [XFile(savePath)]));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              imageUrl: sticker.image,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            showAuthor
                ? Container(
                    margin: const EdgeInsets.fromLTRB(8, 6, 6, 0),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        sticker.avatar == null
                            ? const Icon(Icons.error)
                            : Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    imageUrl: sticker.avatar!,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                        Text(
                          sticker.author,
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                sticker.title,
                style: const TextStyle(
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
