import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/contracts/user_database_contract.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/location.dart';

part 'app_user_information.g.dart';

enum CommunicationType { phone, chat }

extension CommunicationTypeExtension on CommunicationType {
  String get toUIString {
    switch (this) {
      case CommunicationType.phone:
        return 'Telefon';
      case CommunicationType.chat:
        return 'Chat';
    }
  }

  CommunicationType? fromFieldName(String fieldName) {
    switch (fieldName) {
      case 'Telefon':
        return CommunicationType.phone;
      case 'Chat':
        return CommunicationType.chat;
    }
  }
}

enum PeerPALUserField {
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
extension UserInformationFieldExtension on PeerPALUserField {
  String get fieldName {
    switch (this) {
      case PeerPALUserField.age:
        return UserDatabaseContract.userAge;
      case PeerPALUserField.name:
        return UserDatabaseContract.userName;
      case PeerPALUserField.phone:
        return UserDatabaseContract.userPhoneNumber;
      case PeerPALUserField.pictureUrl:
        return UserDatabaseContract.userProfilePicturePath;
      case PeerPALUserField.discoverFromAge:
        return UserDatabaseContract.discoverFromAge;
      case PeerPALUserField.discoverToAge:
        return UserDatabaseContract.discoverToAge;
      case PeerPALUserField.discoverCommunicationPreferences:
        return UserDatabaseContract.discoverCommunicationPreferences;
      case PeerPALUserField.discoverActivities:
        return UserDatabaseContract.discoverActivities;
      case PeerPALUserField.discoverLocations:
        return UserDatabaseContract.discoverLocations;
    }
  }
}

@JsonSerializable(explicitToJson: true)
class PeerPALUser extends Equatable {
  const PeerPALUser(
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
  final List<CommunicationType>? discoverCommunicationPreferences;
  final List<Activity>? discoverActivities;
  final List<Location>? discoverLocations;

  static const empty = PeerPALUser();

  bool get isEmpty => this == PeerPALUser.empty;

  bool get isNotEmpty => this != PeerPALUser.empty;

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

  bool get isProfileNotComplete => isProfileComplete != true;

  bool get isDiscoverComplete {
    if (discoverFromAge != null &&
        discoverToAge != null &&
        discoverCommunicationPreferences != null &&
        discoverActivities != null &&
        discoverLocations != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isDiscoverNotComplete => isDiscoverComplete != true;

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

  PeerPALUser copyWith({
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
    int? discoverFromAge,
    int? discoverToAge,
    List<CommunicationType>? discoverCommunicationPreferences,
    List<Activity>? discoverActivities,
    List<Location>? discoverLocations,
  }) {
    return PeerPALUser(
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

  factory PeerPALUser.fromJson(Map<String, dynamic> json) =>
      _$PeerPALUserFromJson(json);

  Map<String, dynamic> toJson() => _$PeerPALUserToJson(this);
}
