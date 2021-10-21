import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/repository/models/private_user_information_dto.dart';
import 'package:peerpal/repository/models/public_user_information_dto.dart';

part 'peerpal_user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PeerPALUserDTO {
  const PeerPALUserDTO(
      {this.privateUserInformation, this.publicUserInformation});

  factory PeerPALUserDTO.fromDomainObject(PeerPALUser peerPALUser) {
    var privateUserInformation = PrivateUserInformationDTO(
        id: peerPALUser.id,
        imagePath: peerPALUser.imagePath,
        phoneNumber: peerPALUser.phoneNumber);

    var publicUserInformation = PublicUserInformationDTO(
        id: peerPALUser.id,
        name: peerPALUser.name,
        age: peerPALUser.age,
        discoverFromAge: peerPALUser.discoverFromAge,
        discoverToAge: peerPALUser.discoverToAge,
        discoverCommunicationPreferences:
            peerPALUser.discoverCommunicationPreferences,
        discoverActivities: peerPALUser.discoverActivities,
        discoverLocations: peerPALUser.discoverLocations);

    return PeerPALUserDTO(
        privateUserInformation: privateUserInformation,
        publicUserInformation: publicUserInformation);
  }

  PeerPALUser toDomainObject() {
    return PeerPALUser(
        id: privateUserInformation?.id,
        name: publicUserInformation?.name,
        age: publicUserInformation?.age,
        discoverFromAge: publicUserInformation?.discoverFromAge,
        discoverToAge: publicUserInformation?.discoverToAge,
        discoverCommunicationPreferences:
            publicUserInformation?.discoverCommunicationPreferences,
        discoverActivities: publicUserInformation?.discoverActivities,
        discoverLocations: publicUserInformation?.discoverLocations,
        imagePath: privateUserInformation?.imagePath,
        phoneNumber: privateUserInformation?.phoneNumber);
  }

  static const empty = PeerPALUserDTO();

  bool get isEmpty => this == PeerPALUser.empty;

  bool get isNotEmpty => this != PeerPALUser.empty;

  final PrivateUserInformationDTO? privateUserInformation;
  final PublicUserInformationDTO? publicUserInformation;

  factory PeerPALUserDTO.fromJson(Map<String, dynamic> json) =>
      _$PeerPALUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PeerPALUserDTOToJson(this);
}
