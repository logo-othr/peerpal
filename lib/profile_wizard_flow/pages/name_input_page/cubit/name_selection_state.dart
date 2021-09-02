part of 'name_selection_cubit.dart';

class NameSelectionState extends Equatable  {
  const NameSelectionState({
    this.formValidationStatus = FormzStatus.pure,
    this.username = const UsernameModel.pure(),
    this.errorMessage = '',
  });

final FormzStatus formValidationStatus;
final UsernameModel username;
final String errorMessage;

NameSelectionState copyWith({
  FormzStatus? status,
  UsernameModel? username,
  String? password,
  String? errorMessage,
}) {
  return NameSelectionState(
    formValidationStatus: status ?? formValidationStatus,
    username: username ?? this.username,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@override
List<Object> get props => [
  formValidationStatus,
  username,
  errorMessage,
];
}
