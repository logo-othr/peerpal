import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/app_user.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AppUserRepository appUserRepository})
      : _appUserRepository = appUserRepository,
        super(
          appUserRepository.currentUser.isNotEmpty
              ? AppState.authenticated(appUserRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _appUserRepository.user.listen(_onUserChanged);
  }

  final AppUserRepository _appUserRepository;
  late final StreamSubscription<AppUser> _userSubscription;

  void _onUserChanged(AppUser user) => add(AppUserChanged(user));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_appUserRepository.logout());
    }
  }

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
