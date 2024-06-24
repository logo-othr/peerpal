import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/friends/custom_friend_request_card.dart';
import 'package:peerpal/friends/friend_request_page/cubit/friend_requests_cubit.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class FriendRequestsContent extends StatelessWidget {
  FriendRequestsContent({Key? key}) : super(key: key);

  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar('Freundschaftsanfragen',
            hasBackButton: true,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos.links[VideoIdentifier.friends]!)),
        body: BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
            builder: (context, state) {
          if (state is FriendRequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FriendRequestsLoaded ||
              state is FriendRequestsInitial) {
            return friendRequestList(context);
          } else {
            return friendRequestList(context);
          }
        }),
      );
    });
  }

  Widget friendRequestList(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: context.read<FriendRequestsCubit>().state.friendRequests,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  buildFriendRequest(context, snapshot.data![index]),
              itemCount: snapshot.data!.length,
              controller: listScrollController,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(PeerPALAppColor.primaryColor),
            ),
          );
        }
      },
    );
  }

  Widget buildFriendRequest(BuildContext context, PeerPALUser userInformation) {
    return CustomFriendRequestCard(
      userInformation: userInformation,
    );
  }
}
