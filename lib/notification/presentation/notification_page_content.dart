import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';
import 'package:peerpal/setup.dart';

class NotificationPageContent extends StatefulWidget {
  @override
  _NotificationPageContentState createState() =>
      _NotificationPageContentState();
}

class _NotificationPageContentState extends State<NotificationPageContent> {
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            "Damit wir dich über neue Nachrichten informieren können und an Aktivitäten und diese App erinnern können, benötigen wir deine Zustimmung. Wenn du auf den Button klickst, dann bestätige bitte mit 'Ja'"),
        ElevatedButton(
            onPressed: () async {
              NotificationService notificationService =
                  sl<NotificationService>();
              bool hasPermission =
                  (await notificationService.requestPermission());
              if (hasPermission) Navigator.pop(context);
            },
            child: Text("Benachrichtigungen erlauben"))
      ],
    );
    /*return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {

        });*/
  }
}
