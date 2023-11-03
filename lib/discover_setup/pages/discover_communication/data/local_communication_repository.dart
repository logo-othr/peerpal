import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/repository/communication_repository.dart';

class LocalCommunicationRepository extends CommunicationRepository {
  List<CommunicationType> getTypes() {
    final communicationTypes = <CommunicationType>[];
    communicationTypes.add(CommunicationType.phone);
    communicationTypes.add(CommunicationType.chat);
    return communicationTypes;
  }
}
