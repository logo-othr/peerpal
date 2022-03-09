import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/settings/imprint_page.dart';
import 'package:peerpal/settings/licenses_page.dart';
import 'package:peerpal/settings/privacy_policy_page.dart';
import 'package:peerpal/strings.dart';
import 'package:peerpal/tabs/discover/discover_tab_bloc.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_dialog.dart';
import 'package:peerpal/widgets/custom_table_header.dart';
import 'package:peerpal/widgets/custom_table_row.dart';
import 'package:provider/src/provider.dart';

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
      body: SingleChildScrollView(
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
                        Image(image: AssetImage('assets/PeerPAL-Logo.png')))),
            SizedBox(height: 10),
            Divider(thickness: 1, color: primaryColor),
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
                    context.read<DiscoverTabBloc>().add(ReloadUsers()))
              },
            ),
            CustomTableHeader(heading: "RECHTLICHES"),
            CustomTableRow(
              text: "Datenschutzerklärung",
              onPressed: () async => {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
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
                    applicationVersion: "0.01 - BETA",
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
                          actionButtonText: 'Ausloggen',
                          dialogText: "Möchten Sie sich wirklich ausloggen?",
                          onPressed: () => {
                                context
                                    .read<AppBloc>()
                                    .add(AppLogoutRequested()),
                            context
                                .read<AppBloc>()
                                .deleteDeviceTokenFromUser(),

                              });
                    }),
              },
            ),
            Column(
              children: [
                CustomTableHeader(heading: "SONSTIGES"),
                CustomTableRow(
                  text:
                      "E-Mail: ${sl.get<AppUserRepository>().currentUser.email}",
                ),
              ],
            ),
            Column(
              children: [
                CustomTableHeader(heading: "Entwickler-Informationen"),
                CustomTableRow(
                  text: "ID: ${sl.get<AppUserRepository>().currentUser.id}",
                ),
                FutureBuilder<PeerPALUser>(
                  future:
                      sl.get<AppUserRepository>().getCurrentUserInformation(),
                  builder: (BuildContext context,
                      AsyncSnapshot<PeerPALUser> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return CustomTableRow(
                          text: "Wird geladen...",
                        );
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Container(
                            color: Colors.amber,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SelectableText(
                                    "Debug-Informationen:\nCache: \n ${sl.get<AppUserRepository>().cache.toString()}  \nAuthUser:\n${sl.get<AppUserRepository>().currentUser.toString()}\nUser:\n${snapshot.data.toString()}"),
                              ],
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
