import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_invitation/cubit/activity_invitation_cubit.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/strings.dart';
import 'package:peerpal/widgets/custom_activity_header_card.dart';
import 'package:peerpal/widgets/custom_activity_invite_friends_list_item.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../../colors.dart';

class InviteFriendsContent extends StatelessWidget {
  final bool isInFlowContext;

  InviteFriendsContent({Key? key, required this.isInFlowContext})
      : super(key: key);
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextEditingController searchFieldController = TextEditingController();
    searchFieldController.text = Strings.searchDisabled;
    return BlocBuilder<InvitationInputCubit, ActivityInvitationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            "Aktivität planen",
            hasBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //CustomActivityHeaderCard(),
                SizedBox(
                  height: 40,
                ),
                CustomPeerPALHeading1("Freunde einladen"),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: secondaryColor))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: CupertinoSearchTextField(
                      enabled: false,
                      controller: searchFieldController,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<PeerPALUser>>(
                    stream: context.read<InvitationInputCubit>().state.friends,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PeerPALUser>> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text("Sie haben noch keine Freunde in der App."),);
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              buildFriend(context, snapshot.data![index]),
                          itemCount: snapshot.data!.length,
                          controller: listScrollController,
                        );
                      }
                    },
                  ),
                ),
                /*  Column(
              children: [
                CustomActivityInviteFriendsListItem(icon: Icons.face, name: "Tim"),
              ],
            ),*/

                CustomPeerPALButton(
                    text: "Weiter",
                    onPressed: () async  {
                      var cubit = context.read<
                          InvitationInputCubit>();
                      if (isInFlowContext) {
                        var activity = await cubit.postData();
                        context.flow<Activity>().update(
                                (s) => activity);
                      } else {
                        await cubit.postData();
                        Navigator.pop(context);
                      }
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFriend(BuildContext context, PeerPALUser user) {
    if (user != null) {
      if (user.id == sl.get<AppUserRepository>().currentUser.id) {
        return const SizedBox.shrink();
      } else {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: secondaryColor))),
            child: BlocBuilder<InvitationInputCubit, ActivityInvitationState>(
                builder: (context, state) {
              var cubit = context.read<InvitationInputCubit>();
              return TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetailPage(user.id!)));
                },
                child: CustomActivityInviteFriendsListItem(
                  peerPALUser: user,
                  isActive: context.read<InvitationInputCubit>().invitationContains(user),
                  onActive: () {
                    cubit.addInvitation(user);
                  },
                  onInactive: () {
                    cubit.removeInvitation(user);
                  },
                ),
              );
            }));
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
