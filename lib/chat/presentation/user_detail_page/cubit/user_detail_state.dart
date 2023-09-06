part of 'user_detail_cubit.dart';

class UserDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {
  @override
  List<Object?> get props => [];
}

class UserDetailLoaded extends UserDetailState {
  final PeerPALUser user;

  UserDetailLoaded({required this.user});

  @override
  List<Object> get props => [user];
}
