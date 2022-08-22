part of 'password_reset_cubit.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.formValidationStatus = FormzStatus.pure,
    this.email = const EmailModel.pure(),
    this.submissionMessage = '',
  });

  final FormzStatus formValidationStatus;
  final EmailModel email;
  final String submissionMessage;

  ResetPasswordState copyWith({
    FormzStatus? status,
    EmailModel? email,
    String? submissionMessage,
  }) {
    return ResetPasswordState(
      formValidationStatus: status ?? formValidationStatus,
      email: email ?? this.email,
      submissionMessage: submissionMessage ?? this.submissionMessage,
    );
  }

  @override
  List<Object> get props => [
        formValidationStatus,
        email,
        submissionMessage,
      ];
}
