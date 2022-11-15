import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytic_user_search_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticUserSearchDTO extends Equatable {
  final String userId;
  final String timestamp;
  final String searchQuery;

  AnalyticUserSearchDTO(
      {required this.userId,
      required this.timestamp,
      required this.searchQuery});

  factory AnalyticUserSearchDTO.fromJson(Map<String, dynamic> json) =>
      _$AnalyticUserSearchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticUserSearchDTOToJson(this);

  @override
  List<Object?> get props => [
        userId,
        timestamp,
        searchQuery,
      ];
}
