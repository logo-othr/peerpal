// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      creatorId: json['creatorId'] as String?,
      creatorName: json['creatorName'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      attendeeIds: (json['attendeeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      invitationIds: (json['invitationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      public: json['public'] as bool?,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'creatorId': instance.creatorId,
      'creatorName': instance.creatorName,
      'date': instance.date?.toIso8601String(),
      'location': instance.location?.toJson(),
      'attendeeIds': instance.attendeeIds,
      'invitationIds': instance.invitationIds,
      'public': instance.public,
    };
