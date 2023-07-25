import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/chat/presentation/chat_list/cubit/chat_requests_cubit.dart';
import 'package:peerpal/chat/presentation/chat_request_list/chat_request_list_page.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_invitation_button.dart';

class ChatRequestsBanner extends StatelessWidget {
  const ChatRequestsBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: sl<ChatRequestsCubit>()..loadChatRequests(),
        child: _ChatRequestsBannerContent());
  }
}

class _ChatRequestsBannerContent extends StatelessWidget {
  const _ChatRequestsBannerContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRequestsCubit, ChatRequestsState>(
      builder: (context, state) {
        if (state.status == ChatRequestsStatus.initial) {
          return Center(child: CircularProgressIndicator());
        } else if (state.requests.isEmpty) {
          return Container();
        } else {
          return buildChatRequestsBanner(context);
        }
      },
    );
  }

  Widget buildChatRequestsBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRequestListPage()),
        );
      },
      child: CustomInvitationButton(
        text: "Nachrichtenanfragen",
        icon: Icons.email,
        header: "Nachrichten",
        length:
            context.watch<ChatRequestsCubit>().state.requests.length.toString(),
      ),
    );
  }
}
