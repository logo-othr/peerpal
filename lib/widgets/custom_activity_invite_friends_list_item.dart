import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

import '../app/data/resources/colors.dart';

class CustomActivityInviteFriendsListItem extends StatelessWidget {
  PeerPALUser peerPALUser;
  VoidCallback onActive;
  VoidCallback onInactive;
  bool isActive;

  CustomActivityInviteFriendsListItem(
      {required this.peerPALUser,
      required this.isActive,
      required this.onActive,
      required this.onInactive});

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
    return PeerPALAppColor.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: PeerPALAppColor.primaryColor,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: isActive,
              onChanged: (bool? value) {
                if (value != null) {
                  if (value)
                    onActive();
                  else
                    onInactive();
                }
              },
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                children: [
                  Container(
                      child: ClipOval(
                        child: CircleAvatar(
                          radius: 30,
                          child: (peerPALUser.imagePath!.isEmpty ||
                                  peerPALUser.imagePath == null)
                              ? CachedNetworkImage(
                                  imageUrl: peerPALUser.imagePath!,
                                  errorWidget: (context, object, stackTrace) {
                                    return const Icon(
                                      Icons.account_circle,
                                      size: 60.0,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 60.0,
                                  color: Colors.grey,
                                ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: PeerPALAppColor.primaryColor,
                          width: 2.0,
                        ),
                      )),
                  SizedBox(width: 15),
                  Flexible(
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: peerPALUser.name!,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
