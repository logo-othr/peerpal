import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'activity_invitation_state.dart';

class InvitationInputCubit extends Cubit<ActivityInvitationState> {
  InvitationInputCubit(this._appUserRepository, this._activityRepository) : super( ActivityInvitationInitial());

  final AppUserRepository _appUserRepository;
  final ActivityRepository _activityRepository;


  Future<void> getFriendsFromUser() async {
    var friends = _appUserRepository.getFriendList();
    var friendRequestsSize = _appUserRepository.getFriendRequestsSize();
    emit(ActivityInvitationLoaded(friends, friendRequestsSize, state.invitations));
  }

  void addInvitation(PeerPALUser user) {

    List<PeerPALUser> updatedInvitations = [];
    updatedInvitations.addAll(state.invitations);
    updatedInvitations.add(user);
    emit(ActivityInvitationLoaded(state.friends, state.friendRequestsSize, updatedInvitations));
  }

  void removeInvitation(PeerPALUser user) {
    List<PeerPALUser> updatedInvitations = [];
    updatedInvitations.addAll(state.invitations);
    updatedInvitations.remove(user);
    emit(ActivityInvitationLoaded(state.friends, state.friendRequestsSize, updatedInvitations));
  }

  bool invitationContains(PeerPALUser user) {
    return state.invitations.contains(user);
  }

  Future<Activity> postData() async {
    var activity = await _activityRepository.getCurrentActivity();
    activity = activity.copyWith(invitationIds: state.invitations.map((e) => e.id!).toList());
    _activityRepository.updateActivity(activity);
    return activity;
  }

}