import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/app/domain/analytics/analytics_repository.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/setup.dart';
import 'package:rxdart/subjects.dart';

part 'discover_feed_state.dart';

class DiscoverFeedCubit extends Cubit<DiscoverFeedState> {
  DiscoverFeedCubit(
      {required analyticsRepository,
      required appUsersRepository,
      required authenticationRepository})
      : this._appUsersRepository = appUsersRepository,
        this._authenticationRepository = authenticationRepository,
        this._analyticsRepository = analyticsRepository,
        super(DiscoverFeedInitial());

  final AppUserRepository _appUsersRepository;
  final AuthenticationRepository _authenticationRepository;
  final AnalyticsRepository _analyticsRepository;
  BehaviorSubject<List<PeerPALUser>>? _userStream;

  Future<void> loadUsers() async {
    // Find peers
    _userStream = await _appUsersRepository
        .findPeers(_authenticationRepository.currentUser.id);

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
    List<PeerPALUser> usersFound =
        await _searchUser(username: _sanitizeUsername(searchQuery));

    // Emit result
    return emit(DiscoverFeedLoaded(
      searchResults: usersFound,
      userStream: state.userStream,
      isSearchEmpty: state.isSearchEmpty,
      isSearchFocused: state.isSearchFocused,
    ));
  }

  Future<List<PeerPALUser>> _searchUser({required String username}) async {
    return await _appUsersRepository.findUserByName(username);
  }

  String _sanitizeUsername(String userName) {
    return userName.toString().trim();
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
