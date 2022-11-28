import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

part 'friends_overview_state.dart';

class FriendsOverviewCubit extends Cubit<FriendsOverviewState> {
  FriendsOverviewCubit(this._appUserRepository)
      : super(FriendsOverviewInitial());

  final AppUserRepository _appUserRepository;

  @override
  Future<void> close() async {
    await closeStreams();
    return super.close();
  }

  Future<void> closeStreams() async {
    logger.w("Close friendsController");
    //await friendsController.stream.drain();
    await friendsController.close();
    logger.w("Close friendRequestsSizeController");
    // await friendRequestsSizeController.stream.drain();
    await friendRequestsSizeController.close();
  }

  StreamController<List<PeerPALUser>> friendsController = new BehaviorSubject();
  StreamController<int> friendRequestsSizeController = new BehaviorSubject();

  Future<void> getFriendsFromUser() async {
    friendsController = new BehaviorSubject();
    friendRequestsSizeController = new BehaviorSubject();
    Stream<List<PeerPALUser>> friends = _appUserRepository.getFriendList();
    friendsController.addStream(friends);

    Stream<int> friendRequestsSize = _appUserRepository.getFriendRequestsSize();
    friendRequestsSizeController.addStream(friendRequestsSize);

    emit(FriendsOverviewLoaded(
        friendsController.stream, friendRequestsSizeController.stream));
  }
}
