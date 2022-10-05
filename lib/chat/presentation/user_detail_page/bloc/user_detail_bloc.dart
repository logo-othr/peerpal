import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';

part 'user_detail_event.dart';

part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  String userId;
  AppUserRepository appUserRepository;

  UserDetailBloc(this.userId, this.appUserRepository)
      : super(UserDetailState());

  @override
  Stream<UserDetailState> mapEventToState(UserDetailEvent event) async* {
    if (event is LoadUserDetail) {
      PeerPALUser user =
          await appUserRepository.getUserInformation(this.userId);

      yield state.copyWith(status: UserDetailStatus.success, user: user);
    }
  }
}
