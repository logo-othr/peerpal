import 'package:flutter/material.dart';
import 'package:peerpal/chat/presentation/chat/bloc/chat_page_bloc.dart';
import 'package:peerpal/chat/presentation/chat/view/friend_request_button.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/chat/single_chat_header_widget.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/setup.dart';

class ChatLoadingContent extends StatelessWidget {
  final ChatLoadingState _state;

  const ChatLoadingContent({
    Key? key,
    required ChatLoadingState state,
  })  : this._state = state,
        super(key: key);

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
