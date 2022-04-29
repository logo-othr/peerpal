part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignupState extends Equatable {
  const SignupState({
    this.email = const EmailModel.pure(),
    this.password = const PasswordModel.pure(),
    this.errorMessage = '',
    this.confirmedPassword = const ConfirmedPasswordModel.pure(),
    this.status = FormzStatus.pure,
    this.visible=true,
    this.confirmVisible=true,
  });

  final EmailModel email;
  final PasswordModel password;
  final String errorMessage;
  final ConfirmedPasswordModel confirmedPassword;
  final FormzStatus status;
  final bool visible;
  final bool confirmVisible;

  @override
  List<Object> get props => [email, password, confirmedPassword, status,visible,confirmVisible];

  SignupState copyWith({
    EmailModel? email,
    PasswordModel? password,
    ConfirmedPasswordModel? confirmedPassword,
    FormzStatus? formValidationStatus,
    String? errorMessage,
    bool? visible,
    bool? confirmVisible,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: formValidationStatus ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      visible: visible ?? this.visible,
      confirmVisible: confirmVisible ?? this.confirmVisible,
    );
  }
}
