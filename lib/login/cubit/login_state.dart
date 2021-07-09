part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.formValidationStatus = FormzStatus.pure,
    this.email = const EmailModel.pure(),
    this.password = '',
    this.errorMessage = '',
    this.loginCounter = 0,
    this.lastAttempt = 0,
  });

  final FormzStatus formValidationStatus;
  final EmailModel email;
  final String password;
  final String errorMessage;
  final int loginCounter;
  final int lastAttempt;

  LoginState copyWith({
    FormzStatus? status,
    EmailModel? email,
    String? password,
    String? errorMessage,
    int? loginCounter,
    int? lastAttempt,
  }) {
    return LoginState(
      formValidationStatus: status ?? formValidationStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      loginCounter: loginCounter ?? this.loginCounter,
      lastAttempt: lastAttempt ?? this.lastAttempt,
    );
  }

  @override
  List<Object> get props => [
        formValidationStatus,
        email,
        password,
        errorMessage,
        loginCounter,
        lastAttempt
      ];
}
