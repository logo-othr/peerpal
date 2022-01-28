part of 'activity_feed_bloc.dart';

enum ActivityFeedStatus { initial, success, error }

abstract class ActivityFeedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActivityFeedInitial extends ActivityFeedState {
  @override
  List<Object?> get props => [];
}

class ActivityFeedLoading extends ActivityFeedState {
  ActivityFeedLoading();

  @override
  List<Object?> get props => [];
}
