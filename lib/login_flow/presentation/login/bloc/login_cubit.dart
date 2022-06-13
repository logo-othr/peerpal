import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/login_flow/domain/domain.dart';
import 'package:peerpal/login_flow/persistence/persistence.dart';


part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email]),
    ));
  }

  void emailChanged(String dirtyEmail) {
    final email = EmailModel.dirty(dirtyEmail);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> login() async {
    if (!state.formValidationStatus.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    // ToDo: Move to auth repository
    if (_isLoginLocked()) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage:
          'Zu viele Fehlversuche. Bitte versuchen Sie es später erneut.'));
      return;
    }
    emit(state.copyWith(
        status: FormzStatus.submissionInProgress,
        lastAttempt: DateTime.now().millisecondsSinceEpoch));

    try {
      await _firebaseLogin();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LoginException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          loginCounter: (state.loginCounter + 1),
          errorMessage: e.message));
    }
  }


  Future<void> _firebaseLogin() async {
    await _authenticationRepository.loginWithEmailAndPassword(
      email: state.email.value,
      password: state.password,
    );
  }

  /*
   * This function only prevents too many login attempts
   * while the user is on the login page.
   * ToDo: Use SharedPreferences to store the last attempt.
   * ToDo: Move to repository
   */
  bool _isLoginLocked() {
    const maxLoginAttempts = 3;
    if (state.loginCounter > maxLoginAttempts) {
      const syntheticDelay = maxLoginAttempts * 60 * 1000;
      final timeSinceLastLoginAttempt =
          DateTime.now().millisecondsSinceEpoch - state.lastAttempt;
      if (timeSinceLastLoginAttempt >= syntheticDelay) {
        emit(state.copyWith(loginCounter: 0));
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  void changeVisibility(){
    emit(state.copyWith(visible: !state.visible));
  }

  bool isVisible(){
    return state.visible;
  }

}
