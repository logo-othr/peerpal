import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/notification/presentation/bloc/notification_cubit.dart';
import 'package:peerpal/notification/presentation/notification_page_content.dart';

import '../../widgets/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  static MaterialPage<void> page() {
    return MaterialPage<void>(child: NotificationPage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar("Benachrichtigungen", hasBackButton: false),
        body: BlocProvider.value(
          value: NotificationCubit() /*..loadData()*/,
          child: NotificationPageContent(),
        ),
      ),
    );
  }
}
