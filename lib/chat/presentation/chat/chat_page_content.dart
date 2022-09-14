import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/chat/domain/models/chat_message.dart';
import 'package:peerpal/chat/domain/repository/chat_repository.dart';
import 'package:peerpal/chat/domain/usecase_response/user_chat.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/chat_message_input_field.dart';
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
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _setupListener();
    return Scaffold(
      body: SafeArea(
        child:
            BlocBuilder<ChatPageBloc, ChatPageState>(builder: (context, state) {
          if (state is ChatPageInitial) {
            return CircularProgressIndicator();
          } else if (state is ChatPageLoading) {
            return _chatLoading(context, state);
          } else if (state is ChatLoaded) {
            return _chatLoaded(context, state);
          } else if (state is WaitingForChatOrFirstMessage) {
            return _waitingForChatOrFristMessage(context, state);
          } else if (state is ChatPageError) {
            return _chatPageError(state);
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  _scrollListener() {
    if (_listScrollController.hasClients) {
      if (_listScrollController.offset >=
              _listScrollController.position.maxScrollExtent &&
          !_listScrollController.position.outOfRange) {}
    }
  }

  void _setupListener() {
    _listScrollController.addListener(_scrollListener);
    _focus.addListener(() {
      print("Focus: ${_focus.hasFocus.toString()}");
    });
  }

  Widget _chatPageError(ChatPageError state) {
    return Container(
      child: Center(
        child: Text(state.message),
      ),
    );
  }

  Widget _waitingForChatOrFristMessage(
      BuildContext context, WaitingForChatOrFirstMessage state) {
    return Column(
      children: [
        _chatHeaderBar(context, state.chatPartner),
        _FriendRequestButton(
            chatPartner: state.chatPartner,
            appUserRepository: sl<AppUserRepository>()),
        Spacer(),
        ChatButtons(state.appUser.phoneNumber,
            textEditingController: _textEditingController),
        ChatMessageInputField(
          textEditingController: _textEditingController,
          focus: _focus,
          sendTextMessage: () => sendChatMessage(state.chatPartner, null,
              _textEditingController.text, "0", context),
          sendImage: () => {},
        ),
      ],
    );
  }

  Widget _chatLoading(BuildContext context, ChatPageLoading state) {
    return Column(
      children: [
        _chatHeaderBar(context, state.chatPartner),
        _FriendRequestButton(
          chatPartner: state.chatPartner,
          appUserRepository: sl<AppUserRepository>(),
        ),
      ],
    );
  }

  Widget _chatLoaded(BuildContext context, ChatLoaded state) {
    return Column(
      children: [
        _chatHeaderBar(context, state.chatPartner),
        _FriendRequestButton(
            chatPartner: state.chatPartner,
            appUserRepository: sl<AppUserRepository>()),
        _messages(context, state),
        _ChatBottomBar(
          appUser: state.appUser,
          chatMessageController: _textEditingController,
          chatPartner: state.chatPartner,
          chatMessageInputField: ChatMessageInputField(
            sendImage: () => {},
            textEditingController: _textEditingController,
            focus: _focus,
            sendTextMessage: () => sendChatMessage(
                state.chatPartner,
                state.userChat.chat.chatId,
                _textEditingController.text,
                "0",
                context),
          ),
          userChat: state.userChat,
          currentUserId: sl<AuthenticationRepository>().currentUser.id,
        ),
      ],
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

  Future<void> sendChatMessage(PeerPALUser chatPartner, String? chatId,
      String content, String type, BuildContext context) async {
    _textEditingController.clear();
    context.read<ChatPageBloc>()
      ..add(SendMessageEvent(
        chatPartner: chatPartner,
        chatId: chatId,
        message: content,
        type: type,
      ));
    // type: 0 = text, 1 = image,
    /*  if (content.trim() != '') {
      _textEditingController.clear();
      await context.read<ChatPageBloc>().sendChatMessage(
            chatPartner,
            chatId,
            content,
            type,
          );
    } else {}*/
  }

  Widget _messages(BuildContext context, ChatLoaded state) {
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
            controller: _listScrollController,
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
                      child: (imageUrl.isEmpty)
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
}

class _ChatBottomBar extends StatefulWidget {
  final String currentUserId;
  final UserChat userChat;
  final PeerPALUser appUser;
  final PeerPALUser chatPartner;
  final TextEditingController chatMessageController;
  final ChatMessageInputField chatMessageInputField;

  const _ChatBottomBar(
      {required this.currentUserId,
      required this.userChat,
      required this.appUser,
      required this.chatPartner,
      required this.chatMessageController,
      required this.chatMessageInputField,
      Key? key})
      : super(key: key);

  @override
  State<_ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<_ChatBottomBar> {
  @override
  Widget build(BuildContext context) {
    if (isChatRequestNotAccepted && isChatNotStartedByAppUser) {
      return _chatRequestReplyButtons(context, widget.currentUserId);
    } else {
      return _chatBottomBar();
    }
  }

  Widget _chatBottomBar() {
    return StreamBuilder<int>(
      stream:
          sl<ChatRepository>().messageCountForChat(widget.userChat.chat.chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomLoadingIndicator(text: "Chat wird geladen..");
        } else if (snapshot.data == 0) {
          return _chatDoesNotExist();
        } else {
          return _bottomBarContent();
        }
      },
    );
  }

  bool get isChatNotStartedByAppUser =>
      widget.userChat.chat.startedBy != widget.appUser.id;

  bool get isChatRequestNotAccepted =>
      !widget.userChat.chat.chatRequestAccepted;

  Widget _bottomBarContent() {
    return Column(
      children: [
        ChatButtons(widget.appUser.phoneNumber,
            textEditingController: widget.chatMessageController),
        widget.chatMessageInputField,
      ],
    );
  }

  Widget _chatDoesNotExist() {
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
  }

  Widget _chatRequestReplyButtons(BuildContext context, String currentUserId) {
    // ToDo: dispatch event?
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
  final AppUserRepository _appUserRepository;

  const _FriendRequestButton(
      {Key? key,
      required this.chatPartner,
      required AppUserRepository appUserRepository})
      : this._appUserRepository = appUserRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PeerPALUser>>(
        stream: _appUserRepository.getFriendList(),
        builder:
            (context, AsyncSnapshot<List<PeerPALUser>> friendListSnapshot) {
          if (!friendListSnapshot.hasData ||
              _chatPartnerIsAFriend(friendListSnapshot, chatPartner)) {
            return Container();
          } else {
            return _friendRequestButton();
          }
        });
  }

  Widget _friendRequestButton() {
    return StreamBuilder<List<PeerPALUser>>(
        stream: _appUserRepository.getSentFriendRequestsFromUser(),
        builder: (context,
            AsyncSnapshot<List<PeerPALUser>> sentFriendRequestsSnapshot) {
          if (sentFriendRequestsSnapshot.hasData) {
            if (_friendRequestPending(
                sentFriendRequestsSnapshot, chatPartner)) {
              return _cancelFriendRequestButton();
            } else {
              return _sendFriendRequestButton();
            }
          } else {
            return Container();
          }
        });
  }

  bool _chatPartnerIsAFriend(
      AsyncSnapshot<List<PeerPALUser>> friendListSnapshot,
      PeerPALUser chatPartner) {
    return friendListSnapshot.data!
        .map((e) => e.id)
        .toList()
        .contains(chatPartner.id);
  }

  bool _friendRequestPending(
      AsyncSnapshot<List<PeerPALUser>> friendRequestsSnapshot,
      PeerPALUser chatPartner) {
    return friendRequestsSnapshot.data!
        .map((e) => e.id)
        .toList()
        .contains(chatPartner.id);
  }

  Widget _sendFriendRequestButton() {
    return SendFriendRequestButton(
        buttonText: "Anfrage senden",
        onPressed: () {
          _appUserRepository.sendFriendRequestToUser(chatPartner);
        });
  }

  Widget _cancelFriendRequestButton() {
    return CancelFriendRequestButton(
        buttonText: "Anfrage gesendet",
        onPressed: () {
          _appUserRepository.canceledFriendRequest(chatPartner);
        });
  }
}
