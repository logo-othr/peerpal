import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/authentication/domain/models/email_model.dart';
import 'package:peerpal/authentication/exceptions/login_exception.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';

part 'password_reset_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authenticationRepository)
      : super(const ResetPasswordState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String dirtyEmail) {
    final email = EmailModel.dirty(dirtyEmail);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> resetPassword() async {
    if (!state.formValidationStatus.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      bool isEmailFound = await _authenticationRepository.resetPassword(
          email: state.email.value);
      if (isEmailFound)
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            submissionMessage: 'Mail wurde erfolgreich gesendet'));
      else if (!isEmailFound) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            submissionMessage: 'Passwort-Reset fehlgeschlagen.'));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            submissionMessage: 'Passwort-Reset fehlgeschlagen.'));
      }
    } on LoginException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, submissionMessage: e.message));
    }
  }
}
