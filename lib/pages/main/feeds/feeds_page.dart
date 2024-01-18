import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:reco_app/controller/feeds_controller.dart';
import 'package:reco_app/models/feeds_model.dart';
import 'package:reco_app/pages/main/feeds/create_feeds_page.dart';

import '../../../widgets/custom/feeds_card_widget.dart';

class FeedsPage extends ConsumerStatefulWidget {
  const FeedsPage({super.key});

  @override
  ConsumerState<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends ConsumerState<FeedsPage> {
  late Future<void> _futureFeeds;
  TextEditingController searchController = TextEditingController();
  bool _searchVisible = false;
  List<Feeds> feedsResult = [];

  @override
  void initState() {
    super.initState();
    _futureFeeds = getAllFeeds();
  }

  Future<void> getAllFeeds() async {
    await ref.read(feedsControllerProvider.notifier).getFeeds();
    feedsResult = List.from(ref.read(feedsControllerProvider));
  }

  void _toggleSearch() {
    setState(() {
      _searchVisible = !_searchVisible;
      if (!_searchVisible) {
        feedsResult = List.from(ref.read(feedsControllerProvider));
        searchController.text = '';
      }
    });
  }

  void updateList(String value) {
    try {
      if (value != '') {
        feedsResult = ref
            .read(feedsControllerProvider)
            .where((element) =>
                element.title!.toLowerCase().contains(value.toLowerCase()) ||
                element.author!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        feedsResult = List.from(ref.read(feedsControllerProvider));
      }
      setState(() {});
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: _searchVisible
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  updateList(value);
                },
              )
            : const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Feeds',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_searchVisible ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateFeedsPage(),
              ));
        },
        label: const Text('New Feeds'),
        style: IconButton.styleFrom(
          backgroundColor: HexColor('4DC667'),
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder(
              future: _futureFeeds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                      'assets/img/load.json',
                      width: MediaQuery.sizeOf(context).width / 2,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading feeds'),
                  );
                } else {
                  return feedsResult.isNotEmpty
                      ? ListView.builder(
                          itemCount: feedsResult.length,
                          itemBuilder: (context, index) {
                            var feedsData = feedsResult[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              child: FeedsCardWidget(
                                author: feedsData.author.toString(),
                                title: feedsData.title.toString(),
                                captions: feedsData.captions.toString(),
                                imgUrl: feedsData.imgUrl.toString(),
                                profileImg: feedsData.authorImg.toString(),
                                feeds: feedsData,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("No matching feeds found"),
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
