import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chatv2/domain/core-usecases/cancel_friend_request.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_friend_list.dart';
import 'package:peerpal/chatv2/domain/core-usecases/get_sent_friend_requests.dart';
import 'package:peerpal/chatv2/domain/core-usecases/send_friend_request.dart';
import 'package:peerpal/chatv2/presentation/chatroom/chatroom_cubit.dart';
import 'package:peerpal/chatv2/presentation/widgets/chat_header.dart';

class ChatroomContent extends StatelessWidget {
  ChatroomContent({
    Key? key,
  }) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext chatroomContext) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChatroomCubit, ChatroomState>(
            builder: (context, chatroomState) {
              if (chatroomState is ChatroomInitial) {
                return _chatroomInitial();
              } else if (chatroomState is ChatroomLoading) {
                return _chatroomLoading(chatroomState, chatroomContext);
              } else if (chatroomState is ChatroomUninitialized) {
                return _chatroomUninitialized;
              } else if chatroomState is ChatroomLoaded) {
                return _chatroomLoaded();
              }
            }),
      ),
    );
  }

  Widget _chatroomInitial() {
    return Center(child: CircularProgressIndicator());
  }


  Widget _chatroomLoading(ChatroomLoading state, BuildContext roomCtx) {
    return Column(
      children: [
        ChatHeader(
          chatPartner: state.chatPartner,
          onBackButtonPressed: () => Navigator.of(roomCtx).pop(),
          onBarPressed: () => _openUserpage(roomCtx, state.chatPartner.id!),
          // TODO: Use a controller or cubit for header and friend request button
          getFriendList: roomCtx.read<GetFriendList>(),
          cancelFriendRequest: roomCtx.read<CancelFriendRequest>(),
          getSentFriendRequests: roomCtx.read<GetSentFriendRequests>(),
          sendFriendRequest: roomCtx.read<SendFriendRequest>(),)
      ],
    );
  }

  void _openUserpage(BuildContext chatroomContext, String userId) {
    Navigator.push(
      chatroomContext,
      MaterialPageRoute(
        builder: (context) =>
            UserInformationPage(
              userId,
              hasMessageButton: false,
            ),
      ),
    )
  }

  Widget _chatroomUninitialized() {
    return Container(child: Text("ChatroomUninitialized"));
  }

  Widget _chatroomLoaded() {
    return Container(child: Text("ChatroomLoaded"));
  }


}
