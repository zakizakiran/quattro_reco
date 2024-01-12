import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/models/user_model.dart';

class UsersController extends StateNotifier<List<Users>> {
  UsersController() : super([]);

  final db = FirebaseFirestore.instance.collection('users');

  Future<void> getUsers() async {
    var checkUser = await db
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Users> users =
        checkUser.docs.map((e) => Users.fromJson(e.data())).toList();
    state = users;
  }
}

final usersControllerProvider =
    StateNotifierProvider<UsersController, List<Users>>(
  (ref) => UsersController(),
);
