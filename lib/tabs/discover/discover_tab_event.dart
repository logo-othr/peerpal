part of 'discover_tab_bloc.dart';

abstract class DiscoverTabEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersLoaded extends DiscoverTabEvent {}