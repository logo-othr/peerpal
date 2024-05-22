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


  Widget _chatroomLoading(ChatroomLoading state, BuildContext chatroomContext) {
    return Column(
      children: [
        ChatHeader(
          chatPartner: state.chatPartner,
          onBackButtonPressed
              : () => Navigator.of(chatroomContext).pop(),
          onBarPressed: () =>
              Navigator.push(
                chatroomContext,
                MaterialPageRoute(
                  builder: (context) =>
                      UserInformationPage(
                        state.chatPartner.id!,
                        hasMessageButton: false,
                      ),
                ),
              ),
          // TODO: Use a controller or cubit for header and friend request button
          getFriendList: chatroomContext.read<GetFriendList>(),
          cancelFriendRequest: chatroomContext.read<CancelFriendRequest>(),
          getSentFriendRequests: chatroomContext.read<GetSentFriendRequests>(),
          sendFriendRequest: chatroomContext.read<SendFriendRequest>(),)
      ],
    );
  }

  Widget _chatroomUninitialized() {
    return Container(child: Text("ChatroomUninitialized"));
  }

  Widget _chatroomLoaded() {
    return Container(child: Text("ChatroomLoaded"));
  }


}
