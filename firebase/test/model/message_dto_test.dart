import 'package:firebase/model/message_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'm1';
  const String chatId = 'c1';
  const String senderId = 's1';
  const String content = 'message';
  final DateTime dateTime = DateTime(2023, 8, 31, 20, 20);

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'senderId': senderId,
        'content': content,
        'timestamp': dateTime.millisecondsSinceEpoch,
      };
      final MessageDto expectedDto = MessageDto(
        id: id,
        chatId: chatId,
        senderId: senderId,
        content: content,
        dateTime: dateTime,
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
        content: content,
        dateTime: dateTime,
      );
      final Map<String, dynamic> expectedJson = {
        'senderId': senderId,
        'content': content,
        'timestamp': dateTime.millisecondsSinceEpoch,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
