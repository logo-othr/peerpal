import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverUserListItem extends StatelessWidget {
  String? header;
  String? imageLink;
  List<String>? locations;
  List<String>? activities;
  VoidCallback onPressed;

  DiscoverUserListItem(
      {required this.header,
      this.imageLink,
      required this.locations,
      required this.activities,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Align(
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Container(
                          child: CircleAvatar(
                            radius: 30,
                            child: Image.network(imageLink!),
                            backgroundColor: Colors.white,
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: primaryColor,
                              width: 4,
                            ),
                          )),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CustomPeerPALHeading2(header!,
                                      color: primaryColor)),
                            ),
                          ),
                          SizedBox(height: 3),
                          Flexible(
                            child: Row(
                              children: [
                                CustomPeerPALHeading3(
                                  text: "Ort: ",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                Container(
                                  width: 150,
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        for (var location in locations!)
                                          TextSpan(
                                            text: "${location}, ",
                                            style: new TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              color: Colors.black,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Flexible(
                            child: Row(
                              children: [
                                CustomPeerPALHeading3(
                                  text: "Aktivitäten: ",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                Container(
                                  width: 150,
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        for (var activity in activities!)
                                          TextSpan(
                                            text: "${activity}, ",
                                            style: new TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              color: Colors.black,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
