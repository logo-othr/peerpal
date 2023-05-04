import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app/domain/notification/notification_service.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

bool notificationRequestButtonClicked = false;

class NotificationPageContent extends StatefulWidget {
  @override
  _NotificationPageContentState createState() =>
      _NotificationPageContentState();
}

class _NotificationPageContentState extends State<NotificationPageContent> {
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Text(
                "Damit wir dich über neue Benachrichtigungen informieren können, benötigen wir deine Erlaubnis. "
                "Wenn du auf den Button klickst, bestätige bitte im nächsten Schritt mit 'Erlauben', damit du keine Erinnerungen verpasst.",
                style: TextStyle(
                    fontWeight: FontWeight.w600, height: 1.5, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CustomPeerPALButton(
                text: 'Benachrichtigungen erlauben',
                onPressed: () async {
                  notificationRequestButtonClicked = true;
                  NotificationService notificationService =
                      sl<NotificationService>();
                  bool hasPermission =
                      (await notificationService.requestPermission());

                  Navigator.pop(context);
                },
                color: PeerPALAppColor.primaryColor),
            /*ElevatedButton(
                onPressed: () async {
                  NotificationService notificationService =
                      sl<NotificationService>();
                  bool hasPermission =
                      (await notificationService.requestPermission());
                  if (hasPermission) Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Benachrichtigungen erlauben",
                    style: TextStyle(fontSize: 20),
                  ),
                ))*/
          ],
        ),
      ),
    );
    /*return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {

        });*/
  }
}
