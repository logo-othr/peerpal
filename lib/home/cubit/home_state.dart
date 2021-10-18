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

class HomeProfileFlow extends HomeState {
  const HomeProfileFlow(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeDiscoverFlow extends HomeState {
  const HomeDiscoverFlow(userInformation) : super(userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeUserInformationFlowCompleted extends HomeState {
  const HomeUserInformationFlowCompleted() : super(const PeerPALUser());

  @override
  List<Object?> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
