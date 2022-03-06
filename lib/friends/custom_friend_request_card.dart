import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/friends/friend_request_page/cubit/friend_requests_cubit.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:provider/provider.dart';

class CustomFriendRequestCard extends StatelessWidget {
  CustomFriendRequestCard({required this.userInformation});

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  PeerPALUser userInformation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserDetailPage(userInformation.id!)));
                },
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                  child: userInformation.imagePath!.isNotEmpty
                      ? Image.network(
                    userInformation.imagePath!,
                          fit: BoxFit.cover,
                          width: 50.0,
                          height: 50.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomPeerPALHeading3(
                      color: primaryColor,
                      text: userInformation.name!,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: CustomPeerPALHeading3(
                      text: 'Hat dir eine Freundschaftsanfrage gesendet',
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<FriendRequestsCubit>()
                                .friendRequestResponse(
                                userInformation, true);
                          },
                          style: TextButton.styleFrom(
                              minimumSize: Size(50, 20),
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.all(0)),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Annehmen',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            context
                                .read<FriendRequestsCubit>()
                                .friendRequestResponse(
                                userInformation, false);
                          },
                          style: TextButton.styleFrom(
                              minimumSize: const Size(50, 20),
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.all(0)),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Ablehnen',
                              style: TextStyle(color: Colors.white),
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
    );
  }
}
