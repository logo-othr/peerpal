import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/colors.dart';

import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';

class ChatProfileOverview extends StatelessWidget {
  final PeerPALUser userInformation;

  ChatProfileOverview(
      {Key? key,
      required this.userInformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Profil',
        hasBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(width: 1, color: secondaryColor),
                          bottom: BorderSide(width: 1, color: secondaryColor))),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                            clipBehavior: Clip.hardEdge,
                            child: userInformation
                                    .imagePath!.isNotEmpty
                                ? Image.network(
                              userInformation.imagePath!,
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 100.0,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return const Icon(
                                        Icons.account_circle,
                                        size: 100.0,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.account_circle,
                                    size: 100.0,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: CustomPeerPALHeading2(
                                '${userInformation.name} | ${userInformation.age}',
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )),
              CustomSingleTable(
                heading: 'AKTIVITÄTEN',
                text: 'Fußball',
                isArrowIconVisible: false,
                onPressed: () {},
              ),
              CustomSingleTable(
                heading: 'KOMMUNIKATIONSART',
                text: 'Chat',
                isArrowIconVisible: false,
                onPressed: () {},
              ),
              CustomSingleTable(
                heading: 'ORT',
                text: 'Mainz',
                isArrowIconVisible: false,
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
