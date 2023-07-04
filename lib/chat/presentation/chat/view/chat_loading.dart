import 'package:flutter/material.dart';
import 'package:peerpal/chat/presentation/chat/chat_page/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/friend_request_button.dart';
import 'package:peerpal/chat/presentation/single_chat_header_widget.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';

class ChatLoading extends StatelessWidget {
  final ChatLoadingState _state;

  const ChatLoading({
    Key? key,
    required ChatLoadingState state,
  })  : this._state = state,
        super(key: key);

  Widget _chatHeaderBar(BuildContext context, PeerPALUser chatPartner) {
    return ChatHeaderBar(
        chatPartner: chatPartner,
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailPage(
                  chatPartner.id!,
                  hasMessageButton: false,
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _chatHeaderBar(context, _state.chatPartner),
        FriendRequestButton(
          chatPartner: _state.chatPartner,
          appUserRepository: sl<AppUserRepository>(),
        ),
      ],
    );
  }
}
