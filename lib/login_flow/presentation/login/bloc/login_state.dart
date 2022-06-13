part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.formValidationStatus = FormzStatus.pure,
    this.email = const EmailModel.pure(),
    this.password = '',
    this.errorMessage = '',
    this.loginCounter = 0,
    this.lastAttempt = 0,
    this.visible=true,
  });

  final FormzStatus formValidationStatus;
  final EmailModel email;
  final String password;
  final String errorMessage;
  final int loginCounter;
  final int lastAttempt;
  final bool visible;

  LoginState copyWith({
    FormzStatus? status,
    EmailModel? email,
    String? password,
    String? errorMessage,
    int? loginCounter,
    int? lastAttempt,
    bool? visible,
  }) {
    return LoginState(
      formValidationStatus: status ?? formValidationStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      loginCounter: loginCounter ?? this.loginCounter,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      visible: visible ?? this.visible,
    );
  }

  @override
  List<Object> get props => [
    formValidationStatus,
    email,
    password,
    errorMessage,
    loginCounter,
    lastAttempt,
    visible
  ];
}
