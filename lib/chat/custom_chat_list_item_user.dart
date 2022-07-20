import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import 'domain/usecase_response/user_chat.dart';

// ignore: must_be_immutable
class CustomChatListItemUser extends StatelessWidget {
  UserChat userInformation;

  CustomChatListItemUser({required this.userInformation});

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
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                SizedBox(height: 5),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: userInformation.chat.lastMessage == null
                            ? "Nachricht konnte nicht geladen werden"
                            : userInformation.chat.lastMessage!.message
                                .toString(),
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                /*CustomPeerPALHeading3(
                    text: userInformation.chat.lastMessage == null ? "Nachricht konnte nicht geladen werden" :  userInformation.chat.lastMessage!.message.toString() , color: Colors.black),*/
                Text(DateFormat('yyyy-MM-dd - kk:mm').format(
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
