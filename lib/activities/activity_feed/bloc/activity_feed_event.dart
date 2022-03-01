part of 'activity_feed_bloc.dart';

@immutable
abstract class ActivityFeedEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadActivityFeed extends ActivityFeedEvent {}



