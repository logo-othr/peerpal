part of 'discover_tab_bloc.dart';

abstract class DiscoverTabEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersLoaded extends DiscoverTabEvent {}

class ReloadUsers extends DiscoverTabEvent {}

class SearchUser extends DiscoverTabEvent {
  final searchQuery;

  SearchUser(this.searchQuery);
}
