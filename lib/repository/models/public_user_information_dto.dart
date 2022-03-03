import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/activity.dart';

part 'public_user_information_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PublicUserInformationDTO {
  PublicUserInformationDTO(
      {this.id,
      this.name,
      this.age,
      this.discoverFromAge,
      this.discoverToAge,
      this.hasPhoneCommunicationPreference = false,
      this.hasChatCommunicationPreference = false,
      this.discoverActivities,
      this.discoverLocations,
      this.imagePath}) {
    combined_location_activities = [];
    if(discoverActivities != null) combined_location_activities.addAll(discoverActivities!);
    if(discoverLocations != null) combined_location_activities.addAll(discoverLocations!);
  }

  final String? id;
  final String? name;
  final int? age;
  final int? discoverFromAge;
  final int? discoverToAge;
  final bool? hasPhoneCommunicationPreference;
  final bool? hasChatCommunicationPreference;
  final List<String>? discoverActivities;
  final List<String>? discoverLocations;
  final String? imagePath;

  /**
   * Private class member used for firebase query. Workaround because
   * we can only use arrayContains once per query in firebase.
   * Do not use this member outside of this class.
   * Can't be private because of json generator.
   * ToDo: Think about a better implementation
   */
  late List<String> combined_location_activities;



  PublicUserInformationDTO copyWith(
      {String? id,
      String? name,
      int? age,
      int? discoverFromAge,
      int? discoverToAge,
      bool? hasPhoneCommunicationPreference,
      bool? hasChatCommunicationPreference,
      List<String>? discoverActivities,
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
