import 'package:runnoter/data/model/message.dart';

Message createMessage({
  String id = '',
  MessageStatus status = MessageStatus.sent,
  String chatId = '',
  String senderId = '',
  DateTime? dateTime,
  String? text,
}) =>
    Message(
      id: id,
      status: status,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime ?? DateTime(2023),
      text: text,
    );
