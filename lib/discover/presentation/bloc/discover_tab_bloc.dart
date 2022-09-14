import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/pagination.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

part 'discover_tab_event.dart';
part 'discover_tab_state.dart';

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  final AppUserRepository _appUsersRepository;
  final AuthenticationRepository _authenticationRepository;
  PaginatedStream<PeerPALUser>? _userStream;

  DiscoverTabBloc(this._appUsersRepository, this._authenticationRepository)
      : super(DiscoverTabState());

  @override
  Stream<DiscoverTabState> mapEventToState(DiscoverTabEvent event) async* {
    if (event is LoadUsers) {
      yield await _handleLoadUsersEvent();
    } else if (event is SearchUser) {
      yield await _handleSearchUserEvent(event: event);
    }
  }

  Future<DiscoverTabState> _handleLoadUsersEvent() async {
    _userStream = await _appUsersRepository.getMatchingUsersPaginatedStream(
        _authenticationRepository.currentUser.id);
    return state.copyWith(
      searchResults: state.searchResults,
      status: DiscoverTabStatus.success,
      userStream: _userStream!.dataStream,
    );
  }

  Future<DiscoverTabState> _handleSearchUserEvent(
      {required SearchUser event}) async {
    List<PeerPALUser> usersFound =
        await _searchUser(username: _sanitizeUsername(event.searchQuery));
    return state.copyWith(
      searchResults: usersFound,
      status: state.status,
      userStream: state.userStream,
    );
  }

  // ToDo: usecase
  String _sanitizeUsername(String userName) {
    return userName.toString().trim();
  }

  // ToDo: usecase
  Future<List<PeerPALUser>> _searchUser({required String username}) async {
    return await _appUsersRepository.findUserByName(username);
  }

  // event?
  void fetchUser() {
    _userStream?.fetchNextDataRow();
  }
}