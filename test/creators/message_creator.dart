import 'package:runnoter/domain/entity/chat.dart';

Message createMessage({
  String id = '',
  String senderId = '',
  String recipientId = '',
  String content = '',
  DateTime? dateTime,
}) =>
    Message(
      id: id,
      senderId: senderId,
      content: content,
      dateTime: dateTime ?? DateTime.now(),
    );
