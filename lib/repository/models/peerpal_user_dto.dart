import 'package:json_annotation/json_annotation.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';
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
        phoneNumber: peerPALUser.phoneNumber,
        pushToken: peerPALUser.pushToken);

    bool? chatPreference;
    bool? phonePreference;
    if(peerPALUser.discoverCommunicationPreferences != null) {
      phonePreference = peerPALUser
          .discoverCommunicationPreferences
          ?.contains(CommunicationType.phone) ??
          false;
      chatPreference = peerPALUser
          .discoverCommunicationPreferences
          ?.contains(CommunicationType.chat) ??
          false;
    }


    var publicUserInformation = PublicUserInformationDTO(
        imagePath: peerPALUser.imagePath,
        id: peerPALUser.id,
        name: peerPALUser.name,
        age: peerPALUser.age,
        discoverFromAge: peerPALUser.discoverFromAge,
        discoverToAge: peerPALUser.discoverToAge,
        hasPhoneCommunicationPreference: phonePreference,
        hasChatCommunicationPreference: chatPreference,
        discoverActivities: peerPALUser.discoverActivities,
        discoverLocations:
            peerPALUser.discoverLocations?.map((e) => e.place).toList());

    return PeerPALUserDTO(
        privateUserInformation: privateUserInformation,
        publicUserInformation: publicUserInformation);
  }

  PeerPALUser toDomainObject() {
    var uid = privateUserInformation?.id ?? publicUserInformation?.id;
    var pushToken = privateUserInformation?.pushToken;
    List<CommunicationType>? discoverCommunicationPreferences;


    if (publicUserInformation != null) {
      if(publicUserInformation!.hasChatCommunicationPreference == null ||
          publicUserInformation!.hasPhoneCommunicationPreference == null) {
        discoverCommunicationPreferences == null;
      } else {
        bool hasPhoneCommunicationPreference = publicUserInformation!.hasPhoneCommunicationPreference!;
        bool hasChatCommunicationPreference = publicUserInformation!.hasChatCommunicationPreference!;
        discoverCommunicationPreferences = [];
        if (hasPhoneCommunicationPreference)
          discoverCommunicationPreferences.add(CommunicationType.phone);
        if (hasChatCommunicationPreference)
          discoverCommunicationPreferences.add(CommunicationType.chat);
      }
    }

    return PeerPALUser(
      id: uid,
      name: publicUserInformation?.name,
      age: publicUserInformation?.age,
      discoverFromAge: publicUserInformation?.discoverFromAge,
      discoverToAge: publicUserInformation?.discoverToAge,
      discoverCommunicationPreferences: discoverCommunicationPreferences,
      discoverActivities: publicUserInformation?.discoverActivities,
      discoverLocations: publicUserInformation?.discoverLocations
          ?.map((e) => Location(place: e))
          .toList(),
      imagePath: publicUserInformation?.imagePath,
      phoneNumber: privateUserInformation?.phoneNumber,
      pushToken: pushToken,
    );
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
