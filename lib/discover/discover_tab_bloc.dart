import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/login_flow/persistence/authentication_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

part 'discover_tab_event.dart';
part 'discover_tab_state.dart';

const limit = 10;

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  final AppUserRepository _appUsersRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamController<List<PeerPALUser>> _userStreamController =
      new BehaviorSubject();

  DiscoverTabBloc(this._appUsersRepository, this._authenticationRepository)
      : super(DiscoverTabState());

  @override
  Stream<DiscoverTabState> mapEventToState(DiscoverTabEvent event) async* {
    if (event is UsersLoaded) {
      Stream<List<PeerPALUser>> userStream = _appUsersRepository
          .getMatchingUsersStream(_authenticationRepository.currentUser.id,
              limit: limit);
      _userStreamController.addStream(userStream);
      yield state.copyWith(
        searchResults: state.searchResults,
        status: DiscoverTabStatus.success,
        userStream: _userStreamController.stream,
      );
    } else if (event is SearchUser) {
      List<PeerPALUser> searchResults =
          await _appUsersRepository.findUserByName(event.searchQuery);
      yield state.copyWith(
        searchResults: searchResults,
        status: state.status,
        userStream: state.userStream,
      );
    }
  }

/*Future<DiscoverTabState> lazyLoadUserList(DiscoverTabState state) async {
    if (state.hasNoMoreUsers) return state;
    try {
      if (state.status == DiscoverTabStatus.initial) {
        final List<PeerPALUser> users =
            await _appUsersRepository.getMatchingUsers(limit: limit);

        var userList = await _removeCurrentUser(users);
        return state.copyWith(
          status: DiscoverTabStatus.success,
          users: userList,
          hasNoMoreUsers: false,
        );
      }

      final PeerPALUser lastUser = state.users.last;
      final List<PeerPALUser> users = await _appUsersRepository
          .getMatchingUsers(last: lastUser, limit: limit);
      final List<PeerPALUser> updatedUserList = List.of(state.users)
        ..addAll(users);

      var userList = await _removeCurrentUser(updatedUserList);

      return users.isEmpty
          ? state.copyWith(hasNoMoreUsers: true)
          : state.copyWith(
              status: DiscoverTabStatus.success,
              users: userList,
              hasNoMoreUsers: false,
            );
    } on Exception {
      return state.copyWith(status: DiscoverTabStatus.error);
    }
  }*/
}
