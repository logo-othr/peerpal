import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppUserRepository _appuserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  HomeCubit(this._appuserRepository, this._getAuthenticatedUser)
      : super(HomeInitial());

  Future<void> getCurrentUserInformation() async {
    emit(HomeLoading());
    final home = await _getAuthenticatedUser();
    emit(HomeLoaded(home));
    loadCurrentSetupFlowState();
  }

  Future<void> loadCurrentSetupFlowState() async {
    PeerPALUser userInformation = await _getAuthenticatedUser();
    if (userInformation.isProfileNotComplete) {
      emit(ProfileSetupState(userInformation));
    } else if (userInformation.isDiscoverNotComplete) {
      emit(DiscoverSetupState(userInformation));
    } else {
      emit(SetupCompletedState(0));
    }
  }

  void indexChanged(int index) {
    emit(SetupCompletedState(index));
  }
}
