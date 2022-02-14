import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/activity.dart';

part 'public_user_information_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PublicUserInformationDTO {
  const PublicUserInformationDTO(
      {this.id,
      this.name,
      this.age,
      this.discoverFromAge,
      this.discoverToAge,
      this.hasPhoneCommunicationPreference = false,
      this.hasChatCommunicationPreference = false,
      this.discoverActivities,
      this.discoverLocations,
      this.imagePath});

  final String? id;
  final String? name;
  final int? age;
  final int? discoverFromAge;
  final int? discoverToAge;
  final bool? hasPhoneCommunicationPreference;
  final bool? hasChatCommunicationPreference;
  final List<Activity>? discoverActivities;
  final List<String>? discoverLocations;
  final String? imagePath;

  PublicUserInformationDTO copyWith(
      {String? id,
      String? name,
      int? age,
      int? discoverFromAge,
      int? discoverToAge,
      bool? hasPhoneCommunicationPreference,
      bool? hasChatCommunicationPreference,
      List<Activity>? discoverActivities,
      List<String>? discoverLocations,
      String? imagePath}) {
    return PublicUserInformationDTO(
        id: id ?? this.id,
        age: age ?? this.age,
        name: name ?? this.name,
        discoverFromAge: discoverFromAge ?? this.discoverFromAge,
        discoverToAge: discoverToAge ?? this.discoverToAge,
        hasPhoneCommunicationPreference: hasPhoneCommunicationPreference ??
            this.hasPhoneCommunicationPreference,
        hasChatCommunicationPreference: hasChatCommunicationPreference ??
            this.hasChatCommunicationPreference,
        discoverActivities: discoverActivities ?? this.discoverActivities,
        discoverLocations: discoverLocations ?? this.discoverLocations,
        imagePath: imagePath ?? this.imagePath);
  }

  factory PublicUserInformationDTO.fromJson(Map<String, dynamic> json) =>
      _$PublicUserInformationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PublicUserInformationDTOToJson(this);
}
