part of 'activity_feed_bloc.dart';

enum ActivityFeedStatus { initial, success, error }

class ActivityFeedState extends Equatable {
  const ActivityFeedState({
    this.status = ActivityFeedStatus.initial,
    this.publicActivityStream = const Stream.empty(),
    this.createdActivityStream = const Stream.empty(),
    this.activityRequestList = const Stream.empty(),
    this.activityJoinedList = const Stream.empty(),
  });

  final ActivityFeedStatus status;
  final Stream<List<Activity>> publicActivityStream;
  final Stream<List<Activity>> createdActivityStream;
  final Stream<List<Activity>> activityRequestList;
  final Stream<List<Activity>> activityJoinedList;

  ActivityFeedState copyWith({
    ActivityFeedStatus? status,
    Stream<List<Activity>>? publicActivityStream,
    Stream<List<Activity>>? createdActivityStream,
    Stream<List<Activity>>? activityRequestList,
    Stream<List<Activity>>? activityJoinedList,
  }) {
    return ActivityFeedState(
      status: status ?? this.status,
      publicActivityStream: publicActivityStream ?? this.publicActivityStream,
      createdActivityStream:
          createdActivityStream ?? this.createdActivityStream,
      activityRequestList: activityRequestList ?? this.activityRequestList,
      activityJoinedList: activityJoinedList ?? this.activityJoinedList,
    );
  }

  @override
  List<Object> get props => [
        status,
        publicActivityStream,
        createdActivityStream,
        activityRequestList,
        activityJoinedList
      ];
}
