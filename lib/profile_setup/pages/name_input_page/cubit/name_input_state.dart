part of 'name_input_cubit.dart';

class NameInputState extends Equatable  {
  const NameInputState({
    this.formValidationStatus = FormzStatus.pure,
    this.username = const UsernameModel.pure(),
    this.errorMessage = '',
  });

final FormzStatus formValidationStatus;
final UsernameModel username;
final String errorMessage;

NameInputState copyWith({
  FormzStatus? status,
  UsernameModel? username,
  String? password,
  String? errorMessage,
}) {
  return NameInputState(
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
