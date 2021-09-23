import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

part 'discover_communication_state.dart';

class DiscoverCommunicationCubit extends Cubit<DiscoverCommunicationState> {
  DiscoverCommunicationCubit(this._appUserRepository)
      : super(DiscoverCommunicationInitial());

  final AppUserRepository _appUserRepository;

  Future<void> loadCommunications() async {
    var activities = await _appUserRepository.loadCommunicationList();
    emit(DiscoverCommunicationSelected(activities, [].cast<CommunicationType>()));
  }


  void addCommunication(CommunicationType communication) {
    if (state is DiscoverCommunicationSelected) {
      var updatedCommunicationPreferences = List<CommunicationType>.from(state.selectedCommunicationTypes);
      updatedCommunicationPreferences.add(communication);

      emit(DiscoverCommunicationSelected(state.communicationTypes,
          updatedCommunicationPreferences));
    }
  }

  void removeCommunication(CommunicationType communication) {
    if (state is DiscoverCommunicationSelected) {
      var updatedCommunicationPreferences = List<CommunicationType>.from(state.selectedCommunicationTypes);
      updatedCommunicationPreferences.remove(communication);

      emit(DiscoverCommunicationSelected(state.communicationTypes,
          updatedCommunicationPreferences));
    }
  }

  Future<void> postCommunications() async {
    if(state is DiscoverCommunicationSelected) {
      emit(DiscoverCommunicationPosting(state.communicationTypes, state.selectedCommunicationTypes));

      var userInformation = await _appUserRepository.getCurrentUserInformation();
      var updatedUserInformation =
      userInformation.copyWith(discoverCommunicationPreferences: state.selectedCommunicationTypes);
      await _appUserRepository.updateUserInformation(updatedUserInformation);

      emit(DiscoverCommunicationPosted(state.communicationTypes, state.selectedCommunicationTypes));
    }
  }
}
