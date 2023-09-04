import 'entity.dart';

class Message extends Entity {
  final String chatId;
  final String senderId;
  final String content;
  final DateTime dateTime;

  const Message({
    required super.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [id, chatId, senderId, content, dateTime];
}
