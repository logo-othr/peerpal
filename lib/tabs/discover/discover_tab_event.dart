part of 'discover_tab_bloc.dart';

abstract class DiscoverTabEvent extends Equatable {
  const DiscoverTabEvent();
}

class GetMatchingUsersEvent extends DiscoverTabEvent {
  @override
  List<Object?> get props => [];
}
