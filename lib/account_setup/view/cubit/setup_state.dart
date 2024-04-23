part of 'setup_cubit.dart';

@immutable
abstract class SetupState implements Equatable {
  final PeerPALUser userInformation;

  const SetupState(this.userInformation);
}

class HomeInitial extends SetupState {
  const HomeInitial() : super(const PeerPALUser());

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeLoading extends SetupState {
  const HomeLoading() : super(const PeerPALUser());

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeLoaded extends SetupState {
  final PeerPALUser userInformation;

  const HomeLoaded(this.userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class ProfileSetupState extends SetupState {
  const ProfileSetupState(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class DiscoverSetupState extends SetupState {
  const DiscoverSetupState(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class NotificationSetupState extends SetupState {
  NotificationSetupState(PeerPALUser userInformation) : super(userInformation);

  @override
  // TODO: implement props
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class SetupCompletedState extends SetupState {
  final int index;

  const SetupCompletedState(this.index) : super(const PeerPALUser());

  @override
  List<Object?> get props => [index];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
