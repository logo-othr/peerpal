import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'activity_overview_state.dart';

class OverviewInputCubit extends Cubit<ActivityOverviewState> {
  OverviewInputCubit(this._activityRepository, this._appUserRepository) : super(ActivityOverviewInitial());

  final ActivityRepository _activityRepository;
final AppUserRepository _appUserRepository;

  Future<void> loadData() async {
    Activity activity = _activityRepository.getCurrentActivity();
    PeerPALUser activityCreator = await _appUserRepository.getUserInformation(activity.creatorId!);
    List<PeerPALUser> attendees = [];

    if(activity.attendeeIds != null) {
      activity.attendeeIds!.forEach((element) async {
        attendees.add(await _appUserRepository.getUserInformation(element));
      }) ;
    }

    emit(ActivityOverviewLoaded(activity, activityCreator, attendees));
  }

  setActivityToPublic() {
    state.activity.copyWith(public: true);
    _activityRepository.updateActivity(state.activity);
  }

  setActivityToPrivate() {
    state.activity.copyWith(public: false);
    _activityRepository.updateActivity(state.activity);
  }


}