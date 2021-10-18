enum CommunicationType { phone, chat }

extension CommunicationTypeExtension on CommunicationType {
  String get toUIString {
    switch (this) {
      case CommunicationType.phone:
        return 'Telefon';
      case CommunicationType.chat:
        return 'Chat';
    }
  }

  CommunicationType? fromFieldName(String fieldName) {
    switch (fieldName) {
      case 'Telefon':
        return CommunicationType.phone;
      case 'Chat':
        return CommunicationType.chat;
    }
  }
}
