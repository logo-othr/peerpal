import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/view/chat_page.dart';
import 'package:peerpal/chat/presentation/chat_list/cubit/chat_list_cubit.dart';
import 'package:peerpal/chat/presentation/chat_list_row.dart';
import 'package:peerpal/chat/presentation/chat_request_list/chat_requests_banner.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class ChatListContent extends StatefulWidget {
  const ChatListContent({Key? key}) : super(key: key);

  @override
  _ChatListContentState createState() => _ChatListContentState();
}

class _ChatListContentState extends State<ChatListContent> {
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Chat',
        hasBackButton: false,
        actionButtonWidget: CustomSupportVideoDialog(
            supportVideo: SupportVideos.links[VideoIdentifier.chat]!),
      ),
      body: BlocBuilder<ChatListCubit, ChatListState>(
        builder: (context, state) {
          return (state.status == ChatListStatus.initial ||
                  state.status == ChatListStatus.loading)
              ? const Center(child: CircularProgressIndicator())
              : _ChatContentBuilder(
                  listScrollController: listScrollController, context: context);
        },
      ),
    );
  }
}

class _ChatContentBuilder extends StatelessWidget {
  final ScrollController listScrollController;
  final BuildContext context;

  const _ChatContentBuilder({
    Key? key,
    required this.listScrollController,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ChatRequestsBanner(),
        ChatList(listScrollController: listScrollController, context: context),
      ],
    );
  }
}

class ChatList extends StatelessWidget {
  final ScrollController listScrollController;
  final BuildContext context;

  const ChatList({
    Key? key,
    required this.listScrollController,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        if (state.status == ChatListStatus.initial) {
          return Center(child: CircularProgressIndicator());
        } else if (state.chats.isEmpty) {
          return Center(child: Text("Es gibt noch keine Chats."));
        } else {
          return Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) => ChatListRow(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userChat: state.chats[index],
                          userId: state.chats[index].user.id!,
                        ),
                      ),
                    );
                  },
                  userChat: state.chats[index],
                  newMessageIndicator: false),
              itemCount: state.chats.length,
              controller: listScrollController,
            ),
          );
        }
      },
    ));
  }
}
