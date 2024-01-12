import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/models/feeds_model.dart';

class FeedsController extends StateNotifier<List<Feeds>> {
  FeedsController() : super([]);

  final db = FirebaseFirestore.instance.collection('feeds');

  Future<void> getFeeds() async {
    var checkFeeds = await db.get();

    List<Feeds> feeds =
        checkFeeds.docs.map((e) => Feeds.fromJson(e.data())).toList();
    state = feeds;
  }

  Future<void> createFeeds(
      {required BuildContext context, required Feeds feeds}) async {
    final doc = db.doc();

    Navigator.of(context).pop();
    Feeds temp = feeds.copyWith(
      fid: doc.id,
      createdAt: DateTime.now(),
    );
    await doc.set(temp.toJson());
  }
}

final feedsControllerProvider =
    StateNotifierProvider<FeedsController, List<Feeds>>(
  (ref) => FeedsController(),
);
