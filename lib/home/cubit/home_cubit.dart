import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

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



  void loadFlowState() {
    if (state.userInformation.isProfileNotComplete) {
      emit(HomeProfileFlow(state.userInformation));
    }
    else if (state.userInformation.isDiscoverNotComplete) {
      emit(HomeDiscoverFlow(state.userInformation));
    } else {
      emit(HomeUserInformationFlowCompleted());
    }
  }
}
