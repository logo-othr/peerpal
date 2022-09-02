part of 'home_cubit.dart';

@immutable
abstract class HomeState implements Equatable {
  final PeerPALUser userInformation;

  const HomeState(this.userInformation);
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(const PeerPALUser());

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeLoading extends HomeState {
  const HomeLoading() : super(const PeerPALUser());

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeLoaded extends HomeState {
  final PeerPALUser userInformation;

  const HomeLoaded(this.userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class ProfileSetupState extends HomeState {
  const ProfileSetupState(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class DiscoverSetupState extends HomeState {
  const DiscoverSetupState(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class SetupCompletedState extends HomeState {
  final int index;

  const SetupCompletedState(this.index) : super(const PeerPALUser());

  @override
  List<Object?> get props => [index];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
