import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

part 'friends_overview_state.dart';

class FriendsOverviewCubit extends Cubit<FriendsOverviewState> {
  FriendsOverviewCubit(this._appUserRepository)
      : super(FriendsOverviewInitial());

  final AppUserRepository _appUserRepository;

  Future<void> getFriendsFromUser() async {
    var friends = _appUserRepository.getFriendList();
    var friendRequestsSize = _appUserRepository.getFriendRequestsSize();
    emit(FriendsOverviewLoaded(friends, friendRequestsSize));
  }
}
