import 'package:flutter/cupertino.dart';
import 'package:reco_app/pages/main/feeds/feeds_page.dart';
import 'package:reco_app/pages/main/home_page.dart';
import 'package:reco_app/pages/main/profile_page.dart';

List<Widget> screenIndex() {
  return [
    const HomePage(),
    const FeedsPage(),
    const ProfilePage(),
  ];
}
