import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/authentication_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'activity_public_overview_state.dart';

class ActivityPublicOverviewCubit extends Cubit<ActivityPublicOverviewState> {
  ActivityPublicOverviewCubit(this._activityRepository, this._appUserRepository, this._authenticationRepository)
      : super(ActivityPublicOverviewInitial());

  final ActivityRepository _activityRepository;
  final AppUserRepository _appUserRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> loadData(Activity activity) async {
    bool isAttendee = false;
    if (activity.attendeeIds != null) {
      if (activity.attendeeIds!.contains(_authenticationRepository.currentUser.id)) {
        isAttendee = true;
      }
    }

    PeerPALUser activityCreator =
        await _appUserRepository.getUserInformation(activity.creatorId!);

    List<PeerPALUser> attendees = [];

    if (activity.attendeeIds != null) {
      await Future.forEach<String>(activity.attendeeIds!, (element) async {
        PeerPALUser user = await _appUserRepository.getUserInformation(element);
        attendees.add(user);
      });
    }

    emit(ActivityPublicOverviewLoaded(
        activity, activityCreator, attendees, isAttendee));
  }

  Future<void> joinActivity() async {
    List<String> attendees;
    Activity? activity;
    if (state.activity.attendeeIds != null) {
      attendees = [];
      attendees.addAll(state.activity.attendeeIds!);
      attendees.add(_authenticationRepository.currentUser.id);
      activity = state.activity.copyWith(attendeeIds: attendees);
    }
    Activity updatedActivity = (activity ?? state.activity);

    await _activityRepository.joinActivity(state.activity);

    emit(ActivityPublicOverviewLoaded(
        updatedActivity, state.activityCreator, state.attendees, true));
  }

  Future<void> leaveActivity() async {
    List<String> attendees;
    Activity? activity;
    if (state.activity.attendeeIds != null) {
      attendees = [];
      attendees.addAll(state.activity.attendeeIds!);
      attendees.remove(_authenticationRepository.currentUser.id);
      activity = state.activity.copyWith(attendeeIds: attendees);
    }
    Activity updatedActivity = (activity ?? state.activity);

    await _activityRepository.leaveActivity(state.activity);
    emit(ActivityPublicOverviewLoaded(
        updatedActivity, state.activityCreator, state.attendees, false));
  }
}
