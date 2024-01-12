import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/navigation/bottom_navigation.dart';

class SplashLoggedScreen extends ConsumerStatefulWidget {
  const SplashLoggedScreen({super.key});

  @override
  ConsumerState<SplashLoggedScreen> createState() => _SplashLoggedScreenState();
}

class _SplashLoggedScreenState extends ConsumerState<SplashLoggedScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await ref.read(authControllerProvider.notifier).checkUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: MediaQuery.sizeOf(context).width / 1.5,
      duration: 3000,
      splash: Image.asset(
        'assets/img/logo_reco.png',
      ),
      nextScreen: const BottomNavigation(
        initialIndex: 0,
      ),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
