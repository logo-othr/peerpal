import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/authentication/persistence/authentication_repository.dart';
import 'package:peerpal/peerpal_user/data/repository/app_user_repository.dart';
import 'package:peerpal/peerpal_user/domain/peerpal_user.dart';
import 'package:peerpal/peerpal_user/domain/usecase/get_user_usecase.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/resources/colors.dart';

part 'profile_picture_state.dart';

class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final AppUserRepository _userRepository;
  final AuthenticationRepository _authRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  ProfilePictureCubit(
      this._userRepository, this._authRepository, this._getAuthenticatedUser)
      : super(ProfilePictureInitial());

  Future<void> pickProfilePictureFromGallery() async {
    var profilePicture = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1280,
      maxWidth: 720,
      imageQuality: 65,
    ))!;
    ImageCropper imageCropper = ImageCropper();
    File? croppedImage = await imageCropper.cropImage(
        sourcePath: profilePicture.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.original],
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Passe dein Foto an',
            toolbarColor: PeerPALAppColor.primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: PeerPALAppColor.primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            showCropGrid: false,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          doneButtonTitle: "Fertig",
          cancelButtonTitle: "Abbrechen",
          title: 'Passe dein Foto an',
        ))!;

    if (croppedImage != null) {
      profilePictureChanged(croppedImage);
    }
  }

  Future<void> pickProfilePictureFromCamera() async {
    var profilePicture = ((await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1280,
      maxWidth: 720,
      imageQuality: 65,
    )))!;
    ImageCropper imageCropper = ImageCropper();
    File? croppedImage = await imageCropper.cropImage(
        sourcePath: profilePicture.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.ratio5x3],
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Passe dein Foto an',
            toolbarColor: PeerPALAppColor.primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: PeerPALAppColor.primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            showCropGrid: false,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Passe dein Foto zurecht',
        ))!;
    if (croppedImage != null) {
      profilePictureChanged(croppedImage);
    }
  }

  void profilePictureChanged(File? profilePicture) {
    emit(ProfilePicturePicked(profilePicture));
  }

  Future<String> updateProfilePicture(File? profilePicture) async {
    var profilePictureURL = '';

    if (profilePicture == null) {
      await _updateProfilePicturePath('');
    } else {
      emit(ProfilePicturePosting(profilePicture));
      profilePictureURL = await _uploadProfilePicture(profilePicture);
      await _updateProfilePicturePath(profilePictureURL);
    }
    emit(ProfilePicturePosted(profilePictureURL));
    return profilePictureURL;
  }

  Future<String> _uploadProfilePicture(File? profilePicture) async {
    var uid = Uuid();

    firebase_storage.UploadTask uploadTask;
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user-profile-pictures')
        .child(_authRepository.currentUser.id)
        .child('${uid.v4()}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'file-path': profilePicture!.path});

    uploadTask = ref.putFile(File(profilePicture.path), metadata);

    var returnURL = '';
    await Future.value(uploadTask);
    await ref.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });

    return returnURL;
  }

  Future<String?> getProfilePicturePath() async {
    var userInformation = await _getAuthenticatedUser();
    return userInformation.imagePath;
  }

  Future<void> _updateProfilePicturePath(String profilePicturePath) async {
    PeerPALUser user = await _getAuthenticatedUser();
    PeerPALUser updatedUser = user.copyWith(imagePath: profilePicturePath);
    await _userRepository.updateUserInformation(updatedUser);
  }
}
