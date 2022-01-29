import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
part 'activity_selection_state.dart';

class ActivitySelectionCubit extends Cubit<ActivitySelectionState> {


  ActivitySelectionCubit(this._activityRepository) : super(ActivitiesInitial());
  final ActivityRepository _activityRepository;

  Future<void> loadData() async {
    var activities = await _activityRepository.loadActivityList();
    emit(ActivitiesLoaded(activities));
  }



  @override
  Future<void> postData() async {
    if (state is ActivitiesLoaded) {
      emit(ActivitiesLoaded(state.activities));
      // ToDo: Post data
    }
  }

}
