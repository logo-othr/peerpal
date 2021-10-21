import 'package:json_annotation/json_annotation.dart';

part 'private_user_information.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivateUserInformation {
  PrivateUserInformation({
    this.phoneNumber,
    this.imagePath,
  });

  final String? phoneNumber;
  final String? imagePath;

  PrivateUserInformation copyWith({
    String? phoneNumber,
    String? imagePath,
  }) {
    return PrivateUserInformation(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory PrivateUserInformation.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserInformationFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateUserInformationToJson(this);
}
