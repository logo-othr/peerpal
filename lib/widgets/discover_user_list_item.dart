import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverUserListItem extends StatelessWidget {
  String? header;
  String? description;
  IconData? icon;

  DiscoverUserListItem(
      {required this.header, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 1, color: secondaryColor),
                bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          icon,
                          size: 60,
                          color: primaryColor,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: primaryColor,
                          width: 4.0,
                        ),
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomPeerPALHeading2(header!, color: primaryColor),
                    CustomPeerPALHeading3(
                      color: Colors.black,
                      text: description!,
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: secondaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
