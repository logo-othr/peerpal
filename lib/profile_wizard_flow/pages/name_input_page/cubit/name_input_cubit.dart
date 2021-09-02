import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:peerpal/profile_wizard_flow/pages/name_input_page/models/username_model.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

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
      await _appUserRepository.updateUserInformation(
          Map.from({UserInformationField.userName: state.username.value}));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: "Fehler beim aktualisieren."));
    }
  }
}
