import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_card/image_card.dart';
import 'package:intl/intl.dart';
import 'package:reco_app/controller/feeds_controller.dart';
import 'package:reco_app/controller/product_controller.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/product_model.dart';
import 'package:reco_app/pages/main/feeds/detail_feeds_page.dart';
import 'package:reco_app/pages/main/product/detail_product_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productControllerProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: HexColor('4DC667'),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            'Reco',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(_searchController, ref.read),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                'Featured Articles',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
            ),
            Consumer(
              builder: (context, watch, child) {
                var feeds = ref.watch(feedsControllerProvider).take(3);
                return FlutterCarousel(
                  items: feeds.map((feed) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailFeedsPage(feed),
                              ));
                        },
                        child: TransparentImageCard(
                          borderRadius: 16.0,
                          width: MediaQuery.sizeOf(context).width / 1,
                          imageProvider: NetworkImage(feed.imgUrl.toString()),
                          title: Text(
                            feed.title.toString(),
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12.0),
                          description: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              decodeFromBase64(feed.captions.toString()),
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.sizeOf(context).height / 3,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    showIndicator: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    controller: CarouselController(),
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    pauseAutoPlayOnTouch: true,
                    pauseAutoPlayOnManualNavigate: true,
                    pauseAutoPlayInFiniteScroll: false,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    disableCenter: false,
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Items',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('See All'),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: Consumer(
                builder: (context, ref, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      var productData = product[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => DetailProductPage(
                                          product: productData)));
                            },
                            child: Card(
                              surfaceTintColor: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                    child: Image.network(
                                      productData.imgUrl.toString(),
                                      width: double.infinity,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(productData.title.toString()),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      NumberFormat.simpleCurrency(
                                              locale: 'id-ID', name: 'Rp. ')
                                          .format(productData.price),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Just For You',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    childAspectRatio: 1 / 1.5,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    var productData = product[index];
                    return Card(
                      surfaceTintColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              productData.imgUrl.toString(),
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(productData.title.toString()),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              NumberFormat.simpleCurrency(
                                      locale: 'id-ID', name: 'Rp. ')
                                  .format(productData.price),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final dynamic read;

  CustomSearchDelegate(this.searchController, this.read);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var products = read(productControllerProvider);
    var searchResults = products
        .where((Product product) =>
            product.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var productData = searchResults[index];
        return buildProductCard(productData);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var products = read(productControllerProvider);
    var suggestionResults = products
        .where((Product product) =>
            product.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionResults.length,
      itemBuilder: (context, index) {
        var productData = suggestionResults[index];
        return ListTile(
          title: Text(productData.title.toString()),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => DetailProductPage(product: productData),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              product.imgUrl.toString(),
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(product.title.toString()),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              NumberFormat.simpleCurrency(locale: 'id-ID', name: 'Rp. ')
                  .format(product.price),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
