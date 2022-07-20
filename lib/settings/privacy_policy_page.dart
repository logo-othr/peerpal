import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Datenschutz",
        hasBackButton: true,
      ),
      body: Center(
          child: Container(
        child: CustomPeerPALHeading2(
          "Datenschutzerklärung",
          color: primaryColor,
        ),
      )),
    );
  }
}
