import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chatv2/presentation/widgets/friend_request_button/cancel_friend_request_button.dart';
import 'package:peerpal/chatv2/presentation/widgets/friend_request_button/friend_request_cubit.dart';
import 'package:peerpal/chatv2/presentation/widgets/friend_request_button/send_friend_request_button.dart';

class SmartFriendRequestButton extends StatelessWidget {
  const SmartFriendRequestButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendRequestCubit, FriendRequestState>(
      builder: (context, state) {
        if (state is FriendRequestVisible) {
          return _buildFriendRequestButton(context);
        } else if (state is FriendRequestPending) {
          return _buildCancelFriendRequestButton(context);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildFriendRequestButton(BuildContext context) {
    return SendFriendRequestButton(
      buttonText: "Anfrage senden",
      onPressed: () {
        context.read<FriendRequestCubit>().sendFriendRequest();
      },
    );
  }

  Widget _buildCancelFriendRequestButton(BuildContext context) {
    return CancelFriendRequestButton(
      buttonText: "Anfrage abbrechen",
      onPressed: () {
        context.read<FriendRequestCubit>().cancelFriendRequest();
      },
    );
  }
}
