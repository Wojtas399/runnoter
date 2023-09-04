import 'package:firebase/firebase.dart';

MessageDto createMessageDto({
  String id = '',
  String chatId = '',
  String senderId = '',
  String content = '',
  DateTime? dateTime,
}) =>
    MessageDto(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      dateTime: dateTime ?? DateTime(2023),
    );
