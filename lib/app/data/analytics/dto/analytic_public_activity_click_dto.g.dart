// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytic_public_activity_click_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticPublicActivityClickDTO _$AnalyticPublicActivityClickDTOFromJson(
        Map<String, dynamic> json) =>
    AnalyticPublicActivityClickDTO(
      userId: json['userId'] as String,
      timestamp: json['timestamp'] as String,
      activityDTO:
          Activity.fromJson(json['activityDTO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticPublicActivityClickDTOToJson(
        AnalyticPublicActivityClickDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'activityDTO': instance.activityDTO.toJson(),
    };
