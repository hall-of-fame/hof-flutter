import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hall_of_fame/common/provider.dart';
import 'package:hall_of_fame/view/pages/student.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StickersProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: provider.students
              .asMap()
              .entries
              .map(
                (entry) => ListTile(
                  dense: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentPage(
                        student: entry.value,
                        stickers: provider.stickers
                            .where(
                                (sticker) => sticker.author == entry.value.name)
                            .toList(),
                      ),
                    ),
                  ),
                  leading: SizedBox(
                    width: 42,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl: entry.value.avatar,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.value.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        entry.value.stickersNumber.toString(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  subtitle: ProgressBar(
                    entry.value.stickersNumber,
                    provider.studentMaxStickers,
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

  const ProgressBar(this.ratio, this.length, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
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
