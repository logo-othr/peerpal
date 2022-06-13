import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class LicensesPage extends StatefulWidget {
  @override
  _LicensesPageState createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Lizenzen",
        hasBackButton: true,
      ),
      body: Center(
          child: Container(
        child: CustomPeerPALHeading2(
          "Lizenzen",
          color: primaryColor,
        ),
      )),
    );
  }
}
