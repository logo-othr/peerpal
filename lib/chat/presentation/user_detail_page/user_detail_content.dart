import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/chat/presentation/chat/chat_page.dart';
import 'package:peerpal/chat/presentation/user_detail_page/bloc/user_detail_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/widgets/custom_activity_dialog.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';
import 'package:peerpal/widgets/friend_request_peerpal_button.dart';

class UserDetailContent extends StatelessWidget {
  final bool hasMessageButton;

  UserDetailContent({
    required this.hasMessageButton,
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
          body: state.status != UserDetailStatus.success
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        width: 1, color: secondaryColor),
                                    bottom: BorderSide(
                                        width: 1, color: secondaryColor))),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Material(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0)),
                                        clipBehavior: Clip.hardEdge,
                                        child: (context
                                                        .read<UserDetailBloc>()
                                                        .state
                                                        .user
                                                        .imagePath ==
                                                    null ||
                                                context
                                                    .read<UserDetailBloc>()
                                                    .state
                                                    .user
                                                    .imagePath!
                                                    .isEmpty)
                                            ? Icon(
                                                Icons.account_circle,
                                                size: 100.0,
                                                color: Colors.grey,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: context
                                                    .read<UserDetailBloc>()
                                                    .state
                                                    .user
                                                    .imagePath!,
                                                fit: BoxFit.cover,
                                                width: 100.0,
                                                height: 100.0,
                                                /*  placeholder:
                                                  (BuildContext context, url) =>
                                                      SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),*/
                                                errorWidget: (context, object,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.account_circle,
                                                    size: 100.0,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              )
                                        /* : const Icon(
                                              Icons.account_circle,
                                              size: 100.0,
                                              color: Colors.grey,
                                            ),*/
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: CustomPeerPALHeading2(
                                      '${context.read<UserDetailBloc>().state.user.name} | ${context.read<UserDetailBloc>().state.user.age}',
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CustomSingleTable(
                                  heading: 'AKTIVITÄTEN',
                                  text: state.user.discoverActivitiesCodes!
                                      .map((e) => ActivityRepository
                                          .getActivityNameFromCode(e))
                                      .toList()
                                      .join(', '),
                                  isArrowIconVisible: true,
                                  onPressed: () {
                                    _showActivityDialog(context, state);
                                  },
                                ),
                                CustomSingleTable(
                                  heading: 'KOMMUNIKATIONSART',
                                  text: state
                                      .user.discoverCommunicationPreferences!
                                      .map((e) => e.toUIString)
                                      .toList()
                                      .join(', '),
                                  isArrowIconVisible: false,
                                  onPressed: () {},
                                ),
                                CustomSingleTable(
                                  heading: 'ORT',
                                  text: state.user.discoverLocations!
                                      .map((e) => e.place)
                                      .toList()
                                      .join(', '),
                                  isArrowIconVisible: false,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                                                userId: state.user.id!,
                                                userChat: null,
                                              )),
                                    );
                                  },
                                  child: hasMessageButton
                                      ? CustomPeerPALButton(
                                          text: "Nachricht schreiben",
                                        )
                                      : Container(),
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

  Future _showActivityDialog(state, context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomActivityDialog(
              isOwnCreatedActivity: false,
              activities: state.user.discoverActivitiesCodes!
                  .map((e) => ActivityRepository.getActivityNameFromCode(e))
                  .toList());
        });
  }

  Widget friendRequestButton(BuildContext context, PeerPALUser chatPartner) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: sl.get<AppUserRepository>().getFriendList(),
        // ToDo: move to correct layer
        builder: (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!
                .map((e) => e.id)
                .toList()
                .contains(chatPartner.id)) {
              return Container();
            } else {
              return StreamBuilder<List<PeerPALUser>>(
                  stream: sl
                      .get<AppUserRepository>()
                      .getSentFriendRequestsFromUser(),
                  builder:
                      (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!
                          .map((e) => e.id)
                          .toList()
                          .contains(chatPartner.id)) {
                        return FriendRequestPeerPALButton(
                            buttonText: "Anfrage abbrechen",
                            onPressed: () {
                              sl
                                  .get<AppUserRepository>()
                                  .canceledFriendRequest(chatPartner);
                            },
                            color: Colors.red);
                      } else {
                        return FriendRequestPeerPALButton(
                            buttonText: "Freundschaftsanfrage senden",
                            onPressed: () {
                              sl
                                  .get<AppUserRepository>()
                                  .sendFriendRequestToUser(chatPartner);
                            },
                            color: primaryColor);
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
