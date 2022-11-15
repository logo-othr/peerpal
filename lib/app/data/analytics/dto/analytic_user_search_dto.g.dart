// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytic_user_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticUserSearchDTO _$AnalyticUserSearchDTOFromJson(
        Map<String, dynamic> json) =>
    AnalyticUserSearchDTO(
      userId: json['userId'] as String,
      timestamp: json['timestamp'] as String,
      searchQuery: json['searchQuery'] as String,
    );

Map<String, dynamic> _$AnalyticUserSearchDTOToJson(
        AnalyticUserSearchDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'searchQuery': instance.searchQuery,
    };
