import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_peers.dart';
import 'package:peerpal/discover_feed/domain/usecase/find_user_by_name.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';
import 'package:rxdart/subjects.dart';

part 'discover_feed_state.dart';

class DiscoverFeedCubit extends Cubit<DiscoverFeedState> {
  DiscoverFeedCubit(
      {required analyticsRepository,
      required appUsersRepository,
      required findPeers,
      required findUserByName,
      required getAuthenticatedUser})
      : this._analyticsRepository = analyticsRepository,
        this._findPeers = findPeers,
        this._findUserByName = findUserByName,
        this._authenticatedUser = getAuthenticatedUser,
        super(DiscoverFeedInitial());

  final AnalyticsRepository _analyticsRepository;
  final FindPeers _findPeers;
  final FindUserByName _findUserByName;
  final GetAuthenticatedUser _authenticatedUser;
  BehaviorSubject<List<PeerPALUser>>? _userStream;

  Future<void> loadUsers() async {
    // Find peers
    _userStream = await _findPeers();

    // Emit result
    emit(DiscoverFeedLoaded(
      searchResults: state.searchResults,
      userStream: _userStream!.stream,
      isSearchEmpty: state.isSearchEmpty,
      isSearchFocused: state.isSearchFocused,
    ));
  }

  Future<void> searchUser({required String searchQuery}) async {
    // Get the authenticated app user
    GetAuthenticatedUser _getAuthenticatedUser = sl<GetAuthenticatedUser>();
    var authenticatedUser = await _getAuthenticatedUser();

    // Log the user search
    _analyticsRepository.addUserSearch(authenticatedUser.id ?? "",
        DateTime.now().millisecondsSinceEpoch.toString(), searchQuery ?? "");

    // Search for the username
    List<PeerPALUser> usersFound = await _findUserByName(searchQuery);

    // Emit result
    return emit(DiscoverFeedLoaded(
      searchResults: usersFound,
      userStream: state.userStream,
      isSearchEmpty: state.isSearchEmpty,
      isSearchFocused: state.isSearchFocused,
    ));
  }

  void setSearchFocused(bool isSearchFocused) {
    emit(DiscoverFeedLoaded(
        userStream: state.userStream,
        searchResults: state.searchResults,
        isSearchEmpty: state.isSearchEmpty,
        isSearchFocused: isSearchFocused));
  }

  void setSearchEmpty(bool isSearchEmpty) {
    emit(DiscoverFeedLoaded(
        userStream: state.userStream,
        searchResults: state.searchResults,
        isSearchEmpty: isSearchEmpty,
        isSearchFocused: state.isSearchFocused));
  }
}
