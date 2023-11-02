import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/friends/domain/repository/friend_repository.dart';

part 'friend_requests_state.dart';

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  final AppUserRepository _appUserRepository;
  final FriendRepository _friendRepository;

  FriendRequestsCubit(this._appUserRepository, this._friendRepository)
      : super(FriendRequestsInitial());

  Future<void> getFriendRequestsFromUser() async {
    var friendRequests = _friendRepository.getFriendRequestsFromUser();
    emit(FriendRequestsLoaded(friendRequests));
  }

  Future<void> friendRequestResponse(
      PeerPALUser userInformation, bool isAccepted) async {
    await _friendRepository.friendRequestResponse(userInformation, isAccepted);
  }
}
