import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/controller/order_controller.dart';
import 'package:reco_app/models/order_model.dart';
import 'package:reco_app/models/product_model.dart';
import 'package:reco_app/pages/main/ordered_product_page.dart';
import 'package:reco_app/widgets/custom/custom_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class BuyProductPage extends ConsumerStatefulWidget {
  const BuyProductPage({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<BuyProductPage> createState() => BuyProductPageState();
}

class BuyProductPageState extends ConsumerState<BuyProductPage> {
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final List<String> items = [
    'Cash on Delivery',
    'Bank Transfer',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const Text('Total Price : '),
                Text(
                  NumberFormat.simpleCurrency(locale: 'id-ID', name: 'Rp. ')
                      .format(widget.product!.price),
                  maxLines: 2,
                  style: const TextStyle(),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      surfaceTintColor: Colors.white,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: Image.network(
                              widget.product!.imgUrl.toString(),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200.0,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Return the original Image.network widget when loading is complete
                                } else {
                                  return _buildImage(); // Show shimmer effect while loading
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product!.title.toString(),
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: address,
                      cursorColor: HexColor('4DC667'),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: HexColor('4DC667')),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: phoneNumber,
                      maxLines: null,
                      cursorColor: HexColor('4DC667'),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: HexColor('4DC667'),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 32.0),
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    onPressed: () async {
                      try {
                        OrderProduct orderProduct = OrderProduct(
                          address: address.text,
                          phone: phoneNumber.text,
                          uid: currentUser.uid,
                          createdAt: DateTime.now(),
                          price: int.tryParse(widget.product!.price.toString()),
                          title: widget.product!.title,
                          imgUrl: widget.product!.imgUrl,
                        );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .createOrder(context: context, order: orderProduct);
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const OrderedProductPage(),
                          ),
                        );
                      } on FirebaseException catch (e) {
                        Logger().i(e);
                      }
                    },
                    label: 'Buy',
                    backgroundColor: '4DC667',
                    textColor: Colors.white,
                  ),
                ],
              )
            ],
          ),
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
