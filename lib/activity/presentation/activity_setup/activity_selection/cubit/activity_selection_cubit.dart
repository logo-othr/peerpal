import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/activity/domain/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';

part 'activity_selection_state.dart';

class ActivitySelectionCubit extends Cubit<ActivitySelectionState> {
  ActivitySelectionCubit(this._activityRepository) : super(ActivitiesInitial());
  final ActivityRepository _activityRepository;

  Future<void> loadData() async {
    var activities = await _activityRepository.loadActivityList();
    emit(ActivitiesLoaded(activities));
  }

  Future<Activity> getCurrentActivity() async {
    var activity = await _activityRepository.getLocalActivity();
    return activity;
  }

  Future<void> postData(Activity activity) async {
    if (state is ActivitiesLoaded) {
      emit(ActivitiesLoaded(state.activities));
      _activityRepository.updateLocalActivity(activity);
    }
  }
}
