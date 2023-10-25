import 'package:firebase/firebase.dart';

MessageDto createMessageDto({
  String id = '',
  MessageStatus status = MessageStatus.sent,
  String chatId = '',
  String senderId = '',
  DateTime? dateTime,
  String? text,
}) =>
    MessageDto(
      id: id,
      status: status,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime ?? DateTime(2023),
      text: text,
    );
