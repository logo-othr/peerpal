import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_selection/models/username_model.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

part 'name_selection_state.dart';

class NameSelectionCubit extends Cubit<NameSelectionState> {
  NameSelectionCubit(this._appUserRepository)
      : super(const NameSelectionState());

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
    var userInformation = await _appUserRepository.getCurrentUserInformation();

    try {
      await _appUserRepository.updateUserInformation(
          userInformation.copyWith(name: state.username.value));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: "Fehler beim aktualisieren."));
    }
  }
}
