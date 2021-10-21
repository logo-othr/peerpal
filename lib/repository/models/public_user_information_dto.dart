import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';

part 'public_user_information_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PublicUserInformationDTO {
  const PublicUserInformationDTO(
      {this.id,
      this.name,
      this.age,
      this.discoverFromAge,
      this.discoverToAge,
      this.discoverCommunicationPreferences,
      this.discoverActivities,
      this.discoverLocations});

  final String? id;
  final String? name;
  final int? age;
  final int? discoverFromAge;
  final int? discoverToAge;
  final List<CommunicationType>? discoverCommunicationPreferences;
  final List<Activity>? discoverActivities;
  final List<Location>? discoverLocations;

  PublicUserInformationDTO copyWith({
    String? id,
    String? name,
    int? age,
    int? discoverFromAge,
    int? discoverToAge,
    List<CommunicationType>? discoverCommunicationPreferences,
    List<Activity>? discoverActivities,
    List<Location>? discoverLocations,
  }) {
    return PublicUserInformationDTO(
      id: id ?? this.id,
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

  factory PublicUserInformationDTO.fromJson(Map<String, dynamic> json) =>
      _$PublicUserInformationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PublicUserInformationDTOToJson(this);
}
