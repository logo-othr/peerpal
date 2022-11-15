// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytic_add_activity_click_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticAddActivityClickDTO _$AnalyticAddActivityClickDTOFromJson(
        Map<String, dynamic> json) =>
    AnalyticAddActivityClickDTO(
      userId: json['userId'] as String,
      timestamp: json['timestamp'] as String,
      activityId: json['activityId'] as String,
    );

Map<String, dynamic> _$AnalyticAddActivityClickDTOToJson(
        AnalyticAddActivityClickDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'activityId': instance.activityId,
    };
