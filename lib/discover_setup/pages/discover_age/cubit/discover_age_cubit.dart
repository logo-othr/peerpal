import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'discover_age_state.dart';

class DiscoverAgeCubit extends Cubit<DiscoverAgeState> {
  DiscoverAgeCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(DiscoverAgeInitial(1, 120));

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    PeerPALUser authenticatedUser = await _getAuthenticatedUser();
    int discoverFromAge = authenticatedUser.discoverFromAge ?? 1;
    int discoverToAge = authenticatedUser.discoverToAge ?? 120;
    emit(DiscoverAgeInitial(discoverFromAge, discoverToAge));
  }

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
    await _appUserRepository.updateUser(updatedUserInformation);

    emit(DiscoverAgePosted(selectedFromAge, selectedToAge));
  }

  Future<int> getInitialFromAge() async {
    PeerPALUser authenticatedUser = await _getAuthenticatedUser();
    int discoverFromAge = authenticatedUser.discoverFromAge ?? 1;
    emit(DiscoverAgeInitial(discoverFromAge, state.selectedToAge));
    return discoverFromAge;
  }

  Future<int> getInitialToAge() async {
    PeerPALUser authenticatedUser = await _getAuthenticatedUser();
    int discoverToAge = authenticatedUser.discoverToAge ?? 120;
    emit(DiscoverAgeInitial(state.selctedFromAge, discoverToAge));
    return discoverToAge;
  }
}
