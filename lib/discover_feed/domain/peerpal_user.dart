import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:peerpal/data/location.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';

class PeerPALUser extends Equatable {
  const PeerPALUser(
      {this.id,
      this.name,
      this.age,
      this.phoneNumber,
      this.imagePath,
      this.discoverFromAge,
      this.discoverToAge,
      this.discoverCommunicationPreferences,
      this.discoverActivitiesCodes,
      this.discoverLocations,
      this.pushToken});

  final String? id;
  final String? name;
  final int? age;
  final String? phoneNumber;
  final String? imagePath;
  final int? discoverFromAge;
  final int? discoverToAge;
  final List<CommunicationType>? discoverCommunicationPreferences;
  final List<String>? discoverActivitiesCodes;
  final List<Location>? discoverLocations;
  final String? pushToken;

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
        discoverActivitiesCodes != null &&
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
        discoverActivitiesCodes,
        discoverLocations,
        pushToken
      ];

  PeerPALUser copyWith({
    String? id,
    String? name,
    int? age,
    String? phoneNumber,
    String? imagePath,
    int? discoverFromAge,
    int? discoverToAge,
    List<CommunicationType>? discoverCommunicationPreferences,
    List<String>? discoverActivities,
    List<Location>? discoverLocations,
    String? pushToken,
  }) {
    return PeerPALUser(
      id: id ?? this.id,
      age: age ?? this.age,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
      discoverFromAge: discoverFromAge ?? this.discoverFromAge,
      discoverToAge: discoverToAge ?? this.discoverToAge,
      discoverCommunicationPreferences: discoverCommunicationPreferences ??
          this.discoverCommunicationPreferences,
      discoverActivitiesCodes:
          discoverActivities ?? this.discoverActivitiesCodes,
      discoverLocations: discoverLocations ?? this.discoverLocations,
      pushToken: pushToken ?? this.pushToken,
    );
  }

  @override
  String toString() {
    return "\n ----- User ----- \n"
        "id: ${this.id} \n"
        "age: ${this.age} \n"
        "name: ${this.name} \n"
        "phoneNumber: ${this.phoneNumber} \n"
        "discoverFromAge: ${this.discoverFromAge} \n"
        "discoverToAge: ${this.discoverToAge} \n"
        "discoverCommunicationPreferences: ${this.discoverCommunicationPreferences?.map((e) => EnumToString.convertToString(e)).toList()} \n"
        "discoverActivities: ${this.discoverActivitiesCodes?.map((e) => e).toList()} \n"
        "discoverLocations: ${this.discoverLocations?.map((e) => e.place).toList()} \n"
        "------- \n";
  }
}
