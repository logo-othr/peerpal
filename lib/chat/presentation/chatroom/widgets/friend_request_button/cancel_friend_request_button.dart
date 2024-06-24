import 'package:flutter/material.dart';
import 'package:peerpal/chat/presentation/chatroom/widgets/friend_request_button/friend_request_button_layout.dart';

class CancelFriendRequestButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CancelFriendRequestButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FriendRequestButtonLayout(
      buttonText: buttonText,
      actionWidget: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size(50, 20),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Abbrechen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
