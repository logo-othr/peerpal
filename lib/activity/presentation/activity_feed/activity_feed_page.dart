import 'package:flutter/material.dart';
import 'package:peerpal/activity/presentation/activity_feed/activity_feed_content.dart';

class ActivityFeedPage extends StatelessWidget {
  const ActivityFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ActivityFeedContent(),
    );
  }
}
