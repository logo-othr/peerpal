import 'package:peerpal/discover_setup/pages/discover_communication/domain/enum/communication_type.dart';

abstract class CommunicationRepository {
  List<CommunicationType> getTypes();
}
