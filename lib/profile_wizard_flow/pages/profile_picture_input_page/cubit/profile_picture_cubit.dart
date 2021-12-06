import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:uuid/uuid.dart';


part 'profile_picture_state.dart';

class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final AppUserRepository _authRepository;

  ProfilePictureCubit(this._authRepository) : super(ProfilePictureInitial());


  Future<void> pickProfilePictureFromGallery() async {
    var profilePicture =
    (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: profilePicture.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.original],
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Passe dein Foto zurecht',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            showCropGrid: false,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Passe dein Foto zurecht',
        )
    );
    profilePictureChanged(croppedImage);
  }


  Future<void> pickProfilePictureFromCamera() async {
    var profilePicture =
    ((await ImagePicker().pickImage(source: ImageSource.camera)))!;
    File? croppedImage = = await ImageCropper.cropImage(
    sourcePath: profilePicture.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [CropAspectRatioPreset.ratio5x3],
    cropStyle: CropStyle.circle,
    compressQuality: 100,
    compressFormat: ImageCompressFormat.jpg,
    androidUiSettings: AndroidUiSettings(
    toolbarTitle: 'Passe dein Foto zurecht',
    toolbarColor: primaryColor,
    toolbarWidgetColor: Colors.white,
    activeControlsWidgetColor: primaryColor,
    initAspectRatio: CropAspectRatioPreset.original,
    hideBottomControls: true,
    showCropGrid: false,
    lockAspectRatio: false
    ),
    iosUiSettings: IOSUiSettings(
    title: 'Passe dein Foto zurecht',
    )
    );
    profilePictureChanged(croppedImage);
    }

  void profilePictureChanged(File? profilePicture) {
    emit(ProfilePicturePicked(profilePicture));
  }

  Future<String> updateProfilePicture(File? profilePicture) async {
    emit(ProfilePicturePosting(profilePicture));
    var profilePictureURL = await _uploadProfilePicture(profilePicture);
    await _updateProfilePicturePath(profilePictureURL);
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
    var userInformation = await _authRepository.getCurrentUserInformation();
    return userInformation.imagePath;
  }

  Future<void> _updateProfilePicturePath(String profilePicturePath) async {
    var userInformation = await _authRepository.getCurrentUserInformation();
    var updatedUserInformation =
    userInformation.copyWith(imagePath: profilePicturePath);
    await _authRepository.updateUserInformation(updatedUserInformation);
  }
}

