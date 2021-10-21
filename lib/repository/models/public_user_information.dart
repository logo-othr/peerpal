import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';

part 'public_user_information.g.dart';

@JsonSerializable(explicitToJson: true)
class PublicUserInformation {
  const PublicUserInformation(
      {this.name,
      this.age,
      this.discoverFromAge,
      this.discoverToAge,
      this.discoverCommunicationPreferences,
      this.discoverActivities,
      this.discoverLocations});

  final String? name;
  final int? age;
  final int? discoverFromAge;
  final int? discoverToAge;
  final List<CommunicationType>? discoverCommunicationPreferences;
  final List<Activity>? discoverActivities;
  final List<Location>? discoverLocations;

  PublicUserInformation copyWith({
    String? name,
    int? age,
    int? discoverFromAge,
    int? discoverToAge,
    List<CommunicationType>? discoverCommunicationPreferences,
    List<Activity>? discoverActivities,
    List<Location>? discoverLocations,
  }) {
    return PublicUserInformation(
      age: age ?? this.age,
      name: name ?? this.name,
      discoverFromAge: discoverFromAge ?? this.discoverFromAge,
      discoverToAge: discoverToAge ?? this.discoverToAge,
      discoverCommunicationPreferences: discoverCommunicationPreferences ??
          this.discoverCommunicationPreferences,
      discoverActivities: discoverActivities ?? this.discoverActivities,
      discoverLocations: discoverLocations ?? this.discoverLocations,
    );
  }

  factory PublicUserInformation.fromJson(Map<String, dynamic> json) =>
      _$PublicUserInformationFromJson(json);

  Map<String, dynamic> toJson() => _$PublicUserInformationToJson(this);
}
