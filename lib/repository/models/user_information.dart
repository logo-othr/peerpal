import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';

enum UserInformationField {
  userAge,
  userName,
  userPhoneNumber,
  userProfilePicturePath,
}

// ToDo: Move field names from UserDatabaseContract to this extension
extension UserInformationFieldExtension on UserInformationField {
  String get fieldName {
    switch (this) {
      case UserInformationField.userAge:
        return UserDatabaseContract.userAge;
      case UserInformationField.userName:
        return UserDatabaseContract.userName;
      case UserInformationField.userPhoneNumber:
        return UserDatabaseContract.userPhoneNumber;
      case UserInformationField.userProfilePicturePath:
        return UserDatabaseContract.userProfilePicturePath;
    }
  }
}

class UserInformation extends Equatable {
  const UserInformation(
      {this.name, this.age, this.phoneNumber, this.imagePath, this.filename});

  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;
  final String? filename;

  static const empty = UserInformation();

  bool get isEmpty => this == UserInformation.empty;

  bool get isNotEmpty => this != UserInformation.empty;


  @override
  List<Object?> get props => [name, age, phoneNumber, imagePath, filename];

  UserInformation copyWith({
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
    String?  filename,
  }) {
    return UserInformation(
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
        filename: filename ?? this.filename
    );
  }
}
