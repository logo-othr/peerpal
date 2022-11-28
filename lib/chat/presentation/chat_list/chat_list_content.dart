import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/chat/custom_chat_list_item_user.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/chat_page.dart';
import 'package:peerpal/chat/presentation/chat_list/bloc/chat_list_bloc.dart';
import 'package:peerpal/chat/presentation/chat_request_list/chat_request_list_page.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';
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
        appBar: CustomAppBar('Chat',
            hasBackButton: false,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos.links[VideoIdentifier.chat]!)),
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
    searchFieldController.text = Strings.searchDisabled;

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
        /*  Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                    bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
            child: CustomCupertinoSearchBar(
              enabled: false,
                searchBarController: searchFieldController)),*/
        Expanded(
          child: StreamBuilder<List<UserChat>>(
            stream: context.read<ChatListBloc>().state.chats,
            builder:
                (BuildContext context, AsyncSnapshot<List<UserChat>> snapshot) {
              debugChatStreamText(snapshot);
              // ToDo: stream<int> message count for debugChatStreamText

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                      "Es gibt noch keine Chats.") /* CustomPeerPALButton(
                    text: 'Chat starten',
                  )*/
                  ,
                );
              } else {
                context.read<ChatListBloc>()
                  ..add(ChatListStreamUpdate(snapshot.data!));
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        ChatRow(userChat: snapshot.data![index]),
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

/* Widget buildChatPartner(BuildContext context, UserChat userChat) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: TextButton(
        onPressed: () async {
          // context.read<ChatListBloc>()..add(ChatClickEvent(userChat));
          sl<ChatListBloc>()..add(ChatClickEvent(userChat));
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
  }*/
}

void debugChatStreamText(AsyncSnapshot snapshot) {
  logger.i("-------------- SteamBuilder Chat Build ---------- ");
  logger.i(snapshot.connectionState);
  if (snapshot.hasData) logger.i("chat snapshot.hasData");
  if (snapshot.hasData && snapshot.data!.isEmpty)
    logger.i("chat snapshot.hasData && snapshot.data!.isEmpty");
  if (snapshot.hasData) logger.i("chat length: ${snapshot.data!.length}");
  logger.i("-------------- SteamBuilder Chat Build /ENDE ---------- ");
}

class ChatRow extends StatelessWidget {
  final UserChat userChat;

  const ChatRow({Key? key, required this.userChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom:
                  BorderSide(width: 1, color: PeerPALAppColor.secondaryColor))),
      child: TextButton(
        onPressed: () async {
          // context.read<ChatListBloc>()..add(ChatClickEvent(userChat));
          context.read<ChatListBloc>()..add(ChatClickEvent(userChat));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        userChat: userChat,
                        userId: userChat.user.id!,
                      )));
        },
        child: CustomChatListItemUser(
            userInformation: userChat,
            redDot: hasRedDot(context, userChat.chat.chatId)),
      ),
    );
  }

  // ToDo: Create map (seen) in state and move logic to bloc/usecase
  // ToDo: Bug: All messages appear as new when the app is restarted.
  // ToDo: Sort chats for red dot?
  bool hasRedDot(BuildContext context, String chatId) {
    Map<String, String> lastClicked =
        context.read<ChatListBloc>().state.lastClicked;
    Map<String, String> lastMessage = context.read<ChatListBloc>().state.redDot;
    int timestampLastClicked = int.parse(lastClicked[chatId] ?? "0");
    int timestampLastMessage = int.parse(lastMessage[chatId] ?? "0");
    bool redDot = false;
    if (timestampLastClicked < timestampLastMessage) {
      redDot = true;
    }
    ;
    return redDot;
  }
}
