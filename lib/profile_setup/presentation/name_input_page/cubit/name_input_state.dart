part of 'name_input_cubit.dart';

abstract class UsernameState extends Equatable {
  final FormzStatus formValidationStatus;
  final UsernameModel newUsername;
  final String errorMessage;
  final PeerPALUser currentUser;

  const UsernameState({
    this.formValidationStatus = FormzStatus.pure,
    this.newUsername = const UsernameModel.pure(),
    this.errorMessage = '',
    this.currentUser = PeerPALUser.empty,
  });

  UsernameStateLoaded copyWith({
    FormzStatus? validationStatus,
    UsernameModel? username,
    String? password,
    String? errorMessage,
    PeerPALUser? currentUser,
  }) {
    return UsernameStateLoaded(
      formValidationStatus: validationStatus ?? formValidationStatus,
      username: username ?? this.newUsername,
      errorMessage: errorMessage ?? this.errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object> get props => [
        formValidationStatus,
        newUsername,
        errorMessage,
        currentUser,
      ];
}

class UsernameStateInitial extends UsernameState {
  final FormzStatus formValidationStatus;
  final UsernameModel username;
  final String errorMessage;
  final PeerPALUser currentUser;

  const UsernameStateInitial({
    this.formValidationStatus = FormzStatus.pure,
    this.username = const UsernameModel.pure(),
    this.errorMessage = '',
    this.currentUser = PeerPALUser.empty,
  }) : super(
            formValidationStatus: formValidationStatus,
            newUsername: username,
            errorMessage: errorMessage,
            currentUser: currentUser);
}

class UsernameStateLoaded extends UsernameState {
  final FormzStatus formValidationStatus;
  final UsernameModel username;
  final String errorMessage;
  final PeerPALUser currentUser;

  const UsernameStateLoaded({
    this.formValidationStatus = FormzStatus.pure,
    this.username = const UsernameModel.pure(),
    this.errorMessage = '',
    this.currentUser = PeerPALUser.empty,
  }) : super(
            formValidationStatus: formValidationStatus,
            newUsername: username,
            errorMessage: errorMessage,
            currentUser: currentUser);
}
