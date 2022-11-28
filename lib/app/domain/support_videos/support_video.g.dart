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
  VideoIdentifier.activity_tab: 'activity_tab',
  VideoIdentifier.chat_tab: 'chat_tab',
  VideoIdentifier.settings_tab: 'settings_tab',
  VideoIdentifier.friends_tab: 'friends_tab',
  VideoIdentifier.chat_request_tab: 'chat_request_tab',
  VideoIdentifier.activity_invitation_tab: 'activity_invitation_tab',
  VideoIdentifier.settings_profile_tab: 'settings_profile_tab',
};
