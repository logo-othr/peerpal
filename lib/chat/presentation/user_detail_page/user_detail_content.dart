import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/chat/presentation/chatroom/chatroom_page.dart';
import 'package:peerpal/chat/presentation/user_detail_page/cubit/user_detail_cubit.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_activity_dialog.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';
import 'package:peerpal/widgets/friend_request_peerpal_button.dart';

class UserInformationContent extends StatelessWidget {
  final bool hasMessageButton;

  UserInformationContent({
    required this.hasMessageButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailCubit, UserDetailState>(
      builder: (context, state) {
        if (state is UserDetailLoaded) {
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
                                top: BorderSide(
                                    width: 1,
                                    color: PeerPALAppColor.secondaryColor),
                                bottom: BorderSide(
                                    width: 1,
                                    color: PeerPALAppColor.secondaryColor))),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Material(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                    clipBehavior: Clip.hardEdge,
                                    child: (state.user.imagePath == null ||
                                            state.user.imagePath!.isEmpty)
                                        ? Icon(
                                            Icons.account_circle,
                                            size: 100.0,
                                            color: Colors.grey,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: state.user.imagePath!,
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
                                                    color: PeerPALAppColor.primaryColor,
                                                  ),
                                                ),
                                              ),*/
                                            errorWidget:
                                                (context, object, stackTrace) {
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
                                  '${state.user.name} | ${state.user.age}',
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
                              heading: 'INTERESSEN',
                              text: state.user.discoverActivitiesCodes!
                                  .map((e) => context
                                      .read<ActivityRepository>()
                                      .getActivityNameFromCode(e))
                                  .toList()
                                  .join(', '),
                              isArrowIconVisible: true,
                              onPressed: () {
                                _showActivityDialog(state, context);
                              },
                            ),
                            CustomSingleTable(
                              heading: 'KOMMUNIKATIONSART',
                              text: state.user.discoverCommunicationPreferences!
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
                                      builder: (context) => ChatroomPage(
                                            chatPartnerId: state.user.id!,
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
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future _showActivityDialog(UserDetailLoaded state, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> activityNames = state.user.discoverActivitiesCodes!
              .map((e) =>
                  context.read<ActivityRepository>().getActivityNameFromCode(e))
              .toList();

          return CustomActivityDialog(
            isOwnCreatedActivity: false,
            activities: activityNames,
          );
        });
  }

  Widget friendRequestButton(BuildContext context, PeerPALUser chatPartner) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: sl.get<FriendRepository>().getFriendList(),
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
                      .get<FriendRepository>()
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
                                  .get<FriendRepository>()
                                  .canceledFriendRequest(chatPartner);
                            },
                            color: Colors.red);
                      } else {
                        return FriendRequestPeerPALButton(
                            buttonText: "Freundschaftsanfrage senden",
                            onPressed: () {
                              sl
                                  .get<FriendRepository>()
                                  .sendFriendRequestToUser(chatPartner);
                            },
                            color: PeerPALAppColor.primaryColor);
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
