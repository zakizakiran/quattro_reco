// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/models/user_model.dart';
import 'package:reco_app/navigation/bottom_navigation.dart';
import 'package:reco_app/pages/auth/sign_in_page.dart';
import 'package:reco_app/pages/auth/success_sent_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends StateNotifier<Users> {
  AuthController() : super(Users());
  // ignore: prefer_typing_uninitialized_variables
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> emailPassSignIn(
      BuildContext context, String email, String password) async {
    try {
      var credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        var checkUsers = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        if (!checkUsers.exists) {
          return;
        } else {
          final users = Users.fromJson(checkUsers.data()!);
          state = users;
        }
      }
      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const BottomNavigation(
            initialIndex: 0,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final checkUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .get();

      if (!checkUsers.exists) {
        // If the user doesn't exist, create a new document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'uid': authResult.user!.uid,
          'name': authResult.user!.displayName,
          'email': authResult.user!.email,
        });
      }

      final users = Users(
        uid: authResult.user!.uid,
        name: authResult.user!.displayName ?? '',
        email: authResult.user!.email ?? '',
      );

      state = users;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const BottomNavigation(
            initialIndex: 0,
          ),
        ),
      );
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
  }

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var checkUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      if (!checkUsers.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'uid': credential.user!.uid,
          'name': name,
          'email': email,
        });
        final users = Users(
          uid: credential.user!.uid,
          name: name,
          email: email,
        );
        state = users;
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const BottomNavigation(
            initialIndex: 0,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  Future<void> getUsers({required String uid}) async {
    var checkUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final users = Users.fromJson(checkUsers.data()!);
    state = users;
  }

  Future<String> checkUsers(BuildContext context) async {
    final result = FirebaseAuth.instance.currentUser;
    Logger().i(result);
    if (result != null) {
      await getUsers(uid: result.uid);
      return result.uid;
    }
    return '';
  }

  Future<void> forgetPass(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => const SuccessSentPage()));
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      Logger().i(error);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => const SignInPage()));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}

Future<void> clearLocalData() async {
  // Menghapus data dari shared preferences atau penyimpanan lokal lainnya
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

final authControllerProvider = StateNotifierProvider<AuthController, Users>(
  (ref) => AuthController(),
);
