import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/view/chat_page.dart';
import 'package:peerpal/chat/presentation/chat_list_row.dart';
import 'package:peerpal/chat/presentation/chat_request_list/bloc/chat_request_list_bloc.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

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
        appBar: CustomAppBar('Nachrichtenanfragen',
            hasBackButton: true,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.chat_request]!)),
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
                    itemBuilder: (context, index) => ChatListRow(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              userChat: snapshot.data![index],
                              userId: snapshot.data![index].user.id!,
                            ),
                          ),
                        );
                      },
                      userChat: snapshot.data![index],
                      newMessageIndicator: true,
                    ),
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
}
