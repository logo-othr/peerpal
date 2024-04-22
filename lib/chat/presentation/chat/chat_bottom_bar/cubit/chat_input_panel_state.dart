part of 'chat_input_panel_cubit.dart';

abstract class ChatInputPanelState {}

class ChatInputPanelInitialState extends ChatInputPanelState {}

class ChatInputPanelLoadingState extends ChatInputPanelState {}

class ChatInputPanelLoadedState extends ChatInputPanelState {
  final int messageCount;
  final bool isChatNotStartedByAppUser;
  final bool isChatRequestNotAccepted;

  ChatInputPanelLoadedState({
    required this.messageCount,
    required this.isChatNotStartedByAppUser,
    required this.isChatRequestNotAccepted,
  });
}

class ChatInputPanelErrorState extends ChatInputPanelState {
  final String errorMessage;

  ChatInputPanelErrorState({required this.errorMessage});
}
