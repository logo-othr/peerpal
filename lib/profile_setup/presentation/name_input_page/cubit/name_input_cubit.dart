import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/domain/name_input_page/models/username_model.dart';

part 'name_input_state.dart';

class NameInputCubit extends Cubit<NameInputState> {
  NameInputCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(const NameInputState());

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

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
      var userInformation = await _getAuthenticatedUser();
      var updatedUserInformation =
          userInformation.copyWith(name: state.username.value);
      await _appUserRepository.updateUser(updatedUserInformation);
      await _appUserRepository
          .updateServerNameCache(updatedUserInformation.name); // ToDo: clean up
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: "Fehler beim aktualisieren."));
    }
  }

  Future<void> updateNameAtServer(String userName) async {
    await _appUserRepository.updateServerNameCache(userName.trim());
  }

  Future<String?> currentName() async {
    return (await _getAuthenticatedUser()).name;
  }
}
