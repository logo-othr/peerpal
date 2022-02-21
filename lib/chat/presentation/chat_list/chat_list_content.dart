import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peerpal/chat/custom_chat_list_item_user.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_page.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/chat_request_list_page.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:provider/provider.dart';

class ChatListContent extends StatefulWidget {
  ChatListContent({Key? key}) : super(key: key);

  @override
  State<ChatListContent> createState() => _ChatListContentState();
}

class _ChatListContentState extends State<ChatListContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(
          'Chat',
          hasBackButton: false,
        ),
        body:
            BlocBuilder<ChatListBloc, ChatListState>(builder: (context, state) {
          if (state.status == ChatListStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ChatListStatus.success) {
            return ChatPartnerList(context);
          } else {
            return ChatPartnerList(context);
          }
        }),
      );
    });
  }

  Widget ChatPartnerList(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = "Derzeit noch deaktiviert";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        StreamBuilder<List<UserChat>>(
          stream: context.read<ChatListBloc>().state.chatRequests,
          builder:
              (BuildContext context, AsyncSnapshot<List<UserChat>> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatRequestListPage()));
                },
                child: CustomInvitationButton(
                    text: "Nachrichtenanfragen",
                    icon: Icons.email,
                    header: "Nachrichten",
                    length: snapshot.data!.length.toString()),
              );
            }
          },
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: secondaryColor),
                    bottom: BorderSide(width: 1, color: secondaryColor))),
            child: CustomCupertinoSearchBar(searchBarController: searchFieldController)),
        Expanded(
          child: StreamBuilder<List<UserChat>>(
            stream: context.read<ChatListBloc>().state.chats,
            builder:
                (BuildContext context, AsyncSnapshot<List<UserChat>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: CustomPeerPALButton(
                    text: 'Chat starten',
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      buildChatPartner(context, snapshot.data![index]),
                  itemCount: snapshot.data!.length,
                  controller: listScrollController,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildChatPartner(BuildContext context, UserChat userChat) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        userChat: userChat,
                        userId: userChat.user.id!,
                      )));
        },
        child: CustomChatListItemUser(userInformation: userChat),
      ),
    );
  }
}
