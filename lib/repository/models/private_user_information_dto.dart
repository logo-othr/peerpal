import 'package:json_annotation/json_annotation.dart';

part 'private_user_information_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivateUserInformationDTO {
  PrivateUserInformationDTO({
    this.id,
    this.phoneNumber,
  });

  final String? id;
  final String? phoneNumber;

  PrivateUserInformationDTO copyWith({
    String? id,
    String? phoneNumber,
    String? imagePath,
  }) {
    return PrivateUserInformationDTO(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory PrivateUserInformationDTO.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserInformationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateUserInformationDTOToJson(this);
}
