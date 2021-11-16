import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'discover_tab_event.dart';

part 'discover_tab_state.dart';

const limit = 10;

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  final AppUserRepository _appUsersRepository;

  DiscoverTabBloc(this._appUsersRepository) : super(DiscoverTabState());

  @override
  Stream<DiscoverTabState> mapEventToState(DiscoverTabEvent event) async* {
    if (event is UsersLoaded) {
      yield await _mapUsersLoadedToState(state);
    }
  }

  Future<DiscoverTabState> _mapUsersLoadedToState(
      DiscoverTabState state) async {
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
          lastUser: lastUser, limit: limit);
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
