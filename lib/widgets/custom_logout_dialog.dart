import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/widgets/custom_activity_participations_dialog_item.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../colors.dart';

class CustomLogoutDialog extends StatefulWidget {
  CustomLogoutDialog({ required this.onPressed});
  VoidCallback onPressed;
  @override
  _CustomLogoutDialogState createState() => _CustomLogoutDialogState();
}

class _CustomLogoutDialogState extends State<CustomLogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: primaryColor), borderRadius: BorderRadius.circular(10)),
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Möchten Sie sich wirklich ausloggen?", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0,0,20,0),
            child: CustomPeerPALButton(
                onPressed: () {
                  widget.onPressed();
                  Navigator.pop(context);
                },
                text: 'Ausloggen'),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0,0,20,0),
            child: CustomPeerPALButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Abbrechen'),
          )
        ],
      ),
    );
  }
}
