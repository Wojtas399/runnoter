import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/message.dart';
import 'package:runnoter/data/mapper/message_mapper.dart';

void main() {
  const String id = 'id';
  const String chatId = 'c1';
  const String senderId = 's1';
  final DateTime dateTime = DateTime(2023, 9, 1);
  const String text = 'text';

  test(
    'map message from dto, '
    'should map message from dto model to domain model',
    () {
      final firebase.MessageDto dto = firebase.MessageDto(
        id: id,
        status: firebase.MessageStatus.read,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final Message expectedMessage = Message(
        id: id,
        status: MessageStatus.read,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );

      final Message message = mapMessageFromDto(dto);

      expect(message, expectedMessage);
    },
  );
}
