import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/models/chat.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_page.dart';
import 'package:peerpal/chat/presentation/user_detail_page/bloc/user_detail_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';
import 'package:peerpal/widgets/friend_request_peerpal_button.dart';
import 'package:peerpal/widgets/single_chat_send_friend_request_button.dart';

class UserDetailContent extends StatelessWidget {
  UserDetailContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailBloc, UserDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            'Profil',
            hasBackButton: true,
          ),
          body: state.status != UserDetailStatus.success ? CircularProgressIndicator() : Center(
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
                              bottom:
                              BorderSide(width: 1, color: secondaryColor))),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Material(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                clipBehavior: Clip.hardEdge,
                                child: context
                                    .read<UserDetailBloc>()
                                    .state
                                    .user
                                    .imagePath!
                                    .isNotEmpty
                                    ? Image.network(
                                  context
                                      .read<UserDetailBloc>()
                                      .state
                                      .user
                                      .imagePath!,
                                  fit: BoxFit.cover,
                                  width: 100.0,
                                  height: 100.0,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null)
                                      return child;
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
                                '${context.read<UserDetailBloc>().state.user.name} | ${context.read<UserDetailBloc>().state.user.age}',
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      )),
                  CustomSingleTable(
                    heading: 'AKTIVITÄTEN',
                    text: state.user.discoverActivities!
                        .map((e) => e.name)
                        .toList()
                        .join(','),
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
                  Spacer(),
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      userId:
                                          state
                                          .user
                                          .id!,
                                      userChat: null,
                                    )),
                              );
                            },
                            child: CustomPeerPALButton(
                              text: "Nachricht schreiben",
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 8),
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          friendRequestButton(context, state.user),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget friendRequestButton(BuildContext context, PeerPALUser chatPartner) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: sl.get<AppUserRepository>().getFriendList(), // ToDo: move to correct layer
        builder: (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.map((e) => e.id).toList().contains(chatPartner.id)) {
              return Container();
            } else {
              return StreamBuilder<List<PeerPALUser>>(
                  stream: sl.get<AppUserRepository>().getSentFriendRequestsFromUser(),
                  builder:
                      (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.map((e) => e.id).toList()
                          .contains(chatPartner.id)) {
                        return FriendRequestPeerPALButton(buttonText: "Anfrage abbrechen", onPressed: () {
                          sl.get<AppUserRepository>()
                              .canceledFriendRequest(
                              chatPartner);
                        }, color: Colors.red);

                      } else {
                        return FriendRequestPeerPALButton(buttonText: "Anfrage senden", onPressed: () {
                          sl.get<AppUserRepository>()
                              .sendFriendRequestToUser(
                              chatPartner);
                        }, color: primaryColor);
                      }
                    } else {
                      return Container();
                    }
                  });
            }
          } else {
            return Container();
          }
        });
  }

}
