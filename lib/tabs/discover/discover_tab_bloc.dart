import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
      //yield lazyStreamUserList();

    } else if (event is ReloadUsers) {
      yield await lazyLoadUserList(DiscoverTabState());
    }
  }

  /*
  Stream<List<PeerPALUser>> lazyStreamUserList() {
    Stream<List<PeerPALUser>> userStream =  _appUsersRepository.getMatchingUsersStream(limit: limit);
          _userStreamController.addStream(userStream);
          yield state.copyWith(
              status: DiscoverTabStatus.success,
              users: _userStreamController.stream,
              chatRequests: _userFriendRequestStreamController.stream
          );
  }
   */

  Future<List<PeerPALUser>> _removeCurrentUser(
      List<PeerPALUser> userList) async {
    final String currentUserId =
        (await _appUsersRepository.getCurrentUserInformation()).id!;

    var currentUser;
    for (PeerPALUser peerPALUser in userList) {
      if (peerPALUser.id == currentUserId) {
        currentUser = peerPALUser;
      }
    }

    userList.remove(currentUser);
    return userList;
  }

  Future<DiscoverTabState> lazyLoadUserList(DiscoverTabState state) async {
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
  }
}
