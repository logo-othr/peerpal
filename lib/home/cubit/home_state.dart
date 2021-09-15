part of 'home_cubit.dart';

@immutable
abstract class HomeState implements Equatable{
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeLoaded extends HomeState {
  final UserInformation userInformation;

  const HomeLoaded(this.userInformation);

  @override
  List<Object?> get props => [userInformation];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class HomeProfileFlowCompleted extends HomeState {


  const HomeProfileFlowCompleted();

  @override
  List<Object?> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
