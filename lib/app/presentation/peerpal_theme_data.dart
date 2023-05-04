import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';

class PeerPALThemeData {
  final BorderRadius borderRadius = BorderRadius.circular(8);

  final Color colorYellow = Color(0xffffff00);
  final Color colorPrimary = Color(0xffabcdef);

  ThemeData get materialTheme {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: PeerPALAppColor.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: PeerPALAppColor.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: PeerPALAppColor.primaryColor,
                width: 3,
              )),
        ));
  }
}
