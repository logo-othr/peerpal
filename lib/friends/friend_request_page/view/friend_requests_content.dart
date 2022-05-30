import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/friends/custom_friend_request_card.dart';
import 'package:peerpal/friends/friend_request_page/cubit/friend_requests_cubit.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

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
            appBar: CustomAppBar(
              'Freundschaftsanfragen',
              hasBackButton: true,
            ),
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
      builder: (BuildContext context,
          AsyncSnapshot<List<dynamic>> snapshot) {
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
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }
      },
    );
  }

  Widget buildFriendRequest(BuildContext context,
      PeerPALUser userInformation) {
    return CustomFriendRequestCard(
      userInformation: userInformation,
    );
  }
}