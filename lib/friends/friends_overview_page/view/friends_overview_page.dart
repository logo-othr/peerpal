import 'package:flutter/material.dart';
import 'package:peerpal/friends/friends_overview_page/view/friends_overview_content.dart';

class FriendsOverviewPage extends StatelessWidget {
  const FriendsOverviewPage({Key? key}) : super(key: key);

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: FriendsOverviewPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: FriendsOverviewContent(),
    );
  }
}
