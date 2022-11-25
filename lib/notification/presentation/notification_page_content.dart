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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            "Bitte erlauben",
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontWeight: FontWeight.bold, height: 1.5, fontSize: 35),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            "Damit wir dich über neue Benachrichtigungen informieren können, benötigen wir deine Erlaubnis. "
            "Wenn du auf den Button klickst, dann bestätige bitte im nächsten Schritt mit 'Ja', damit du keine Erinnerungen verpasst.",
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontWeight: FontWeight.w600, height: 1.5, fontSize: 22),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            onPressed: () async {
              NotificationService notificationService =
                  sl<NotificationService>();
              bool hasPermission =
                  (await notificationService.requestPermission());
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Benachrichtigungen erlauben",
                style: TextStyle(fontSize: 20),
              ),
            ))
      ],
    );
    /*return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {

        });*/
  }
}
