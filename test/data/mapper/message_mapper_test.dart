import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/message_mapper.dart';
import 'package:runnoter/domain/entity/message.dart';

void main() {
  const String id = 'id';
  const String chatId = 'c1';
  const String senderId = 's1';
  final DateTime dateTime = DateTime(2023, 9, 1);
  const String text = 'text';
  final List<MessageImage> images = [
    MessageImage(order: 1, bytes: Uint8List(1)),
    MessageImage(order: 2, bytes: Uint8List(2)),
  ];

  test(
    'map message from dto, '
    'should map message from dto model to domain model',
    () {
      final MessageDto dto = MessageDto(
        id: id,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final Message expectedMessage = Message(
        id: id,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
        images: images,
      );

      final Message message = mapMessageFromDto(dto, images);

      expect(message, expectedMessage);
    },
  );
}
