import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chat/domain/usecases/get_user.dart';
import 'package:peerpal/chat/presentation/chat_request_list/cubit/chat_requests_cubit.dart';
import 'package:peerpal/chat/presentation/chatlist/widgets/chat_row.dart';
import 'package:peerpal/chat/presentation/chatlist/widgets/chat_row_cubit.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class ChatRequestListContent extends StatefulWidget {
  ChatRequestListContent({Key? key}) : super(key: key);

  @override
  State<ChatRequestListContent> createState() => _ChatRequestListContentState();
}

class _ChatRequestListContentState extends State<ChatRequestListContent> {
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRequestsCubit, ChatRequestsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar('Nachrichtenanfragen',
            hasBackButton: true,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.chat_request]!)),
        body: BlocBuilder<ChatRequestsCubit, ChatRequestsState>(
            builder: (context, state) {
          if (state.status == ChatRequestsStatus.initial) {
            return Center(child: CircularProgressIndicator());
          } else if (state.requests.isEmpty) {
            return Container();
          } else {
            return ChatRequestList(state);
          }
        }),
      );
    });
  }

  Widget ChatRequestList(ChatRequestsState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) => BlocProvider(
              create: (context) =>
                  ChatRowCubit(sl<GetUser>(), sl<GetAuthenticatedUser>())
                    ..loadChatRow(state.requests[index]),
              child: ChatListRow(),
            ),
            itemCount: context.read<ChatRequestsCubit>().state.requests.length,
            controller: listScrollController,
          ),
        )),
      ],
    );
  }
}
