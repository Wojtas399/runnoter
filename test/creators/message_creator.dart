import 'package:runnoter/domain/entity/message.dart';

Message createMessage({
  String id = '',
  String chatId = '',
  String senderId = '',
  DateTime? dateTime,
  String? text,
  List<MessageImage> images = const [],
}) =>
    Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime ?? DateTime(2023),
      text: text ?? (images.isEmpty ? '' : null),
      images: images,
    );
