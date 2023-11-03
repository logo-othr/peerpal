import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/repository/communication_repository.dart';

part 'discover_communication_state.dart';

class DiscoverCommunicationCubit extends Cubit<DiscoverCommunicationState> {
  DiscoverCommunicationCubit(
      this._appUserRepo, this._getAuthUser, this._comRepo)
      : super(DiscoverCommunicationInitial());
  final AppUserRepository _appUserRepo;
  final GetAuthenticatedUser _getAuthUser;
  final CommunicationRepository _comRepo;

  Future<void> loadData() async {
    List<CommunicationType> communicationTypes = await _comRepo.getTypes();
    PeerPALUser authUser = await _getAuthUser();
    List<CommunicationType> selectedCommunicationTypes =
        authUser.discoverCommunicationPreferences ??
            <CommunicationType>[].cast<CommunicationType>();
    emit(DiscoverCommunicationSelected(
        communicationTypes, selectedCommunicationTypes));
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

      var userInformation = await _getAuthUser();
      var updatedUserInformation = userInformation.copyWith(
          discoverCommunicationPreferences: state.selectedCommunicationTypes);
      await _appUserRepo.updateUser(updatedUserInformation);

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
