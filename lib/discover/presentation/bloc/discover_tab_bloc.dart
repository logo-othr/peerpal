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
    if (event is UsersLoaded) {
      try {
        _userStream = await _appUsersRepository.getMatchingUsersPaginatedStream(
            _authenticationRepository.currentUser.id);
        yield state.copyWith(
          searchResults: state.searchResults,
          status: DiscoverTabStatus.success,
          userStream: _userStream!.dataStream,
        );
      } catch (e) {
        print(e);
      }
    } else if (event is SearchUser) {
      List<PeerPALUser> searchResults = await _appUsersRepository
          .findUserByName(event.searchQuery.toString().trim());
      yield state.copyWith(
        searchResults: searchResults,
        status: state.status,
        userStream: state.userStream,
      );
    }
  }

  void fetchUser() {
    _userStream?.fetchNextDataRow();
  }
}
