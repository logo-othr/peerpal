import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

part 'profile_picture_state.dart';

class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final AppUserRepository _authRepository;

  ProfilePictureCubit(this._authRepository) : super(ProfilePictureInitial());

  Future<void> pickProfilePictureFromGallery() async {
    var profilePicture =
        (await ImagePicker().getImage(source: ImageSource.gallery))!;
    profilePictureChanged(profilePicture);
  }

  Future<void> pickProfilePictureFromCamera() async {
    var profilePicture =
        (await ImagePicker().getImage(source: ImageSource.camera))!;
    profilePictureChanged(profilePicture);
  }

  void profilePictureChanged(PickedFile profilePicture) {
    emit(ProfilePicturePicked(profilePicture));
  }

  Future<void> updateProfilePicture(PickedFile profilePicture) async {
    emit(ProfilePicturePosting(profilePicture));
    var profilePictureURL = await _uploadProfilePicture(profilePicture);
    await _updateProfilePicturePath(profilePictureURL);
    emit(ProfilePicturePosted(profilePictureURL));
  }

  Future<String> _uploadProfilePicture(PickedFile profilePicture) async {
    var uid = Uuid();

    firebase_storage.UploadTask uploadTask;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user-profile-pictures')
        .child(_authRepository.currentUser.id)
        .child('${uid.v4()}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'file-path': profilePicture.path});

    uploadTask = ref.putFile(File(profilePicture.path), metadata);

    var returnURL = '';
    await Future.value(uploadTask);
    await ref.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });

    return returnURL;
  }

  Future<void> _updateProfilePicturePath(String profilePicturePath) async {
    await _authRepository.updateUserInformation(Map.from(
        {UserInformationField.userProfilePicturePath: profilePicturePath}));
  }
}
