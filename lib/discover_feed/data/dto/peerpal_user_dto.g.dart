// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peerpal_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeerPALUserDTO _$PeerPALUserDTOFromJson(Map<String, dynamic> json) =>
    PeerPALUserDTO(
      privateUserInformation: json['privateUserInformation'] == null
          ? null
          : PrivateUserInformationDTO.fromJson(
              json['privateUserInformation'] as Map<String, dynamic>),
      publicUserInformation: json['publicUserInformation'] == null
          ? null
          : PublicUserInformationDTO.fromJson(
              json['publicUserInformation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PeerPALUserDTOToJson(PeerPALUserDTO instance) =>
    <String, dynamic>{
      'privateUserInformation': instance.privateUserInformation?.toJson(),
      'publicUserInformation': instance.publicUserInformation?.toJson(),
    };
