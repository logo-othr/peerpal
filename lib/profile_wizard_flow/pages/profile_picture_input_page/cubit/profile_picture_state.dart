part of 'profile_picture_cubit.dart';

abstract class ProfilePictureState extends Equatable {

  const ProfilePictureState();
  @override
  List<Object?> get props => [];
}

class ProfilePictureInitial extends ProfilePictureState {

  const ProfilePictureInitial() ;

  @override
  List<Object?> get props => [];
}

class ProfilePictureEmpty extends ProfilePictureState {
  const ProfilePictureEmpty();

  @override
  List<Object?> get props => [];
}

class ProfilePicturePicking extends ProfilePictureState {
  const ProfilePicturePicking();

  @override
  List<Object?> get props => [];
}

class ProfilePicturePicked extends ProfilePictureState {
  final PickedFile profilePicture;

  const ProfilePicturePicked(this.profilePicture);

  @override
  List<Object?> get props => [profilePicture];
}

class ProfilePicturePosting extends ProfilePictureState {
  final PickedFile profilePicture;

  ProfilePicturePosting(this.profilePicture);

  @override
  List<Object?> get props => [profilePicture];
}

class ProfilePicturePosted extends ProfilePictureState {
  final String profilePictureURL;

  ProfilePicturePosted(this.profilePictureURL);

  @override
  List<Object?> get props => [profilePictureURL];
}

class ProfilePictureError extends ProfilePictureState {
  final String message;

  ProfilePictureError(this.message);

  @override
  List<Object?> get props => [message];
}
