import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/friends/custom_friend_list_item_user.dart';
import 'package:peerpal/friends/friend_request_page/view/friend_requests_page.dart';
import 'package:peerpal/friends/friends_overview_page/cubit/friends_overview_cubit.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_centered_info_text.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';
import 'package:provider/provider.dart';

class FriendsOverviewContent extends StatelessWidget {
  FriendsOverviewContent({Key? key}) : super(key: key);

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    listScrollController.addListener(scrollListener);
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsOverviewCubit, FriendsOverviewState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar('Freunde',
            hasBackButton: false,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos.links[VideoIdentifier.friends]!)),
        body: BlocBuilder<FriendsOverviewCubit, FriendsOverviewState>(
            builder: (context, state) {
          if (state is FriendsOverviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendsOverviewLoaded ||
              state is FriendsOverviewInitial) {
            return friendList(context);
          } else {
            return friendList(context);
          }
        }),
      );
    });
  }

  Widget friendList(BuildContext context) {
    var searchBarController = new TextEditingController();
    searchBarController.text = Strings.searchDisabled;
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FriendRequestsPage()));
          },
          child: StreamBuilder<int>(
              stream:
                  context.read<FriendsOverviewCubit>().state.friendRequestsSize,
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (snapshot.data.toString() != '0' && snapshot.hasData) {
                  return CustomInvitationButton(
                      length: snapshot.data.toString(),
                      text: 'Freundschaftsanfragen',
                      icon: Icons.people_alt_outlined,
                      header: 'Freunde');
                } else {
                  return Container();
                }
              }),
        ),
        /*   Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                    bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
            child: CustomCupertinoSearchBar(
              enabled: false,
              heading: null,
              searchBarController: searchBarController,
            )),*/
        Expanded(
          child: StreamBuilder<List<dynamic>>(
            stream: context.read<FriendsOverviewCubit>().state.friends,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomLoadingIndicator(text: "Daten werden geladen...");
              } else if (connectionIsActiveOrDone(snapshot)) {
                if (snapshot.hasError) {
                  return CustomCenteredInfoText(
                      text:
                          'Es ist ein Fehler beim laden der Daten aufgetreten.');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          buildFriend(context, snapshot.data![index]),
                      itemCount: snapshot.data!.length,
                      controller: listScrollController,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return CustomCenteredInfoText(
                      text: "Sie haben noch keine Freunde in der App. ");
                } else {
                  return CustomCenteredInfoText(
                      text: "Sie haben noch keine Freunde in der App. ");
                }
              } else {
                return CustomCenteredInfoText(
                    text:
                        'Fehler beim laden. Status: ${snapshot.connectionState}');
              }
            },
          ),
        ),
      ],
    );
  }

  bool connectionIsActiveOrDone(AsyncSnapshot<List<dynamic>> snapshot) {
    return snapshot.connectionState == ConnectionState.active ||
        snapshot.connectionState == ConnectionState.done;
  }

  Widget buildFriend(BuildContext context, PeerPALUser userInformation) {
    if (userInformation != null) {
      if (userInformation.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: PeerPALAppColor.secondaryColor))),
            child: BlocBuilder<FriendsOverviewCubit, FriendsOverviewState>(
                builder: (context, state) {
              return TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserDetailPage(userInformation.id!)));
                },
                child:
                    CustomFriendListItemUser(userInformation: userInformation),
              );
            }));
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
