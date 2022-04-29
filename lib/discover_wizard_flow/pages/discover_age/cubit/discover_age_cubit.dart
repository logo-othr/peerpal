import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'discover_age_state.dart';

class DiscoverAgeCubit extends Cubit<DiscoverAgeState>{
  DiscoverAgeCubit(this._appUserRepository) : super(DiscoverAgeInitial(10, 100));

  final AppUserRepository _appUserRepository;

  void ageChanged(int selectedFromAge, int selectedToAge) {

    emit(DiscoverAgeInitial(selectedFromAge, selectedToAge));

  }



  Future<void> postData() async {
    var selectedFromAge = state.selctedFromAge;
    var selectedToAge = state.selectedToAge;
    emit(DiscoverAgePosting(selectedFromAge, selectedToAge));

    var userInformation = await _appUserRepository.getCurrentUserInformation();
    var updatedUserInformation = userInformation.copyWith(discoverFromAge: selectedFromAge, discoverToAge: selectedToAge);
    await _appUserRepository.updateUserInformation(updatedUserInformation);

    emit(DiscoverAgePosted(selectedFromAge, selectedToAge));
  }
}
