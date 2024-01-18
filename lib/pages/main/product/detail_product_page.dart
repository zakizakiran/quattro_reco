import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/product_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:reco_app/pages/main/product/buy_product_page.dart';
import 'package:reco_app/widgets/custom/custom_button.dart';

class DetailProductPage extends ConsumerStatefulWidget {
  const DetailProductPage({super.key, required this.product});
  final Product? product;

  @override
  ConsumerState<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends ConsumerState<DetailProductPage> {
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
                  tag: widget.product!.imgUrl.toString(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image.network(
                      widget.product!.imgUrl.toString(),
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
                  widget.product!.title.toString(),
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                Text(
                  NumberFormat.simpleCurrency(locale: 'id-ID', name: 'Rp. ')
                      .format(widget.product!.price),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(decodeFromBase64(widget.product!.captions.toString())),
                const SizedBox(height: 20.0),
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 200.0,
                  ),
                  onRatingUpdate: (rating) {
                    Logger().i(rating);
                  },
                ),
                const SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      label: 'Add Rating',
                      backgroundColor: 'FFFFFF',
                      textColor: HexColor('4DC667'),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      label: 'Buy Now',
                      backgroundColor: '4DC667',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                BuyProductPage(product: widget.product),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
