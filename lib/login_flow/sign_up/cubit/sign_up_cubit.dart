import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/login_flow/sign_up/models/confirmed_password_model.dart';
import 'package:peerpal/login_flow/sign_up/models/email_model.dart';
import 'package:peerpal/login_flow/sign_up/models/password_model.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._appUserRepository) : super(const SignupState());

  final AppUserRepository _appUserRepository;

  void changeEmail(String changedEmail) {
    final email = EmailModel.dirty(changedEmail);
    emit(state.copyWith(
      email: email,
      formValidationStatus: Formz.validate([
        email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void changePassword(String changedPassword) {
    final password = PasswordModel.dirty(changedPassword);
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      formValidationStatus: Formz.validate([
        state.email,
        password,
        confirmedPassword,
      ]),
    ));
  }

  void changeConfirmedPassword(String value) {
    final confirmedPassword = ConfirmedPasswordModel.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      formValidationStatus: Formz.validate([
        state.email,
        state.password,
        confirmedPassword,
      ]),
    ));
  }

  Future<void> submitSignupForm() async {
    if (!state.status.isValidated) return;
    emit(
        state.copyWith(formValidationStatus: FormzStatus.submissionInProgress));
    try {
      await _appUserRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(formValidationStatus: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(formValidationStatus: FormzStatus.submissionFailure));
    }
  }

  void changeVisibility(int version){
    if(version==0){
      emit(state.copyWith(visible: !state.visible));
    }
    if(version==1){
      emit(state.copyWith(confirmVisible: !state.confirmVisible));
    }
  }

  bool isVisible(int version){
    if(version==0){
      return state.visible;
    }
    else{
      return state.confirmVisible;
    }
  }


}
