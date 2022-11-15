import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'support_video_enum.dart';

part 'support_video.g.dart';

@JsonSerializable(explicitToJson: true)
class SupportVideo extends Equatable {
  SupportVideo({required identifier, required link})
      : this.identifier = identifier,
        this.link = link;

  final VideoIdentifier identifier;
  final String link;

  factory SupportVideo.fromJson(Map<String, dynamic> json) =>
      _$SupportVideoFromJson(json);

  Map<String, dynamic> toJson() => _$SupportVideoToJson(this);

  @override
  List<Object?> get props => [
        identifier,
        link,
      ];
}
