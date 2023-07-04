part of 'chat_bottom_bar_cubit.dart';

abstract class ChatBottomBarState {}

class ChatBottomBarInitialState extends ChatBottomBarState {}

class ChatBottomBarLoadingState extends ChatBottomBarState {}

class ChatBottomBarLoadedState extends ChatBottomBarState {
  final int messageCount;
  final bool isChatNotStartedByAppUser;
  final bool isChatRequestNotAccepted;

  ChatBottomBarLoadedState({
    required this.messageCount,
    required this.isChatNotStartedByAppUser,
    required this.isChatRequestNotAccepted,
  });
}

class ChatBottomBarErrorState extends ChatBottomBarState {
  final String errorMessage;

  ChatBottomBarErrorState({required this.errorMessage});
}
