part of 'activity_request_list_bloc.dart';


enum ActivityRequestListStatus { initial, success, error }

class ActivityRequestListState extends Equatable {
  const ActivityRequestListState({
    this.status = ActivityRequestListStatus.initial,
    this.activityRequestList =  const Stream.empty(),
  });

  final ActivityRequestListStatus status;
  final Stream<List<Activity>> activityRequestList;

  ActivityRequestListState copyWith({
    ActivityRequestListStatus? status,
     Stream<List<Activity>>? activityRequestList,


  }) {
    return ActivityRequestListState(
      status: status ?? this.status,
      activityRequestList: activityRequestList ?? this.activityRequestList,

    );
  }

  @override
  List<Object> get props => [status, activityRequestList];
}

