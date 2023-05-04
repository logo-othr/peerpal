import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

// ignore: must_be_immutable
class CustomFriendListItemUser extends StatelessWidget {
  PeerPALUser userInformation;

  CustomFriendListItemUser({required this.userInformation});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              clipBehavior: Clip.hardEdge,
              child: (userInformation.imagePath!.isEmpty ||
                      userInformation.imagePath == null)
                  ? const Icon(
                      Icons.account_circle,
                      size: 60.0,
                      color: Colors.grey,
                    )
                  : CachedNetworkImage(
                      imageUrl: userInformation.imagePath!,
                      fit: BoxFit.cover,
                      width: 60.0,
                      height: 60.0,
                      placeholder: (BuildContext context, url) => Container(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: PeerPALAppColor.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, object, stackTrace) {
                        return const Icon(
                          Icons.account_circle,
                          size: 60.0,
                          color: Colors.grey,
                        );
                      },
                    ),
            )),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPeerPALHeading3(
                  text: userInformation.name!,
                  color: PeerPALAppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              SizedBox(height: 5),
              CustomPeerPALHeading3(
                  text: 'Profil anzeigen', color: Colors.black)
            ],
          ),
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: PeerPALAppColor.secondaryColor,
          size: 20,
        )
      ],
    );
  }
}
