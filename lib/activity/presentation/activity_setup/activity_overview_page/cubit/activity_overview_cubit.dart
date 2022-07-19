import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';

part 'activity_overview_state.dart';

class OverviewInputCubit extends Cubit<ActivityOverviewState> {
  OverviewInputCubit(this._activityRepository, this._appUserRepository,
      this._activityReminderRepository)
      : super(ActivityOverviewInitial());

  final ActivityRepository _activityRepository;
  final AppUserRepository _appUserRepository;
  final ActivityReminderRepository _activityReminderRepository;

  Future<void> loadData({Activity? activityToChange}) async {
    Activity activity =
        activityToChange ?? _activityRepository.getCurrentActivity();
    if (activityToChange != null)
      _activityRepository.updateLocalActivity(activity);
    PeerPALUser activityCreator =
        await _appUserRepository.getUserInformation(activity.creatorId!);
    List<PeerPALUser> invitationIds = [];
    List<PeerPALUser> attendees = [];

    if (activity.attendeeIds != null) {
      await Future.forEach<String>(activity.attendeeIds!, (element) async {
        PeerPALUser user = await _appUserRepository.getUserInformation(element);
        attendees.add(user);
      });
    }
    if (activity.invitationIds != null) {
      await Future.forEach<String>(activity.invitationIds!, (element) async {
        PeerPALUser user = await _appUserRepository.getUserInformation(element);
        invitationIds.add(user);
      });
    }

    emit(ActivityOverviewLoaded(
        activity, activityCreator, attendees, invitationIds));
  }

  setActivityToPublic() async {
    var updatedActivity = state.activity.copyWith(public: true);
    await _activityRepository.updateLocalActivity(updatedActivity);
    emit(ActivityOverviewLoaded(updatedActivity, state.activityCreator,
        state.attendees, state.invitationIds));
  }

  setActivityToPrivate() async {
    var updatedActivity = state.activity.copyWith(public: false);
    await _activityRepository.updateLocalActivity(updatedActivity);
    emit(ActivityOverviewLoaded(updatedActivity, state.activityCreator,
        state.attendees, state.invitationIds));
  }

  Future<void> updateActivity(String description, String timestamp) async {
    var updatedActivity =
        state.activity.copyWith(description: description, timestamp: timestamp);
    await _activityRepository.updateLocalActivity(updatedActivity);
    await _activityRepository.updateActivity(updatedActivity);
  }

  Future<void> createActivity(String description, String timestamp) async {
    var createActivity =
        state.activity.copyWith(description: description, timestamp: timestamp);
    await _activityRepository.updateLocalActivity(createActivity);
    await _activityRepository.postActivity(createActivity);
    await _activityReminderRepository.setReminderForActivity(createActivity);
  }

  Future<void> deleteActivity() async {
    var deleteActivity = state.activity;
    await _activityRepository.deleteActivity(deleteActivity);
  }
}
