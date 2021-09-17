import 'package:equatable/equatable.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/location.dart';

enum CommunicationType { phone, chat }

extension CommunicationTypeExtension on CommunicationType {
  String get fieldName {
    switch (this) {
      case CommunicationType.phone:
        return 'phone';
      case CommunicationType.chat:
        return 'chat';
    }
  }
}

enum UserInformationField {
  age,
  name,
  phone,
  pictureUrl,
  discoverFromAge,
  discoverToAge,
  discoverCommunicationPreferences,
  discoverActivities,
  discoverLocations
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
      case UserInformationField.discoverFromAge:
        return UserDatabaseContract.discoverFromAge;
      case UserInformationField.discoverToAge:
        return UserDatabaseContract.discoverToAge;
      case UserInformationField.discoverCommunicationPreferences:
        return UserDatabaseContract.discoverCommunicationPreferences;
      case UserInformationField.discoverActivities:
        return UserDatabaseContract.discoverActivities;
      case UserInformationField.discoverLocations:
        return UserDatabaseContract.discoverLocations;
    }
  }
}

class UserInformation extends Equatable {
  const UserInformation(
      {this.name,
      this.age,
      this.phoneNumber,
      this.imagePath,
      this.discoverFromAge,
      this.discoverToAge,
      this.discoverCommunicationPreferences,
      this.discoverActivities,
      this.discoverLocations});

  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;
  final int? discoverFromAge;
  final int? discoverToAge;
  final Map<CommunicationType, bool>? discoverCommunicationPreferences;
  final List<Activity>? discoverActivities;
  final List<Location>? discoverLocations;

  static const empty = UserInformation();

  bool get isEmpty => this == UserInformation.empty;

  bool get isNotEmpty => this != UserInformation.empty;

  bool get isProfileComplete {
    if (age != null &&
        name != null &&
        phoneNumber != null &&
        imagePath != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotComplete => isProfileComplete != true;

  @override
  List<Object?> get props => [
        name,
        age,
        phoneNumber,
        imagePath,
        discoverFromAge,
        discoverToAge,
        discoverCommunicationPreferences,
        discoverActivities,
        discoverLocations
      ];

  UserInformation copyWith({
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
    int? discoverFromAge,
    int? discoverToAge,
    Map<CommunicationType, bool>? discoverCommunicationPreferences,
    List<Activity>? discoverActivities,
    List<Location>? discoverLocations,
  }) {
    return UserInformation(
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
      discoverFromAge: discoverFromAge ?? this.discoverFromAge,
      discoverToAge: discoverToAge ?? this.discoverToAge,
      discoverCommunicationPreferences: discoverCommunicationPreferences ??
          this.discoverCommunicationPreferences,
      discoverActivities: discoverActivities ?? this.discoverActivities,
      discoverLocations: discoverLocations ?? this.discoverLocations,
    );
  }
}
