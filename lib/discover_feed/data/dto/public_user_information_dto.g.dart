// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_user_information_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicUserInformationDTO _$PublicUserInformationDTOFromJson(
        Map<String, dynamic> json) =>
    PublicUserInformationDTO(
      id: json['id'] as String?,
      name: json['name'] as String?,
      age: (json['age'] as num?)?.toInt(),
      discoverFromAge: (json['discoverFromAge'] as num?)?.toInt(),
      discoverToAge: (json['discoverToAge'] as num?)?.toInt(),
      hasPhoneCommunicationPreference:
          json['hasPhoneCommunicationPreference'] as bool? ?? false,
      hasChatCommunicationPreference:
          json['hasChatCommunicationPreference'] as bool? ?? false,
      discoverActivities: (json['discoverActivities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      discoverLocations: (json['discoverLocations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imagePath: json['imagePath'] as String?,
    )..combined_location_activities =
        (json['combined_location_activities'] as List<dynamic>)
            .map((e) => e as String)
            .toList();

Map<String, dynamic> _$PublicUserInformationDTOToJson(
        PublicUserInformationDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'discoverFromAge': instance.discoverFromAge,
      'discoverToAge': instance.discoverToAge,
      'hasPhoneCommunicationPreference':
          instance.hasPhoneCommunicationPreference,
      'hasChatCommunicationPreference': instance.hasChatCommunicationPreference,
      'discoverActivities': instance.discoverActivities,
      'discoverLocations': instance.discoverLocations,
      'imagePath': instance.imagePath,
      'combined_location_activities': instance.combined_location_activities,
    };
