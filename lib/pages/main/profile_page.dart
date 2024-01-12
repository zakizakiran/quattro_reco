import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reco_app/controller/auth_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sorry.. Profile Page Under Development'),
              const SizedBox(height: 32.0),
              Text('Current User : ${user.name}'),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  ref.read(authControllerProvider.notifier).signOut(context);
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
