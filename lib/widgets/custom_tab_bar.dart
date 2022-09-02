import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({Key? key, required this.index, required this.onTap})
      : super(key: key);
  final int index;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      // ToDo: dynamic index
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedFontSize: 11,
      unselectedFontSize: 9,
      unselectedLabelStyle: TextStyle(color: PeerPALAppColor.primaryColor),
      selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.nature_people),
            label: 'Aktivität',
            backgroundColor: PeerPALAppColor.secondaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.face),
            label: 'Entdecken',
            backgroundColor: PeerPALAppColor.secondaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: 'Freunde',
            backgroundColor: PeerPALAppColor.secondaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: PeerPALAppColor.secondaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'Einstellungen',
            backgroundColor: PeerPALAppColor.secondaryColor),
      ],
      onTap: (index) => onTap(index),
    );
  }
}
