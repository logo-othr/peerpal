part of 'activity_feed_bloc.dart';

enum ActivityFeedStatus { initial, success, error }

class ActivityFeedState extends Equatable {
  const ActivityFeedState({
    this.status = ActivityFeedStatus.initial,
    this.activityStream =  const Stream.empty(),
    this.activityRequestList =  const Stream.empty(),
    this.activityJoinedList =  const Stream.empty(),
});

  final ActivityFeedStatus status;
  final Stream<List<Activity>> activityStream;
  final Stream<List<Activity>> activityRequestList;
  final Stream<List<Activity>> activityJoinedList;

  ActivityFeedState copyWith({
    ActivityFeedStatus? status,
    Stream<List<Activity>>? activityStream,
    Stream<List<Activity>>? activityRequestList,
    Stream<List<Activity>>? activityJoinedList,


  }) {
    return ActivityFeedState(
        status: status ?? this.status,
        activityStream: activityStream ?? this.activityStream,
        activityRequestList: activityRequestList ?? this.activityRequestList,
        activityJoinedList: activityJoinedList ?? this.activityJoinedList,


    );
  }

  @override
  List<Object> get props => [status, activityStream, activityRequestList, activityJoinedList];
}

