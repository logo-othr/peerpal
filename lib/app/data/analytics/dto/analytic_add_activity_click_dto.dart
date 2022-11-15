import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytic_add_activity_click_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticAddActivityClickDTO extends Equatable {
  final String userId;
  final String timestamp;
  final String activityId;

  AnalyticAddActivityClickDTO(
      {required this.userId,
      required this.timestamp,
      required this.activityId});

  factory AnalyticAddActivityClickDTO.fromJson(Map<String, dynamic> json) =>
      _$AnalyticAddActivityClickDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticAddActivityClickDTOToJson(this);

  @override
  List<Object?> get props => [
        userId,
        timestamp,
        activityId,
      ];
}
