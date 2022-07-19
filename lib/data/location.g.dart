// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      place: json['place'] as String,
      zipcode: json['zipcode'] as String?,
      street: json['street'] as String?,
      streetNumber: json['streetNumber'] as String?,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'place': instance.place,
      'zipcode': instance.zipcode,
      'street': instance.street,
      'streetNumber': instance.streetNumber,
    };
