import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hall_of_fame/view/pages/student.dart';
import 'package:hall_of_fame/provider/ranking.dart';
import 'package:hall_of_fame/provider/stickers.dart';

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
      builder: (context, stickersProvider, child) {
        return Consumer<RankingProvider>(builder: (
          context,
          rankingProvider,
          _,
        ) {
          final keyword = rankingProvider.searchController.text;
          final entries = keyword.isEmpty
              ? stickersProvider.students.asMap().entries
              : stickersProvider.students
                  .where((student) => student.name.contains(keyword))
                  .toList()
                  .asMap()
                  .entries;
          if (entries.isEmpty) {
            final keyword = rankingProvider.searchController.text;
            return Center(
              child: Text(
                "No one's name matches \"$keyword\"",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return ListView(
              children: entries
                  .map(
                    (entry) => ListTile(
                      dense: false,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentPage(
                            student: entry.value,
                            stickers: stickersProvider.stickers
                                .where((sticker) =>
                                    sticker.author == entry.value.name)
                                .fold(
                              {},
                              (categories, sticker) {
                                if (categories[sticker.category] == null) {
                                  categories[sticker.category] = [];
                                }
                                return {
                                  ...categories,
                                  sticker.category: [
                                    ...categories[sticker.category]!,
                                    sticker
                                  ]
                                };
                              },
                            ),
                          ),
                        ),
                      ),
                      leading: SizedBox(
                        width: 42,
                        child: ClipOval(
                          child: entry.value.avatar == null
                              ? const Icon(Icons.error)
                              : CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  imageUrl: entry.value.avatar!,
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
                            rankingProvider.numberDisplay ==
                                    NumberDisplay.stickersCount
                                ? entry.value.stickersNumber.toString()
                                : "#${entry.key + 1}",
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      subtitle: ProgressBar(
                        entry.value.stickersNumber,
                        stickersProvider.studentMaxStickers,
                      ),
                    ),
                  )
                  .toList(),
            );
          }
        });
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

class RankingHeader extends StatefulWidget implements PreferredSizeWidget {
  const RankingHeader({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<RankingHeader> createState() => _RankingHeaderState();
}

class _RankingHeaderState extends State<RankingHeader> {
  bool searchMode = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !searchMode,
      onPopInvokedWithResult: (didPop, result) async {
        if (searchMode) {
          setState(() => searchMode = false);
        }
      },
      child: Consumer<RankingProvider>(
        builder: (context, provider, _) {
          return AppBar(
            leading: searchMode
                ? IconButton(
                    onPressed: () => setState(() => searchMode = false),
                    tooltip: "Cancel",
                    icon: const Icon(Icons.arrow_back),
                  )
                : null,
            title: searchMode
                ? TextField(
                    autofocus: true,
                    controller: provider.searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search in Redrockers...",
                    ),
                  )
                : provider.searchController.text.isEmpty
                    ? const Text("Ranking")
                    : Text("Ranking of \"${provider.searchController.text}\""),
            actions: [
              IconButton(
                onPressed: () => setState(() => searchMode = true),
                tooltip: "Search",
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => provider.switchNumberDisplay(context)),
                tooltip: "Switch Number Display",
                icon: Icon(provider.numberDisplay == NumberDisplay.stickersCount
                    ? Icons.photo_library
                    : Icons.numbers),
              )
            ],
          );
        },
      ),
    );
  }
}
