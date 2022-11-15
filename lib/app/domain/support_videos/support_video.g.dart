// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportVideo _$SupportVideoFromJson(Map<String, dynamic> json) => SupportVideo(
      identifier: json['identifier'],
      link: json['link'],
    );

Map<String, dynamic> _$SupportVideoToJson(SupportVideo instance) =>
    <String, dynamic>{
      'identifier': _$VideoIdentifierEnumMap[instance.identifier],
      'link': instance.link,
    };

const _$VideoIdentifierEnumMap = {
  VideoIdentifier.discover_tab: 'discover_tab',
};
