part of 'profile_overview_cubit.dart';

@immutable
abstract class ProfileOverviewState extends Equatable {
  const ProfileOverviewState();
}

class ProfileOverviewInitial extends ProfileOverviewState {
  ProfileOverviewInitial() : super();

  @override
  List<Object?> get props => [];
}

class ProfileOverviewLoaded extends ProfileOverviewState {
  final AppUserInformation appUserInformation;

  ProfileOverviewLoaded(this.appUserInformation);

  @override
  List<Object?> get props => [appUserInformation];
}
