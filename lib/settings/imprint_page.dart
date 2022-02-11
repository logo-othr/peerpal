import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';



class ImprintPage extends StatefulWidget {
  @override
  _ImprintPageState createState() => _ImprintPageState();
}

class _ImprintPageState extends State<ImprintPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar("Impressum", hasBackButton: true,),
      body: Center(
          child: Container(
            child: CustomPeerPALHeading2("Impressum", color: primaryColor,),
          )),
    );
  }
}