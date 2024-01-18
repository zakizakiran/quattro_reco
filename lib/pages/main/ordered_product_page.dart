import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/controller/order_controller.dart';

class OrderedProductPage extends ConsumerStatefulWidget {
  const OrderedProductPage({super.key});

  @override
  ConsumerState<OrderedProductPage> createState() => _OrderedProductPageState();
}

class _OrderedProductPageState extends ConsumerState<OrderedProductPage> {
  @override
  void initState() {
    super.initState();
    // Start the asynchronous operation in the next microtask
    Future.delayed(Duration.zero, () {
      getAllOrderedProduct();
    });
  }

  Future<void> getAllOrderedProduct() async {
    final currentUser = ref.read(authControllerProvider);
    try {
      await ref
          .read(orderControllerProvider.notifier)
          .getOrderedProduct(uid: currentUser.uid.toString());
    } catch (e) {
      Logger().i("Error fetching ordered products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderedProduct = ref.watch(orderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        centerTitle: true,
        title: const Text('My Orders'),
      ),
      body: orderedProduct.isNotEmpty
          ? ListView.builder(
              itemCount: orderedProduct.length,
              itemBuilder: (context, index) {
                var orderedProductData = orderedProduct[index];
                return ListTile(
                  minVerticalPadding: 16.0,
                  title: Text(
                    orderedProductData.title.toString(),
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      orderedProductData.imgUrl.toString(),
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        NumberFormat.simpleCurrency(
                                locale: 'id-ID', name: 'Rp. ')
                            .format(orderedProductData.price),
                      ),
                      Text(
                        orderedProductData.address.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text("No orders yet"),
            ),
    );
  }
}
