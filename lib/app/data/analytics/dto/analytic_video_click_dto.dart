import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/app/domain/support_videos/support_video.dart';

part 'analytic_video_click_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticVideoClickDTO extends Equatable {
  final String userId;
  final String timestamp;
  final SupportVideo supportVideo;

  AnalyticVideoClickDTO(
      {required this.userId,
      required this.timestamp,
      required this.supportVideo});

  factory AnalyticVideoClickDTO.fromJson(Map<String, dynamic> json) =>
      _$AnalyticVideoClickDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticVideoClickDTOToJson(this);

  @override
  List<Object?> get props => [
        userId,
        timestamp,
        supportVideo,
      ];
}
