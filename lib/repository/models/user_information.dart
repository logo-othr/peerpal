import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';

enum UserInformationField {
  age,
  name,
  phone,
  pictureUrl,
}

// ToDo: Move field names from UserDatabaseContract to this extension
extension UserInformationFieldExtension on UserInformationField {
  String get fieldName {
    switch (this) {
      case UserInformationField.age:
        return UserDatabaseContract.userAge;
      case UserInformationField.name:
        return UserDatabaseContract.userName;
      case UserInformationField.phone:
        return UserDatabaseContract.userPhoneNumber;
      case UserInformationField.pictureUrl:
        return UserDatabaseContract.userProfilePicturePath;
    }
  }
}

class UserInformation extends Equatable {
  const UserInformation(
      {this.name, this.age, this.phoneNumber, this.imagePath});

  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;

  static const empty = UserInformation();

  bool get isEmpty => this == UserInformation.empty;

  bool get isNotEmpty => this != UserInformation.empty;

  bool get isComplete {
    if (age != null &&
        name != null &&
        phoneNumber != null &&
        imagePath != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotComplete => isComplete != true;

  @override
  List<Object?> get props => [name, age, phoneNumber, imagePath];

  UserInformation copyWith({
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
    String? filename,
  }) {
    return UserInformation(
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  UserInformation.fromJson(Map<String, dynamic> json)
      : name = json[UserInformationField.name],
        age = json[UserInformationField.age],
        phoneNumber = json[UserInformationField.phone],
        imagePath = json[UserInformationField.pictureUrl];
}
