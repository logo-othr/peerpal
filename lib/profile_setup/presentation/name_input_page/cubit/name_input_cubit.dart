import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/domain/name_input_page/models/username_model.dart';

part 'name_input_state.dart';

class UsernameCubit extends Cubit<UsernameState> {
  UsernameCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(const UsernameStateInitial());

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    var currentUser = await _getAuthenticatedUser();
    emit(UsernameStateLoaded(
      formValidationStatus: state.formValidationStatus,
      username: state.newUsername,
      errorMessage: state.errorMessage,
      currentUser: currentUser,
    ));
  }

  void nameChanged(String dirtyName) {
    if (state is UsernameStateLoaded) {
      final username = UsernameModel.dirty(dirtyName);
      emit(state.copyWith(
        username: username,
        validationStatus: Formz.validate([username]),
      ));
    }
  }

  Future<void> postName() async {
    if (!state.formValidationStatus.isValidated) return;
    emit(state.copyWith(validationStatus: FormzStatus.submissionInProgress));

    try {
      var userInformation = await _getAuthenticatedUser();
      var updatedUserInformation =
          userInformation.copyWith(name: state.newUsername.value);
      await _appUserRepository.updateUser(updatedUserInformation);

      emit(state.copyWith(validationStatus: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(
          validationStatus: FormzStatus.submissionFailure,
          errorMessage: "Fehler beim aktualisieren."));
    }
  }
}
