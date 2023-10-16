import '../model/entity.dart';

class Message extends Entity {
  final MessageStatus status;
  final String chatId;
  final String senderId;
  final DateTime dateTime;
  final String? text;

  const Message({
    required super.id,
    required this.status,
    required this.chatId,
    required this.senderId,
    required this.dateTime,
    this.text,
  });

  @override
  List<Object?> get props => [id, status, chatId, senderId, dateTime, text];
}

enum MessageStatus { sent, read }
