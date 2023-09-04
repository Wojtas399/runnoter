import 'package:runnoter/domain/entity/message.dart';

Message createMessage({
  String id = '',
  String chatId = '',
  String senderId = '',
  String content = '',
  DateTime? dateTime,
}) =>
    Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      dateTime: dateTime ?? DateTime(2023),
    );
