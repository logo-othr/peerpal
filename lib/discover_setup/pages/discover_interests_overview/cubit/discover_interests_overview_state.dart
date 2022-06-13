part of 'discover_interests_overview_cubit.dart';

@immutable
abstract class DiscoverInterestsOverviewState extends Equatable {
  const DiscoverInterestsOverviewState();
}

class DiscoverInterestsOverviewInitial extends DiscoverInterestsOverviewState {
  DiscoverInterestsOverviewInitial() : super();

  @override
  List<Object?> get props => [];
}

class DiscoverInterestsOverviewLoaded extends DiscoverInterestsOverviewState {
  final PeerPALUser appUserInformation;

  DiscoverInterestsOverviewLoaded(this.appUserInformation);

  @override
  List<Object?> get props => [appUserInformation];
}
