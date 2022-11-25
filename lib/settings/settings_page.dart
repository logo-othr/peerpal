import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/discover_feed/presentation/bloc/discover_feed_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/settings/imprint_page.dart';
import 'package:peerpal/settings/privacy_policy_page.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_dialog.dart';
import 'package:peerpal/widgets/custom_table_header.dart';
import 'package:peerpal/widgets/custom_table_row.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Widget> customTableRows = [];
  final List<Widget> customTableRows2 = [
    CustomTableRow(text: "Datenschutz"),
    CustomTableRow(text: "Impressum"),
    CustomTableRow(text: "Lizenzen")
  ];

  /*Future<String> getPlattformData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return "[App-Name: ${appName}, Package-Name: ${packageName}, Version: ${version}, Build-Number: ${buildNumber}] ";
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Einstellungen", hasBackButton: false),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      height: 120,
                      width: 120,
                      child:
                          Image(image: AssetImage('assets/peerpal_logo.png')))),
              SizedBox(height: 10),
              Divider(thickness: 1, color: PeerPALAppColor.primaryColor),
              SizedBox(height: 10),
              CustomTableHeader(heading: "PERSÖNLICHE DATEN"),
              CustomTableRow(
                text: "Profil",
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileOverviewPage()),
                  )
                },
              ),
              CustomTableRow(
                text: "Interessen",
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiscoverInterestsOverviewPage()),
                  ).then((value) =>
                      context.read<DiscoverTabBloc>().add(LoadUsers()))
                },
              ),
              CustomTableHeader(heading: "RECHTLICHES"),
              CustomTableRow(
                text: "Datenschutzerklärung",
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  ),
                },
              ),
              CustomTableRow(
                text: "Impressum",
                onPressed: () async => {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImprintPage()),
                  ),
                },
              ),
/*          FutureBuilder<String>(
                future: getPlattformData(), // async work
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return CustomTableRow(
                      text: "Wird geladen...",
                    );
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return           CustomTableRow(
                          text: "Lizenzen",
                          onPressed: () async => {
                            showLicensePage(
                                context: context,
                                applicationName: "PeerPAL",
                                applicationVersion: "0.01 - BETA",
                                applicationLegalese: applicationLegalese + snapshot.data.toString())
                          },
                        );
                  }
                },
              ),*/
              CustomTableRow(
                text: "Lizenzen",
                onPressed: () async => {
                  showLicensePage(
                      context: context,
                      applicationName: "PeerPAL",
                      applicationVersion: "Testversion 2 - BETA 1.0.0 (2)",
                      applicationLegalese: Strings.applicationLegalese)
                },
              ),
              CustomTableRow(
                text: "Logout",
                onPressed: () async => {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                            dialogHeight: 250,
                            actionButtonText: 'Ausloggen',
                            dialogText: "Möchten Sie sich wirklich ausloggen?",
                            onPressed: () {
                              context.read<AppBloc>().add(AppLogoutRequested());
                              //ToDo: Move into a UseCase.
                              sl<NotificationService>()
                                  .stopRemoteNotificationBackgroundHandler();
                              sl<NotificationService>().unregisterDeviceToken();
                            });
                      }),
                },
              ),
              Column(
                children: [
                  CustomTableHeader(heading: "SONSTIGES"),
                  CustomTableRow(
                    text:
                        "E-Mail: ${sl.get<AuthenticationRepository>().currentUser.email}",
                    isArrowVisible: false,
                  ),
                ],
              ),
              Column(
                children: [
                  CustomTableHeader(heading: "Entwickler-Einstellungen"),
                  CustomTableRow(
                    text:
                        "ID: ${sl.get<AuthenticationRepository>().currentUser.id}",
                    isArrowVisible: false,
                  ),
                  CustomTableRow(
                    text: "Push-Notification-Test",
                    onPressed: () async => {
                      sl<NotificationService>().scheduleNotification(
                          "test",
                          "test",
                          tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)))
                    },
                  ),
                  CustomTableRow(
                    text: "print push notification",
                    onPressed: () async =>
                        {sl<NotificationService>().printPendingNotifications()},
                  ),
                  CustomTableRow(
                    text: "schedule weekly reminder",
                    onPressed: () async => {
                      sl<NotificationService>().scheduleWeeklyNotification()
                    },
                  ),
                  CustomTableRow(
                    text: "reset pending notifications and set weekly reminder",
                    onPressed: () async {
                      sl<NotificationService>().cancelAll();
                      sl<NotificationService>()
                          .setWeeklyReminderScheduled(false);
                      sl<NotificationService>().scheduleWeeklyNotification();
                    },
                  ),
                  CustomTableRow(
                    text: "reset pending notifications and set daily reminder",
                    onPressed: () async {
                      sl<NotificationService>().cancelAll();
                      sl<NotificationService>()
                          .setWeeklyReminderScheduled(false);
                      sl<NotificationService>().scheduleDailyNotification();
                    },
                  ),
                  CustomTableRow(
                    text: "reset pending notifications",
                    onPressed: () async =>
                        {sl<NotificationService>().cancelAll()},
                  ),
                  CustomTableRow(
                    text: "print shared prefs",
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      for (String key in prefs.getKeys()) {
                        print(
                            "key: ${key} value: ${prefs.get(key).toString()}");
                      }
                    },
                  ),
                  CustomTableRow(
                    text: "clear shared prefs",
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
