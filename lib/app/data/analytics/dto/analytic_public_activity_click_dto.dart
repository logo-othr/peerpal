import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/activity/domain/models/activity.dart';

part 'analytic_public_activity_click_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticPublicActivityClickDTO extends Equatable {
  final String userId;
  final String timestamp;
  final Activity activityDTO;

  AnalyticPublicActivityClickDTO(
      {required this.userId,
      required this.timestamp,
      required this.activityDTO});

  factory AnalyticPublicActivityClickDTO.fromJson(Map<String, dynamic> json) =>
      _$AnalyticPublicActivityClickDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticPublicActivityClickDTOToJson(this);

  @override
  List<Object?> get props => [
        userId,
        timestamp,
        activityDTO,
      ];
}
