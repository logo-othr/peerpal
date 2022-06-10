import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';

part 'discover_communication_state.dart';

class DiscoverCommunicationCubit extends Cubit<DiscoverCommunicationState> {
  DiscoverCommunicationCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(DiscoverCommunicationInitial());
  final AppUserRepository _appUserRepository;
final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    var activities = await _appUserRepository.loadCommunicationList();
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
          await _getAuthenticatedUser();
      var updatedUserInformation = userInformation.copyWith(
          discoverCommunicationPreferences: state.selectedCommunicationTypes);
      await _appUserRepository.updateUserInformation(updatedUserInformation);

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
