import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/cubit/profile_overview_cubit.dart';
import 'package:peerpal/profile_wizard_flow/pages/profile_overview/view/profile_overview_page.dart';
import 'package:peerpal/settings/imprint_page.dart';
import 'package:peerpal/settings/licenses_page.dart';
import 'package:peerpal/settings/privacy_policy_page.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_table_header.dart';
import 'package:peerpal/widgets/custom_table_row.dart';
import 'package:provider/src/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Widget> customTableRows = [

  ];
  final List<Widget> customTableRows2 = [
    CustomTableRow(text: "Datenschutz"),
    CustomTableRow(text: "Impressum"),
    CustomTableRow(text: "Lizenzen")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Einstellungen", hasBackButton: false),
      body: Column(
        children: [
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
              )
            },
          ),

          CustomTableHeader(heading: "RECHTLICHES"),

          CustomTableRow(text: "Datenschutzerklärung",
            onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>PrivacyPolicyPage()),
              ),
            },
          ),
          CustomTableRow(text: "Impressum",
            onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImprintPage()),
              ),
            },
          ),
          CustomTableRow(text: "Lizenzen",
            onPressed: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LicensesPage()),
              ),
            },
          ),
          CustomTableRow(text: "Logout",
            onPressed: () async => {
              context.read<AppBloc>().add(AppLogoutRequested())
            },
          )
        ],
      ),
    );
  }
}
