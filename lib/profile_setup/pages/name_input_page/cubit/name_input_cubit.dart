import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/profile_setup/pages/name_input_page/models/username_model.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'name_input_state.dart';

class NameInputCubit extends Cubit<NameInputState> {
  NameInputCubit(this._appUserRepository) : super(const NameInputState());

  final AppUserRepository _appUserRepository;

  void nameChanged(String dirtyName) {
    final username = UsernameModel.dirty(dirtyName);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([username]),
    ));
  }

  Future<void> postName() async {
    if (!state.formValidationStatus.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      var userInformation =
          await _appUserRepository.getCurrentUserInformation();
      var updatedUserInformation =
          userInformation.copyWith(name: state.username.value);
      await _appUserRepository.updateUserInformation(updatedUserInformation);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: "Fehler beim aktualisieren."));
    }
  }

  Future<String?>currentName() async{
    var userInformation =
    await _appUserRepository.getCurrentUserInformation();
    return userInformation.name;
  }
}
