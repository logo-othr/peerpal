part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignupState extends Equatable {
  const SignupState({
    this.email = const EmailModel.pure(),
    this.password = const PasswordModel.pure(),
    this.confirmedPassword = const ConfirmedPasswordModel.pure(),
    this.status = FormzStatus.pure,
  });

  final EmailModel email;
  final PasswordModel password;
  final ConfirmedPasswordModel confirmedPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, confirmedPassword, status];

  SignupState copyWith({
    EmailModel? email,
    PasswordModel? password,
    ConfirmedPasswordModel? confirmedPassword,
    FormzStatus? formValidationStatus,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: formValidationStatus ?? this.status,
    );
  }
}
