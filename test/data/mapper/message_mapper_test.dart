import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/message_mapper.dart';
import 'package:runnoter/domain/entity/message.dart';

void main() {
  const String id = 'id';
  const String chatId = 'c1';
  const String senderId = 's1';
  const String content = 'content';
  final DateTime dateTime = DateTime(2023, 9, 1);

  test(
    'map message from dto, '
    'should map message from dto model to domain model',
    () {
      final MessageDto dto = MessageDto(
        id: id,
        chatId: chatId,
        senderId: senderId,
        content: content,
        dateTime: dateTime,
      );
      final Message expectedMessage = Message(
        id: id,
        chatId: chatId,
        senderId: senderId,
        content: content,
        dateTime: dateTime,
      );

      final Message message = mapMessageFromDto(dto);

      expect(message, expectedMessage);
    },
  );
}
