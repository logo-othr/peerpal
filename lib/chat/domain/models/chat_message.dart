import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String message;
  final String timestamp;
  final String type;
  final String userId;

  ChatMessage({required this.message, required this.timestamp, required this.type, required this.userId});

  @override
  List<Object?> get props => [message, timestamp, type, userId];
}