import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      // ToDo: dynamic index
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedFontSize: 11,
      unselectedFontSize: 9,
      unselectedLabelStyle: TextStyle(color: primaryColor),
      selectedLabelStyle: TextStyle(color: Colors.blueAccent),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Entdecken',
            backgroundColor: secondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.nature_people),
            label: 'Aktivität',
            backgroundColor: secondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Freunde',
            backgroundColor: secondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: secondaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
            backgroundColor: secondaryColor),
      ],
      onTap: (index) {
        // ToDo: dynamic index
      },
    );
  }
}
