import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
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
  @override
  void initState() {
    super.initState();
    getAllFeeds();
  }

  List<Feeds> feedsResult = [];

  Future<void> getAllFeeds() async {
    await ref.read(feedsControllerProvider.notifier).getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    var feeds = ref.watch(feedsControllerProvider);

    return Scaffold(
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Feeds',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  var feedsData = feeds[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FeedsCardWidget(
                      author: feedsData.author.toString(),
                      title: feedsData.title.toString(),
                      captions: feedsData.captions.toString(),
                      imgUrl: feedsData.imgUrl.toString(),
                      feeds: feedsData,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
