import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'friend_requests_state.dart';

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  final AppUserRepository _appUserRepository;

  FriendRequestsCubit(this._appUserRepository) : super(FriendRequestsInitial());

  Future<void> getFriendRequestsFromUser() async {
    var friendRequests = _appUserRepository.getFriendRequestsFromUser();
    emit(FriendRequestsLoaded(friendRequests));
  }

  Future<void> friendRequestResponse(
      PeerPALUser userInformation, bool isAccepted) async {
    await _appUserRepository.friendRequestResponse(userInformation, isAccepted);
  }
}
