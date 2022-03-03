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
      age: json['age'] as int?,
      discoverFromAge: json['discoverFromAge'] as int?,
      discoverToAge: json['discoverToAge'] as int?,
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
    );

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
    };
