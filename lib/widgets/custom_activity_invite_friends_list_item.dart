import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import 'custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomActivityInviteFriendsListItem extends StatefulWidget {
  IconData? icon;
  String? name;

  CustomActivityInviteFriendsListItem({this.name, this.icon});

  @override
  _CustomActivityInviteFriendsListItemState createState() =>
      _CustomActivityInviteFriendsListItemState();
}

class _CustomActivityInviteFriendsListItemState
    extends State<CustomActivityInviteFriendsListItem> {
  bool? isChecked = false;

  // https://api.flutter.dev/flutter/material/MaterialStateProperty-class.html
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value;
                });
              },
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  children: [
                    Container(
                        child: CircleAvatar(
                          radius: 30,
                          child: Icon(
                            widget.icon,
                            size: 60,
                            color: primaryColor,
                          ),
                          backgroundColor: Colors.white,
                        ),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: primaryColor,
                            width: 2.0,
                          ),
                        )),
                    SizedBox(width: 15),
                    CustomPeerPALHeading2("tim",color: primaryColor),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
