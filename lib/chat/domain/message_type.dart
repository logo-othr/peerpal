enum MessageType { text, image }

extension CommunicationTypeExtension on MessageType {
  String get toUIString {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
    }
  }

  MessageType? fromFieldName(String fieldName) {
    switch (fieldName) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
    }
  }
}
