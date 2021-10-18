import 'package:peerpal/repository/contracts/user_database_contract.dart';

extension PeerPALUserFieldExtension on PeerPALUserField {
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
