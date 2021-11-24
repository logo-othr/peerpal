import 'package:json_annotation/json_annotation.dart';

part 'private_user_information_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivateUserInformationDTO {
  PrivateUserInformationDTO({this.id, this.phoneNumber, this.pushToken});

  final String? id;
  final String? phoneNumber;
  final String? pushToken;

  PrivateUserInformationDTO copyWith({
    String? id,
    String? phoneNumber,
    String? pushToken,
  }) {
    return PrivateUserInformationDTO(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pushToken: pushToken ?? this.pushToken,
    );
  }

  factory PrivateUserInformationDTO.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserInformationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateUserInformationDTOToJson(this);
}
