part of 'profile_picture_cubit.dart';

abstract class ProfilePictureState extends Equatable {
  final PeerPALUser currentUser;

  const ProfilePictureState(this.currentUser);

  @override
  List<Object?> get props => [];
}

class ProfilePictureInitial extends ProfilePictureState {
  const ProfilePictureInitial() : super(PeerPALUser.empty);

  @override
  List<Object?> get props => [];
}

class ProfilePictureLoaded extends ProfilePictureState {
  const ProfilePictureLoaded(PeerPALUser currentUser) : super(currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class ProfilePictureEmpty extends ProfilePictureState {
  const ProfilePictureEmpty(PeerPALUser currentUser) : super(currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class ProfilePicturePicking extends ProfilePictureState {
  const ProfilePicturePicking(PeerPALUser currentUser) : super(currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class ProfilePicturePicked extends ProfilePictureState {
  final File? profilePicture;

  const ProfilePicturePicked(this.profilePicture, PeerPALUser currentUser)
      : super(currentUser);

  @override
  List<Object?> get props => [currentUser, profilePicture];
}

class ProfilePicturePosting extends ProfilePictureState {
  final File? profilePicture;

  ProfilePicturePosting(this.profilePicture, PeerPALUser currentUser)
      : super(currentUser);

  @override
  List<Object?> get props => [currentUser, profilePicture];
}

class ProfilePicturePosted extends ProfilePictureState {
  final String profilePictureURL;

  ProfilePicturePosted(this.profilePictureURL, PeerPALUser currentUser)
      : super(currentUser);

  @override
  List<Object?> get props => [currentUser, profilePictureURL];
}

class ProfilePictureError extends ProfilePictureState {
  final String message;

  ProfilePictureError(this.message, PeerPALUser currentUser)
      : super(currentUser);

  @override
  List<Object?> get props => [currentUser, message];
}
