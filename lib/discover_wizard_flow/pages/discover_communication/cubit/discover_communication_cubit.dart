import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_wizard_flow/base_wizard_cubit.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

part 'discover_communication_state.dart';

class DiscoverCommunicationCubit extends BaseWizardCubit<DiscoverCommunicationState> {
  DiscoverCommunicationCubit(appUserRepository)
      : super(DiscoverCommunicationInitial(), appUserRepository);


  Future<void> loadData() async {
    var activities = await appUserRepository.loadCommunicationList();
    emit(DiscoverCommunicationSelected(
        activities, <CommunicationType>[].cast<CommunicationType>()));
  }

  void addCommunication(CommunicationType communication) {
    if (state is DiscoverCommunicationSelected) {
      var updatedCommunicationPreferences =
          List<CommunicationType>.from(state.selectedCommunicationTypes);
      updatedCommunicationPreferences.add(communication);

      emit(DiscoverCommunicationSelected(
          state.communicationTypes, updatedCommunicationPreferences));
    }
  }

  void removeCommunication(CommunicationType communication) {
    if (state is DiscoverCommunicationSelected) {
      var updatedCommunicationPreferences =
          List<CommunicationType>.from(state.selectedCommunicationTypes);
      updatedCommunicationPreferences.remove(communication);

      emit(DiscoverCommunicationSelected(
          state.communicationTypes, updatedCommunicationPreferences));
    }
  }

  Future<void> postData() async {
    if (state is DiscoverCommunicationSelected) {
      emit(DiscoverCommunicationPosting(
          state.communicationTypes, state.selectedCommunicationTypes));

      var userInformation =
          await appUserRepository.getCurrentUserInformation();
      var updatedUserInformation = userInformation.copyWith(
          discoverCommunicationPreferences: state.selectedCommunicationTypes);
      await appUserRepository.updateUserInformation(updatedUserInformation);

      emit(DiscoverCommunicationPosted(
          state.communicationTypes, state.selectedCommunicationTypes));
    }
  }

  void toggleCommunicationType(CommunicationType communicationType) {
    if (state.selectedCommunicationTypes.contains(communicationType)) {
      removeCommunication(communicationType);
    } else {
      addCommunication(communicationType);
    }
  }
}
