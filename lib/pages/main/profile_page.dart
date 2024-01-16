import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/controller/feeds_controller.dart';
import 'package:reco_app/widgets/custom/feeds_tile_widget.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getAllFeeds();
  }

  Future<void> getAllFeeds() async {
    await ref.read(feedsControllerProvider.notifier).getFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final feeds = ref.watch(feedsControllerProvider);
    List userFeeds =
        feeds.where((element) => element.uid == user.uid.toString()).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('4DC667'),
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        flexibleSpace: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('Settings'),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('Points'),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: HexColor('4DC667'),
              height: MediaQuery.sizeOf(context).height / 1,
              width: MediaQuery.sizeOf(context).width / 1,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                surfaceTintColor: Colors.white,
                margin: MediaQuery.of(context).padding * 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name.toString(),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: ContainedTabBarView(
                          tabs: const [
                            Text('Posts'),
                            Text('Products'),
                          ],
                          tabBarProperties: TabBarProperties(
                            indicatorColor: HexColor('4DC667'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                              vertical: 8.0,
                            ),
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.grey[400],
                          ),
                          views: [
                            ListView.builder(
                              itemCount: userFeeds.length,
                              itemBuilder: (context, index) {
                                var feedsData = userFeeds[index];
                                return FeedsTileWidget(
                                  imgUrl: feedsData.imgUrl.toString(),
                                  title: feedsData.title.toString(),
                                  captions: feedsData.captions.toString(),
                                );
                              },
                            ),
                            Container(color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top / 0.5),
              child: CircleAvatar(
                radius: MediaQuery.sizeOf(context).width / 5,
                backgroundImage: const AssetImage(
                  'assets/img/people.jpg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
