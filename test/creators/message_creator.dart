import 'dart:typed_data';

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

MessageImage createMessageImage({int order = 1, Uint8List? data}) =>
    MessageImage(order: order, data: data ?? Uint8List(1));
