import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';
import 'package:rxdart/rxdart.dart';

part 'discover_feed_event.dart';

part 'discover_feed_state.dart';

class DiscoverTabBloc extends Bloc<DiscoverTabEvent, DiscoverTabState> {
  final AppUserRepository _appUsersRepository;
  final AuthenticationRepository _authenticationRepository;
  BehaviorSubject<List<PeerPALUser>>? _userStream;

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
      userStream: _userStream!.stream,
    );
  }

  Future<DiscoverTabState> _handleSearchUserEvent(
      {required SearchUser event}) async {
    // === / ToDo: usecase ===
    GetAuthenticatedUser _getAuthenticatedUser = sl<GetAuthenticatedUser>();
    var authenticatedUser = await _getAuthenticatedUser();
    sl<AnalyticsRepository>().addUserSearch(
        authenticatedUser.id ?? "",
        DateTime.now().millisecondsSinceEpoch.toString(),
        event.searchQuery ?? "");
    // =====
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
/*void fetchUser() {
    _userStream?.fetchNextDataRow();
  }*/
}
