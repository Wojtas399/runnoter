import 'package:runnoter/domain/entity/message.dart';

Message createMessage({
  String id = '',
  String chatId = '',
  String senderId = '',
  DateTime? dateTime,
  String? text,
}) =>
    Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime ?? DateTime(2023),
      text: text,
    );
