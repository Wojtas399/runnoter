import 'package:firebase/firebase.dart';

MessageDto createMessageDto({
  String id = '',
  String chatId = '',
  String senderId = '',
  DateTime? dateTime,
  String? text,
  List<MessageImageDto> images = const [],
}) =>
    MessageDto(
      id: id,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime ?? DateTime(2023),
      text: text ?? (images.isEmpty ? '' : null),
      images: images,
    );
