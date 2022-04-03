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
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

import '../../../colors.dart';

class InviteFriendsContent extends StatefulWidget {
  final bool isInFlowContext;

  InviteFriendsContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  State<InviteFriendsContent> createState() => _InviteFriendsContentState();
}

class _InviteFriendsContentState extends State<InviteFriendsContent> {
  final ScrollController listScrollController = ScrollController();
  final searchFieldController = TextEditingController();
  late InvitationInputCubit _invitationCubit;
  bool isSearchEmpty = true;
  bool isSearchFocused = false;
  final _focusNode = FocusNode();

  final String _loadUsersErrorMessage =
      'Die Nutzer konnten nicht geladen werden.';
  final String _loadingMessage = "Versuche die Daten zu laden...";

  void onSearchFieldFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        isSearchFocused = true;
      });
    } else {
      setState(() {
        isSearchFocused = false;
      });
    }
  }

  void onSearchFieldTextChange() {
    if (searchFieldController.text.length > 0) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _invitationCubit = context.read<InvitationInputCubit>();
    _focusNode.addListener(onSearchFieldFocusChange);
    searchFieldController.addListener(onSearchFieldTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    searchFieldController.dispose();
  }


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
                SizedBox(height: 40,),
                CustomPeerPALHeading1("Freunde einladen"),
                SizedBox(height: 30),
                _buildInivtationList(),
                _buildSearchBar(),
                isSearchEmpty
                    ? _buildUserList(context)
                    : _buildSearchResult(),
                _buildNextButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResult() {
    return Column(
      children: [
        _buildSearchResultList(_invitationCubit.state.searchResults),
      ],
    );
  }

  Widget _buildSearchResultList(List<PeerPALUser> searchResults) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return buildFriend(searchResults[index]);
        },
        itemCount: searchResults.length,
      ),
    );
  }





  Widget _buildSearchBar() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 1, color: secondaryColor),
                bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Column(
          children: [
            CustomCupertinoSearchBar(
                focusNode: _focusNode,
                enabled: true,
                heading: 'Personensuche',
                searchBarController: this.searchFieldController),
            isSearchEmpty ? Container() : _buildSearchButton() ,
          ],
        ));
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPeerPALButton(
        text: "Suchen",
        onPressed: () async => {
          _invitationCubit.searchUser(searchFieldController.text.toString())
        },
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<PeerPALUser>>(
        stream: context
            .read<InvitationInputCubit>()
            .state
            .friends,
        builder: (BuildContext context,
            AsyncSnapshot<List<PeerPALUser>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Sie haben noch keine Freunde in der App."),);
          } else {
            return ListView.builder(
              itemBuilder: (context, index) =>
                  buildFriend(snapshot.data![index]),
              itemCount: snapshot.data!.length,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomPeerPALButton(
        text: "Weiter",
        onPressed: () async {
          var cubit = context.read<
              InvitationInputCubit>();
          if (widget.isInFlowContext) {
            var activity = await cubit.postData();
            context.flow<Activity>().update(
                    (s) => activity);
          } else {
            await cubit.postData();
            Navigator.pop(context);
          }
        }
    );

  }

  Widget buildFriend(PeerPALUser user) {
    if (user != null) {
      if (user.id == sl
          .get<AppUserRepository>()
          .currentUser
          .id) {
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
                      isActive: context.read<InvitationInputCubit>()
                          .invitationContains(user),
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

  Widget _buildInivtationList() {
    List<PeerPALUser> invitations= _invitationCubit.state.invitations;
    return Container(
      height:30,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
           return Container(
              child: Text(invitations[index].name!),
              decoration: BoxDecoration(
                  color: Colors.black12,
                border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            );
          },
          itemCount: invitations.length,
        ),
    );

  }
}
