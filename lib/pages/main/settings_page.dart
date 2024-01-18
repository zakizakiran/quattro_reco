import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/pages/main/edit_profile_page.dart';

import '../../widgets/custom/settings_list_tile_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('4DC667'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              ref.read(authControllerProvider.notifier).signOut(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Text(
              'Personal',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsListTileWidget(
            title: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
          SettingsListTileWidget(
            title: 'Shipping Address',
            onTap: () {},
          ),
          SettingsListTileWidget(
            title: 'Payment Methods',
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SettingsListTileWidget(
            title: 'Language',
            onTap: () {},
          ),
          const SizedBox(height: 4.0),
          SettingsListTileWidget(
            title: 'About Reco',
            onTap: () {},
          ),
          const SizedBox(height: 12.0),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
            child: const Text(
              'Delete My Account',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
