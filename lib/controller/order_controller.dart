import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/models/order_model.dart';

class OrderController extends StateNotifier<List<OrderProduct>> {
  OrderController() : super([]);

  final db = FirebaseFirestore.instance.collection('orders');

  Future<void> getOrderedProduct({required String uid}) async {
    var checkOrderedProduct = await db.where('uid', isEqualTo: uid).get();

    List<OrderProduct> orderedProduct = checkOrderedProduct.docs
        .map((e) => OrderProduct.fromJson(e.data()))
        .toList();
    state = orderedProduct;
  }

  Future<void> createOrder(
      {required BuildContext context, required OrderProduct order}) async {
    final doc = db.doc();

    Navigator.of(context).pop();
    OrderProduct temp = order.copyWith(
      oid: doc.id,
      createdAt: DateTime.now(),
    );
    await doc.set(temp.toJson());
  }
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, List<OrderProduct>>(
  (ref) => OrderController(),
);
