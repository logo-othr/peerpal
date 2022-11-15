// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytic_video_click_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticVideoClickDTO _$AnalyticVideoClickDTOFromJson(
        Map<String, dynamic> json) =>
    AnalyticVideoClickDTO(
      userId: json['userId'] as String,
      timestamp: json['timestamp'] as String,
      supportVideo:
          SupportVideo.fromJson(json['supportVideo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticVideoClickDTOToJson(
        AnalyticVideoClickDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'supportVideo': instance.supportVideo.toJson(),
    };
