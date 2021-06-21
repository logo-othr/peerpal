import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';
import 'package:peerpal/profile_wizard_flow/repository/user_repository.dart';

part 'start_profile_wizard_state.dart';

class StartProfileWizardCubit extends Cubit<ProfileWizardState> {
  final AppUserRepository _userRepository;

  StartProfileWizardCubit(this._userRepository)
      : super(ProfileWizardInitial());

  Future<void> getProfile(/* pass user auth */) async {
    try {
      emit(ProfileWizardLoading());
      final userProfile = await _userRepository.fetchUserProfile();
      emit(ProfileWizardLoaded(userProfile));
    } on NetworkException {
      emit(ProfileWizardError(
          "Es ist ein Fehler bei Netzwerkverbindung aufgetreten."));
    }
  }
}
