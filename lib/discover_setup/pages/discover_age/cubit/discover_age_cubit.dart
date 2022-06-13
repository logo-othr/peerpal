import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';

part 'discover_age_state.dart';

class DiscoverAgeCubit extends Cubit<DiscoverAgeState> {
  DiscoverAgeCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(DiscoverAgeInitial(10, 100));

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  void ageChanged(int selectedFromAge, int selectedToAge) {
    emit(DiscoverAgeInitial(selectedFromAge, selectedToAge));
  }

  Future<void> postData() async {
    var selectedFromAge = state.selctedFromAge;
    var selectedToAge = state.selectedToAge;
    emit(DiscoverAgePosting(selectedFromAge, selectedToAge));

    var authenticatedUser = await _getAuthenticatedUser();
    var updatedUserInformation = authenticatedUser.copyWith(
        discoverFromAge: selectedFromAge, discoverToAge: selectedToAge);
    await _appUserRepository.updateUserInformation(updatedUserInformation);

    emit(DiscoverAgePosted(selectedFromAge, selectedToAge));
  }
}
