part of 'discover_tab_bloc.dart';

enum DiscoverTabStatus { initial, success, error }

class DiscoverTabState extends Equatable {
  const DiscoverTabState({
    this.status = DiscoverTabStatus.initial,
    this.users = const <PeerPALUser>[],
    this.hasNoMoreUsers = false,
  });

  final DiscoverTabStatus status;
  final List<PeerPALUser> users;
  final bool hasNoMoreUsers;

  DiscoverTabState copyWith({
    DiscoverTabStatus? status,
    List<PeerPALUser>? users,
    bool? hasNoMoreUsers,
  }) {
    return DiscoverTabState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasNoMoreUsers: hasNoMoreUsers ?? this.hasNoMoreUsers,
    );
  }

  @override
  List<Object> get props => [status, users, hasNoMoreUsers];
}
