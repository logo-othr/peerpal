import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'activity_overview_state.dart';

class OverviewInputCubit extends Cubit<ActivityOverviewState> {
  OverviewInputCubit(this._activityRepository, this._appUserRepository)
      : super(ActivityOverviewInitial());

  final ActivityRepository _activityRepository;
  final AppUserRepository _appUserRepository;

  Future<void> loadData() async {
    Activity activity = _activityRepository.getCurrentActivity();
    PeerPALUser activityCreator =
        await _appUserRepository.getUserInformation(activity.creatorId!);
    List<PeerPALUser> attendees = [];

    if (activity.invitationIds != null) {
      await Future.forEach<String>(activity.invitationIds!, (element) async {
        PeerPALUser user = await _appUserRepository.getUserInformation(element);
        attendees.add(user);
      });
    }

    emit(ActivityOverviewLoaded(activity, activityCreator, attendees));
  }

  setActivityToPublic() async {
    var updatedActivity = state.activity.copyWith(public: true);
    await _activityRepository.updateActivity(updatedActivity);
    emit(ActivityOverviewLoaded(
        updatedActivity, state.activityCreator, state.attendees));
  }



  setActivityToPrivate() async {
    var updatedActivity = state.activity.copyWith(public: false);
    await _activityRepository.updateActivity(updatedActivity);
    emit(ActivityOverviewLoaded(
        updatedActivity, state.activityCreator, state.attendees));
  }

  Future<void> postData(String description) async {
    var updatedActivity = state.activity.copyWith(description: description);
    await _activityRepository.updateActivity(updatedActivity);
    await _activityRepository.postActivity(state.activity);
  }
}
