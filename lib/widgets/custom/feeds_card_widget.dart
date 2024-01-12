import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/feeds_model.dart';
import 'package:reco_app/pages/main/feeds/detail_feeds_page.dart';

class FeedsCardWidget extends StatelessWidget {
  const FeedsCardWidget({
    super.key,
    required this.title,
    required this.author,
    required this.captions,
    required this.imgUrl,
    required this.feeds,
  });

  final String title;
  final String author;
  final String captions;
  final String imgUrl;
  final Feeds feeds;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => DetailFeedsPage(feeds),
              ));
        },
        child: Card(
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          surfaceTintColor: Colors.white,
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/people.jpg'),
                          ),
                          const SizedBox(width: 8.0),
                          Text(author)
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      title.toString(),
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      decodeFromBase64(captions.toString()),
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
