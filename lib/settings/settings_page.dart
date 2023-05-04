import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/activity/presentation/activity_feed/bloc/activity_feed_bloc.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/app/presentation/bloc/app_bloc.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/app_tab_view/domain/notification_service.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/presentation/bloc/discover_feed_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/friends/friends_overview_page/cubit/friends_overview_cubit.dart';
import 'package:peerpal/profile_setup/presentation/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/settings/imprint_page.dart';
import 'package:peerpal/settings/privacy_policy_page.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_dialog.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_table_header.dart';
import 'package:peerpal/widgets/custom_table_row.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool analytics_sent = false;

  /*Future<String> getPlattformData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return "[App-Name: ${appName}, Package-Name: ${packageName}, Version: ${version}, Build-Number: ${buildNumber}] ";
  }*/

  bool isSwitched = false;
  String password = "";
  final TextEditingController passwordController = TextEditingController();
  bool? notificationPermission;
  bool stream_cleared = false;
  String reset_stream_text = "(8) Tabs zurücksetzen";
  String logout_text = "Möchten Sie sich wirklich ausloggen?";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  Future<void> checkPermission() async {
    bool perm = await sl<NotificationService>().hasPermission();
    setState(() {
      notificationPermission = perm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Einstellungen",
          hasBackButton: false,
          actionButtonWidget: CustomSupportVideoDialog(
              supportVideo: SupportVideos.links[VideoIdentifier.settings]!)),
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
                      applicationVersion: "Version: Hauptstudie 1.1",
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
                            dialogText: logout_text,
                            onPressed: () async {
                              setState(() {
                                logout_text = "Bitte warten...";
                              });

                              try {
                                sl<NotificationService>()
                                    .stopRemoteNotificationBackgroundHandler();
                              } catch (e) {
                                logger.e(e);
                              }
                              try {
                                sl<NotificationService>()
                                    .unregisterDeviceToken();
                              } catch (e) {
                                logger.e(e);
                              }
                              context.read<AppBloc>().add(AppLogoutRequested());
                              await Future.delayed(Duration(seconds: 2));
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
                  CustomTableRow(
                    text: "Analysedaten senden",
                    onPressed: () async {
                      if (analytics_sent == false) {
                        setState(() {
                          analytics_sent = true;
                        });

                        String debugInfo = "";
                        var currentAuthenticatedUser =
                            sl<AuthenticationRepository>().currentUser;
                        var currentAppUser = await sl<AppUserRepository>()
                            .getCurrentUserInformation(
                                currentAuthenticatedUser.id);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String currentPrefs = "";
                        for (String key in prefs.getKeys()) {
                          currentPrefs +=
                              "key: ${key} value: ${prefs.get(key).toString()}" +
                                  " /// ";
                        }
                        String pendingNotifications =
                            await sl<NotificationService>()
                                .printPendingNotifications();

                        debugInfo += " >>> Authenticated user: " +
                            sl<AuthenticationRepository>()
                                .currentUser
                                .toString();
                        debugInfo += ">>> UserInformation: " +
                            (currentAppUser).toString();
                        debugInfo +=
                            " >>> current shared prefs: " + currentPrefs;
                        debugInfo += " >>> pending notifications: " +
                            pendingNotifications;

                        print("------------");
                        logger.i(debugInfo);
                        print("------------");

                        await FirebaseFirestore.instance
                            .collection("debug")
                            .doc()
                            .set({"debug_string": debugInfo});
                      }
                    },
                  ),
                ],
              ),
              Container(
                // ToDo: refactor!
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: PeerPALAppColor.secondaryColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                      child: CustomPeerPALHeading3(
                        text: "Entwickler-Einstellungen",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                          if (isSwitched == true) {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2,
                                              color:
                                              PeerPALAppColor.primaryColor),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      height: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Entwicklereinstellungen \n anschalten?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          15, 10, 0, 10),
                                                      child: CustomPeerPALHeading3(
                                                          text:
                                                          "Passwort eingeben:",
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          15, 5, 15, 0),
                                                      child: TextField(
                                                        textInputAction:
                                                        TextInputAction
                                                            .newline,
                                                        keyboardType:
                                                        TextInputType
                                                            .multiline,
                                                        minLines: 1,
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        controller:
                                                        passwordController,
                                                        decoration:
                                                        InputDecoration(
                                                          contentPadding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 35,
                                                              top: 35,
                                                              right: 35),
                                                          hintMaxLines: 3,
                                                          filled: true,
                                                          fillColor:
                                                          Colors.white,
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 0, 20, 0),
                                            child: CustomPeerPALButton(
                                                onPressed: () {
                                                  setState(() {
                                                    password =
                                                        passwordController.text;
                                                    if (password == "1234") {
                                                      isSwitched = true;
                                                    } else {
                                                      isSwitched = false;
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                text: "Ok"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            setState(() {
                              password = "";
                            });
                          }
                        },
                        activeTrackColor: PeerPALAppColor.secondaryColor,
                        activeColor: PeerPALAppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              password == "1234"
                  ? Column(
                children: [
                        CustomTableRow(
                          text:
                              "(1) ID: ${sl.get<AuthenticationRepository>().currentUser.id}",
                          isArrowVisible: false,
                        ),
                        CustomTableRow(
                            text: notificationPermission == true
                                ? "(2) Benachrichtigung-Berechtigung: ja"
                                : "(2) Benachrichtigung-Berechtigung: nein"),
                        CustomTableRow(
                          text: "(3) Wöchentliche Erinnerung aktivieren",
                          onPressed: () async => {
                            sl<NotificationService>()
                                .scheduleWeeklyNotification()
                          },
                        ),
                        CustomTableRow(
                          text:
                              "(4) Alle löschen/Aktivieren: w. Benachrichtigung",
                          onPressed: () async {
                            sl<NotificationService>().cancelAll();
                            sl<NotificationService>()
                                .setWeeklyReminderScheduled(false);
                            sl<NotificationService>()
                                .scheduleWeeklyNotification();
                          },
                        ),
                        CustomTableRow(
                          text:
                              "(5) Alle löschen/Aktivieren: tgl. Benachrichtgung",
                          onPressed: () async {
                            sl<NotificationService>().cancelAll();
                            sl<NotificationService>()
                                .setWeeklyReminderScheduled(false);
                            sl<NotificationService>()
                                .scheduleDailyNotification();
                          },
                        ),
                        CustomTableRow(
                          text: "(6) Löschen: Benachrichtigungen",
                          onPressed: () async =>
                              {sl<NotificationService>().cancelAll()},
                        ),
                        CustomTableRow(
                          text:
                              "(7) Löschen: Lokaler Speicher (Shared Preferences)",
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                          },
                        ),
                        CustomTableRow(
                          text: reset_stream_text,
                          onPressed: () async {
                            if (stream_cleared == false) {
                              setState(() {
                                stream_cleared = true;
                              });

                              setState(() {
                                reset_stream_text = "(8) Lade Chat neu... ";
                              });

                              logger.d("Reset Chat");
                              sl<ChatListBloc>()..add(ChatListLoaded());
                              await Future.delayed(Duration(seconds: 2));

                              setState(() {
                                reset_stream_text =
                                    "(8) Lade Entdecken neu... ";
                              });
                              logger.d("Reset Discover");

                              context.read<DiscoverTabBloc>()..add(LoadUsers());
                              await Future.delayed(Duration(seconds: 2));
                              setState(() {
                                reset_stream_text =
                                    "(8) Lade Aktivitäten neu... ";
                              });
                              logger.d("Reset ActivityFeed");

                              sl<ActivityFeedBloc>()..add(LoadActivityFeed());
                              await Future.delayed(Duration(seconds: 2));
                              setState(() {
                                reset_stream_text = "(8) Lade Freunde neu... ";
                              });
                              logger.d("Reset Friends");

                              context
                                  .read<FriendsOverviewCubit>()
                                  .getFriendsFromUser();
                              await Future.delayed(Duration(seconds: 2));
                            }
                            setState(() {
                              reset_stream_text = "(8) Warten... ";
                            });
                            setState(() {
                              reset_stream_text =
                                  "(8) Tabs wurden zurückgesetzt.";
                            });
                          },
                        ),
                        CustomTableRow(
                          text:
                              "(9) Ausgabe: Lokaler Speicher (Shared Preferences)",
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            for (String key in prefs.getKeys()) {
                              logger.i(
                                  "key: ${key} value: ${prefs.get(key).toString()}");
                            }
                          },
                        ),
                        CustomTableRow(
                          text: "(10) Ausgabe: Benachrichtigungen",
                          onPressed: () async {
                            String pendingNotificationsString =
                                await sl<NotificationService>()
                                    .printPendingNotifications();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Text(pendingNotificationsString),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
