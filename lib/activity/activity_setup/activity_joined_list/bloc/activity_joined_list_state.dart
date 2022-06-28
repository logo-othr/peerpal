part of 'activity_joined_list_bloc.dart';

enum ActivityJoinedListStatus { initial, success, error }

class ActivityJoinedListState extends Equatable {
  const ActivityJoinedListState({
    this.status = ActivityJoinedListStatus.initial,
    this.activityJoinedList = const Stream.empty(),
  });

  final ActivityJoinedListStatus status;
  final Stream<List<Activity>> activityJoinedList;

  ActivityJoinedListState copyWith({
    ActivityJoinedListStatus? status,
    Stream<List<Activity>>? activityJoinedList,
  }) {
    return ActivityJoinedListState(
      status: status ?? this.status,
      activityJoinedList: activityJoinedList ?? this.activityJoinedList,
    );
  }

  @override
  List<Object> get props => [status, activityJoinedList];
}
