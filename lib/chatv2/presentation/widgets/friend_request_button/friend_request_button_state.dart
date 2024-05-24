part of 'friend_request_cubit.dart';

abstract class FriendRequestState {}

class FriendRequestInitial extends FriendRequestState {}

class FriendRequestHidden extends FriendRequestState {}

class FriendRequestVisible extends FriendRequestState {}

class FriendRequestPending extends FriendRequestState {}
