part of 'activity_joined_list_bloc.dart';

@immutable
abstract class ActivityJoinedListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadActivityJoinedList extends ActivityJoinedListEvent {}
