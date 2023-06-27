import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:rxdart/rxdart.dart';

part 'activity_invitation_state.dart';

class InvitationInputCubit extends Cubit<ActivityInvitationState> {
  InvitationInputCubit(this._appUserRepository, this._activityRepository)
      : super(ActivityInvitationInitial());

  final AppUserRepository _appUserRepository;
  final ActivityRepository _activityRepository;

  StreamController<List<PeerPALUser>> _userStreamController =
      new BehaviorSubject();

  Future<void> getData() async {
    var friends = _appUserRepository.getFriendList();
    var friendRequestsSize = _appUserRepository.getFriendRequestsSize();

    var activity = _activityRepository.getLocalActivity();
    List<String> invitationIds =
        activity.invitationIds != null ? activity.invitationIds! : [];
    List<PeerPALUser> invitations = [];
    for (var invitationId in invitationIds) {
      PeerPALUser peerPALUser = await _appUserRepository.getUser(invitationId);
      invitations.add(peerPALUser);
    }

    _userStreamController.addStream(friends);

    emit(ActivityInvitationLoaded(state.searchResults,
        _userStreamController.stream, friendRequestsSize, invitations));
  }

  void addInvitation(PeerPALUser user) {
    List<PeerPALUser> updatedInvitations = [];
    updatedInvitations.addAll(state.invitations);
    updatedInvitations.add(user);
    emit(ActivityInvitationLoaded(state.searchResults, state.friends,
        state.friendRequestsSize, updatedInvitations));
  }

  void removeInvitation(PeerPALUser user) {
    List<PeerPALUser> updatedInvitations = [];
    updatedInvitations.addAll(state.invitations);
    updatedInvitations.remove(user);
    emit(ActivityInvitationLoaded(state.searchResults, state.friends,
        state.friendRequestsSize, updatedInvitations));
  }

  bool invitationContains(PeerPALUser user) {
    for (PeerPALUser peerPALUser in state.invitations) {
      if (peerPALUser.id == user.id) return true;
    }
    return false;
  }

  Future<Activity> postData() async {
    var activity = await _activityRepository.getLocalActivity();
    activity = activity.copyWith(
        invitationIds: state.invitations.map((e) => e.id!).toList());
    _activityRepository.updateLocalActivity(activity);
    return activity;
  }

  Future<void> searchUser(String searchQuery) async {
    List<PeerPALUser> searchResults =
        await _appUserRepository.findUserByName(searchQuery);
    emit(ActivityInvitationLoaded(searchResults, state.friends,
        state.friendRequestsSize, state.invitations));
  }
}
