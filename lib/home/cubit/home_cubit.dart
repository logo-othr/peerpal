import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppUserRepository _appuserRepository;

  HomeCubit(this._appuserRepository) : super(HomeInitial());

  Future<void> getCurrentUserInformation() async {
    emit(HomeLoading());
    final home = await _appuserRepository.getCurrentUserInformation();
    emit(HomeLoaded(home));
    loadFlowState();
  }



  Future<void> loadFlowState() async  {
    PeerPALUser userInformation =
        await _appuserRepository.getCurrentUserInformation();
    if (userInformation.isProfileNotComplete) {
      emit(HomeProfileFlow(userInformation));
    } else if (userInformation.isDiscoverNotComplete) {
      emit(HomeDiscoverFlow(userInformation));
    } else {
      emit(HomeUserInformationFlowCompleted(0));
    }
  }

  void indexChanged(int index){
    emit(HomeUserInformationFlowCompleted(index));
  }
}
