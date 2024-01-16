import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:reco_app/navigation/bottom_navigation.dart';
import 'package:reco_app/pages/auth/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authController = AuthController();
  await authController.checkUsers();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: FirebaseAuth.instance.currentUser == null
          ? const SignInPage()
          : const BottomNavigation(initialIndex: 0),
    );
  }
}
