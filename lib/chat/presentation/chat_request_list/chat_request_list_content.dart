import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/custom_chat_list_item_user.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_page.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class ChatRequestListContent extends StatefulWidget {
  ChatRequestListContent({Key? key}) : super(key: key);

  @override
  State<ChatRequestListContent> createState() => _ChatRequestListContentState();
}

class _ChatRequestListContentState extends State<ChatRequestListContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRequestListBloc, ChatRequestListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              'Nachrichtenanfragen',
              hasBackButton: true,
            ),
            body: BlocBuilder<ChatRequestListBloc, ChatRequestListState>(
                builder: (context, state) {
                  if (state.status == ChatRequestListStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == ChatRequestListStatus.success) {
                    return ChatRequestList(context);
                  } else {
                    return ChatRequestList(context);
                  }
                }),
          );
        });
  }

  Widget ChatRequestList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<UserChat>>(
            stream: context.read<ChatRequestListBloc>().state.chatRequests,
            builder:
                (BuildContext context, AsyncSnapshot<List<UserChat>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Es gibt keine Nachrichtenanfragen.",
                  ),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        buildChatPartner(context, snapshot.data![index]),
                    itemCount: snapshot.data!.length,
                    controller: listScrollController,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildChatPartner(BuildContext context, UserChat userInformation) {
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
                    userChat: userInformation,
                    userId: userInformation.user.id!,
                  )));
        },
        child: CustomChatListItemUser(userInformation: userInformation),
      ),
    );
  }
}