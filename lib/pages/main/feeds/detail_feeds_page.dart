import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/feeds_model.dart';

class DetailFeedsPage extends ConsumerStatefulWidget {
  final Feeds? feeds;
  const DetailFeedsPage(this.feeds, {super.key});

  @override
  ConsumerState<DetailFeedsPage> createState() => _DetailFeedsPageState();
}

class _DetailFeedsPageState extends ConsumerState<DetailFeedsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              surfaceTintColor: HexColor('4DC667'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: HexColor('4DC667'),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text(''),
                ),
              ),
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.feeds!.imgUrl.toString(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image.network(
                      widget.feeds!.imgUrl.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.feeds!.title.toString(),
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                Text(
                  DateFormat.yMMMMd().format(widget.feeds!.createdAt!),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(decodeFromBase64(widget.feeds!.captions.toString()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
