import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/models/product_model.dart';

class ProductController extends StateNotifier<List<Product>> {
  ProductController() : super([]);

  final db = FirebaseFirestore.instance.collection('products');

  Future<void> getProduct() async {
    var checkProduct = await db.orderBy('created_at', descending: true).get();

    List<Product> product =
        checkProduct.docs.map((e) => Product.fromJson(e.data())).toList();
    state = product;
  }

  Future<void> createProduct(
      {required BuildContext context, required Product product}) async {
    final doc = db.doc();

    Navigator.of(context).pop();
    Product temp = product.copyWith(
      pid: doc.id,
      createdAt: DateTime.now(),
    );
    await doc.set(temp.toJson());
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, List<Product>>(
  (ref) => ProductController(),
);
