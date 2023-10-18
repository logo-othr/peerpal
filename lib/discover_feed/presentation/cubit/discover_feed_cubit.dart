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
    _userStream = await _appUsersRepository.getMatchingUsersPaginatedStream(
        _authenticationRepository.currentUser.id);
    emit(DiscoverFeedLoaded(
      searchResults: state.searchResults,
      userStream: _userStream!.stream,
    ));
  }

  Future<void> searchUser({required String searchQuery}) async {
    GetAuthenticatedUser _getAuthenticatedUser = sl<GetAuthenticatedUser>();
    var authenticatedUser = await _getAuthenticatedUser();
    _analyticsRepository.addUserSearch(authenticatedUser.id ?? "",
        DateTime.now().millisecondsSinceEpoch.toString(), searchQuery ?? "");
    List<PeerPALUser> usersFound =
        await _searchUser(username: _sanitizeUsername(searchQuery));
    return emit(DiscoverFeedLoaded(
      searchResults: usersFound,
      userStream: state.userStream,
    ));
  }

  Future<List<PeerPALUser>> _searchUser({required String username}) async {
    return await _appUsersRepository.findUserByName(username);
  }

  String _sanitizeUsername(String userName) {
    return userName.toString().trim();
  }
}
