part of 'user_detail_bloc.dart';


enum UserDetailStatus { initial, success, error }

class UserDetailState extends Equatable {
  const UserDetailState({
    this.status = UserDetailStatus.initial,
    this.user =  PeerPALUser.empty,
  });

  final UserDetailStatus status;
  final  PeerPALUser user;

  UserDetailState copyWith({
    UserDetailStatus? status,
    PeerPALUser? user,
  }) {
    return UserDetailState(
        status: status ?? this.status,
        user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, user];
}
