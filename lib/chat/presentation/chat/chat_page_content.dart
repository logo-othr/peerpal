import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chat/single_chat_header_widget.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/chat_buttons.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/single_chat_cancel_friend_request_button.dart';
import 'package:peerpal/widgets/single_chat_send_friend_request_button.dart';
import 'package:provider/provider.dart';

class ChatPageContent extends StatelessWidget {
  ChatPageContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController listScrollController = ScrollController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  _scrollListener() {
    if (listScrollController.hasClients) {
      if (listScrollController.offset >=
              listScrollController.position.maxScrollExtent &&
          !listScrollController.position.outOfRange) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    listScrollController.addListener(_scrollListener);
    _focus.addListener(() {
      print("Focus: ${_focus.hasFocus.toString()}");
    });
    return Scaffold(
      body: SafeArea(
        child:
            BlocBuilder<ChatPageBloc, ChatPageState>(builder: (context, state) {
          if (state is ChatPageInitial) {
            return CircularProgressIndicator();
          } else if (state is ChatPageLoading) {
            return Column(
              children: [
                _chatHeaderBar(context, state.chatPartner),
                _FriendRequestButton(chatPartner: state.chatPartner),
              ],
            );
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                _chatHeaderBar(context, state.chatPartner),
                _FriendRequestButton(chatPartner: state.chatPartner),
                buildChatMessages(context, state),
                (!state.userChat.chat.chatRequestAccepted &&
                        state.userChat.chat.startedBy != state.appUser.id)
                    ? _ChatRequestAcceptDenyButtons(context)
                    : StreamBuilder<int>(
                        stream: sl<ChatRepository>()
                            .messageCountForChat(state.userChat.chat.chatId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CustomLoadingIndicator(
                                text: "Lade Nachrichten..");
                          } else if (snapshot.data == 0) {
                            return Container(
                              width: double.infinity,
                              height: 500,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Der Chat ist nicht mehr vorhanden."),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  CustomPeerPALButton(
                                    text: "Zurück",
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                ChatButtons(state.appUser.phoneNumber,
                                    textEditingController:
                                        textEditingController),
                                singleChatTextFormField(state.chatPartner,
                                    state.userChat.chat.chatId, context),
                              ],
                            );
                          }
                        }),
              ],
            );
          } else if (state is WaitingForChatOrFirstMessage) {
            return Column(
              children: [
                // ToDo: verify that state cast is correctly used
                _chatHeaderBar(context, state.chatPartner),
                _FriendRequestButton(chatPartner: state.chatPartner),
                Spacer(),
                ChatButtons(state.appUser.phoneNumber,
                    textEditingController: textEditingController),
                singleChatTextFormField(state.chatPartner, null, context),
              ],
            );
          } else if (state is ChatPageError) {
            return Container(
              child: Center(
                child: Text(state.message),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  Widget _chatHeaderBar(BuildContext context, PeerPALUser user) {
    return ChatHeaderBar(
      name: user.name,
      urlAvatar: user.imagePath,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(
              user.id!,
              hasMessageButton: false,
            ),
          ),
        );
      },
    );
  }

  Widget singleChatTextFormField(
      PeerPALUser chatPartner, String? chatId, context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: PeerPALAppColor.secondaryColor,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 22),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              focusNode: _focus,
              onSubmitted: (value) {
                sendChatMessage(chatPartner, chatId, textEditingController.text,
                    "0", context);
              },
              controller: textEditingController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 30, right: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: PeerPALAppColor.primaryColor, width: 3.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: PeerPALAppColor.primaryColor, width: 3.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Nachricht',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send, size: 35),
                onPressed: () => sendChatMessage(chatPartner, chatId,
                    textEditingController.text, "0", context),
                color: PeerPALAppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendChatMessage(PeerPALUser chatPartner, String? chatId,
      String content, String type, BuildContext context) async {
    // type: 0 = text, 1 = image,
    if (content.trim() != '') {
      textEditingController.clear();
      await context.read<ChatPageBloc>().sendChatMessage(
            chatPartner,
            chatId,
            content,
            type,
          );
    } else {}
  }

  Widget buildChatMessages(BuildContext context, ChatLoaded state) {
    return Flexible(
        child: StreamBuilder<List<ChatMessage>>(
      stream: state.messages,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Container(
                height: 100,
                alignment: Alignment.center,
                child: Text("Keine Nachrichten gefunden"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              ChatMessage message = snapshot.data![index];
              var isAppUserMessage = message.userId == state.appUser.id;
              var imageUrl = isAppUserMessage
                  ? state.appUser.imagePath
                  : state.chatPartner.imagePath;
              return buildChatMessage(message, isAppUserMessage, imageUrl!);
            },
            itemCount: snapshot.data?.length,
            reverse: true,
            controller: listScrollController,
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
    ));
  }

  Widget buildChatMessage(
      ChatMessage chatMessage, bool isRightAligned, String imageUrl) {
    const radius = Radius.circular(12);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment:
          isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            color: isRightAligned
                ? PeerPALAppColor.primaryColor.shade400
                : PeerPALAppColor.secondaryColor.shade400,
            borderRadius: isRightAligned
                ? borderRadius
                    .subtract(const BorderRadius.only(topRight: radius))
                : borderRadius
                    .subtract(const BorderRadius.only(topLeft: radius)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  chatMessage.message,
                  style: const TextStyle(color: Colors.black, fontSize: 19),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: 15),
              ClipOval(
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: (imageUrl!.isEmpty)
                          ? Icon(
                              Icons.account_circle,
                              size: 40.0,
                              color: Colors.grey,
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              errorWidget: (context, object, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 40.0,
                                  color: Colors.grey,
                                );
                              },
                            ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ChatRequestAcceptDenyButtons(BuildContext context) {
    // ToDo: dispatch event instead of calling the repository manually
    ChatPageBloc bloc = context.read<ChatPageBloc>();
    ChatLoaded currentState = bloc.state as ChatLoaded;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Container(
        child: Column(
          children: [
            CustomPeerPALButton(
                text: "Annehmen",
                onPressed: () {
                  context.read<ChatRepository>().sendChatRequestResponse(
                      currentUserId,
                      currentState.chatPartner.id!,
                      true,
                      currentState.userChat.chat.chatId);
                  Navigator.pop(context);
                }),
            SizedBox(height: 8),
            CustomPeerPALButton(
                text: "Ablehnen",
                onPressed: () {
                  context.read<ChatRepository>().sendChatRequestResponse(
                      currentUserId,
                      currentState.chatPartner.id!,
                      false,
                      currentState.userChat.chat.chatId);
                  // context.read<ChatListBloc>().add(ChatListLoaded());
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}

class _FriendRequestButton extends StatelessWidget {
  final PeerPALUser chatPartner;

  const _FriendRequestButton({Key? key, required this.chatPartner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: sl.get<AppUserRepository>().getFriendList(),
        // ToDo: move to correct layer
        builder: (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!
                .map((e) => e.id)
                .toList()
                .contains(chatPartner.id)) {
              return Container();
            } else {
              return StreamBuilder<List<PeerPALUser>>(
                  stream: sl
                      .get<AppUserRepository>()
                      .getSentFriendRequestsFromUser(),
                  builder:
                      (context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!
                          .map((e) => e.id)
                          .toList()
                          .contains(chatPartner.id)) {
                        return SingleChatCancelFriendRequestButton(
                            buttonText: "Anfrage gesendet",
                            onPressed: () {
                              sl
                                  .get<AppUserRepository>()
                                  .canceledFriendRequest(chatPartner);
                            });
                      } else {
                        return SingleChatSendFriendRequestButton(
                            buttonText: "Anfrage senden",
                            onPressed: () {
                              sl
                                  .get<AppUserRepository>()
                                  .sendFriendRequestToUser(chatPartner);
                            });
                      }
                    } else {
                      return Container();
                    }
                  });
            }
          } else {
            return Container();
          }
        });
  }
}
