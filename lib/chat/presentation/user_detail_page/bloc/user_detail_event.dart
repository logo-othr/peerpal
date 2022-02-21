part of 'user_detail_bloc.dart';

@immutable
abstract class UserDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserDetail extends UserDetailEvent {}
