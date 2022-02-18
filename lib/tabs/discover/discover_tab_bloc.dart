import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

part 'discover_tab_event.dart';

part 'discover_tab_state.dart';

const limit = 10;

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  final AppUserRepository _appUsersRepository;
 // StreamController<List<PeerPALUser>> _userStreamController = new BehaviorSubject();


  DiscoverTabBloc(this._appUsersRepository) : super(DiscoverTabState());

  @override
  Stream<DiscoverTabState> mapEventToState(DiscoverTabEvent event) async* {
    if (event is UsersLoaded) {
      yield await lazyLoadUserList(state);

      // ToDo: Implement infinite list with streams and lazy loading
     /*   Stream<List<PeerPALUser>> userStream =  _appUsersRepository.getMatchingUsersStream(limit: limit);
_userStreamController.addStream(userStream);
        yield state.copyWith(
            status: DiscoverTabStatus.success,
            users: _userStreamController.stream,
            chatRequests: _userFriendRequestStreamController.stream
        );
*/

    }
  }


  Future<DiscoverTabState> lazyLoadUserList(DiscoverTabState state) async {
    if (state.hasNoMoreUsers) return state;
    try {
      if (state.status == DiscoverTabStatus.initial) {
        final users = await _appUsersRepository.getMatchingUsers(limit: limit);
        return state.copyWith(
          status: DiscoverTabStatus.success,
          users: users,
          hasNoMoreUsers: false,
        );
      }
      final lastUser = state.users.last;
      final users = await _appUsersRepository.getMatchingUsers(
          last: lastUser, limit: limit);
      final updatedUserList = List.of(state.users)..addAll(users);
      return users.isEmpty
          ? state.copyWith(hasNoMoreUsers: true)
          : state.copyWith(
              status: DiscoverTabStatus.success,
              users: updatedUserList,
              hasNoMoreUsers: false,
            );
    } on Exception {
      return state.copyWith(status: DiscoverTabStatus.error);
    }
  }
}
