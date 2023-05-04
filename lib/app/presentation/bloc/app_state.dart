part of 'app_bloc.dart';

enum AppAuthenticationStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = AuthUser.empty,
  });

  const AppState.authenticated(AuthUser user)
      : this._(status: AppAuthenticationStatus.authenticated, user: user);

  const AppState.unauthenticated()
      : this._(status: AppAuthenticationStatus.unauthenticated);

  final AppAuthenticationStatus status;
  final AuthUser user;

  @override
  List<Object> get props => [status, user];
}
