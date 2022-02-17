// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_user_information_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateUserInformationDTO _$PrivateUserInformationDTOFromJson(
        Map<String, dynamic> json) =>
    PrivateUserInformationDTO(
      id: json['id'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      pushToken: json['pushToken'] as String?,
    );

Map<String, dynamic> _$PrivateUserInformationDTOToJson(
        PrivateUserInformationDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'pushToken': instance.pushToken,
    };
