import 'package:firebase/model/message_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'm1';
  const String chatId = 'c1';
  const String senderId = 's1';
  final DateTime dateTime = DateTime(2023, 8, 31, 20, 20);
  const String text = 'message';

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'senderId': senderId,
        'timestamp': dateTime.millisecondsSinceEpoch,
        'text': text,
      };
      final MessageDto expectedDto = MessageDto(
        id: id,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );

      final MessageDto dto = MessageDto.fromJson(
        messageId: id,
        chatId: chatId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final MessageDto dto = MessageDto(
        id: id,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final Map<String, dynamic> expectedJson = {
        'senderId': senderId,
        'timestamp': dateTime.millisecondsSinceEpoch,
        'text': text,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
