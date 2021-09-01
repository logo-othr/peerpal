part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final UserInformation userInformation;

  const HomeLoaded(this.userInformation);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeLoaded && o.userInformation == userInformation;
  }

  @override
  int get hashCode => userInformation.hashCode;
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
