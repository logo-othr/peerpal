import 'package:flutter/material.dart';
import 'package:peerpal/chat/presentation/chatroom/widgets/friend_request_button/friend_request_button_layout.dart';

class SendFriendRequestButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SendFriendRequestButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: FriendRequestButtonLayout(
        buttonText: buttonText,
        actionWidget: SizedBox(), // No additional action needed for send button
      ),
    );
  }
}
