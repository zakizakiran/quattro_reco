import 'package:flutter/material.dart';
import 'package:reco_app/helper/text_formatter.dart';

class FeedsTileWidget extends StatelessWidget {
  const FeedsTileWidget(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.captions});
  final String imgUrl;
  final String title;
  final String captions;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 16.0,
      title: Text(
        title,
        maxLines: 1,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          imgUrl,
          height: 50.0,
          width: 50.0,
          fit: BoxFit.cover,
        ),
      ),
      subtitle: Text(
        decodeFromBase64(captions),
        maxLines: 2,
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
