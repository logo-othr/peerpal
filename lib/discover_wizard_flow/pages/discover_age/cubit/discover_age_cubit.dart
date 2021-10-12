import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_wizard_flow/base_wizard_cubit.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'discover_age_state.dart';

class DiscoverAgeCubit extends BaseWizardCubit<DiscoverAgeState> {
  DiscoverAgeCubit(appUserRepository) : super(DiscoverAgeInitial(10, 100), appUserRepository);


  void ageChanged(int selectedFromAge, int selectedToAge) {
    emit(DiscoverAgeInitial(selectedFromAge, selectedToAge));
  }


  @override
  Future<void> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  Future<void> postData() async {
    var selectedFromAge = state.selctedFromAge;
    var selectedToAge = state.selectedToAge;
    emit(DiscoverAgePosting(selectedFromAge, selectedToAge));

    var userInformation = await appUserRepository.getCurrentUserInformation();
    var updatedUserInformation = userInformation.copyWith(discoverFromAge: selectedFromAge, discoverToAge: selectedToAge);
    await appUserRepository.updateUserInformation(updatedUserInformation);

    emit(DiscoverAgePosted(selectedFromAge, selectedToAge));
  }
}
