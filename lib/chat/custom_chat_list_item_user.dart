import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';

import 'domain/usecase_response/user_chat.dart';

// ignore: must_be_immutable
class CustomChatListItemUser extends StatelessWidget {
  UserChat userInformation;
  bool redDot;

  CustomChatListItemUser({required this.userInformation, required this.redDot});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      color: Colors.black,
    );
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Material(
            child: (userInformation.user.imagePath!.isEmpty ||
                    userInformation.user.imagePath == null)
                ? Icon(
                    Icons.account_circle,
                    size: 60.0,
                    color: Colors.grey,
                  )
                : CachedNetworkImage(
                    errorWidget: (context, object, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 60.0,
                        color: Colors.grey,
                      );
                    },
                    imageUrl: userInformation.user.imagePath!,
                    fit: BoxFit.cover,
                    width: 60.0,
                    height: 60.0,
                  ),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            clipBehavior: Clip.hardEdge,
          ),
        ),
        Flexible(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPeerPALHeading3(
                    text: userInformation.user.name!,
                    color: PeerPALAppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: userInformation.chat.lastMessage!.message
                              .toString()
                              .contains(
                                  "https://firebasestorage.googleapis.com/")
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(width: 5),
                                  CustomPeerPALText(
                                    text: "Foto",
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  //Text("Foto", style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: ),)
                                ],
                              ))
                          : RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: userInformation.chat.lastMessage ==
                                            null
                                        ? "Nachricht konnte nicht geladen werden"
                                        : userInformation
                                            .chat.lastMessage!.message
                                            .toString(),
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Spacer(),
                    redDot
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 5),
                /*CustomPeerPALHeading3(
                    text: userInformation.chat.lastMessage == null ? "Nachricht konnte nicht geladen werden" :  userInformation.chat.lastMessage!.message.toString() , color: Colors.black),*/
                Text(DateFormat('dd.MM.yyyy - kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(userInformation.chat.lastUpdated))))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
