import 'package:flutter/material.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/feeds_model.dart';
import 'package:reco_app/pages/main/feeds/detail_feeds_page.dart';
import 'package:shimmer/shimmer.dart';

class FeedsCardWidget extends StatelessWidget {
  const FeedsCardWidget({
    super.key,
    required this.title,
    required this.author,
    required this.captions,
    required this.imgUrl,
    required this.feeds,
    required this.profileImg,
  });

  final String title;
  final String author;
  final String captions;
  final String imgUrl;
  final String profileImg;
  final Feeds feeds;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFeedsPage(feeds),
          ),
        );
      },
      child: Card(
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            Hero(
              tag: imgUrl,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Return the original Image.network widget when loading is complete
                    } else {
                      return _buildImage(); // Show shimmer effect while loading
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profileImg),
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
      ),
    );
  }

  Widget _buildImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300], // You can set a placeholder color here
        width: double.infinity,
        height: 200.0,
      ),
    );
  }
}
