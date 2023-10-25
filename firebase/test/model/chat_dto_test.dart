import 'package:firebase/model/chat_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'c1';
  const String user1Id = 'u1';
  const String user2Id = 'u2';
  final DateTime user1LastTypingDateTime = DateTime(2023, 1, 10);
  final DateTime user2LastTypingDateTime = DateTime(2023, 1, 8);
  final int user1LastTypingTimestamp =
      user1LastTypingDateTime.millisecondsSinceEpoch;
  final int user2LastTypingTimestamp =
      user2LastTypingDateTime.millisecondsSinceEpoch;

  test(
    'from json, '
    'should map json to dto',
    () {
      final Map<String, dynamic> json = {
        'user1Id': user1Id,
        'user2Id': user2Id,
        'user1LastTypingTimestamp': user1LastTypingTimestamp,
        'user2LastTypingTimestamp': user2LastTypingTimestamp,
      };
      final ChatDto expectedChatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );

      final ChatDto chatDto = ChatDto.fromJson(chatId: id, json: json);

      expect(chatDto, expectedChatDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      final ChatDto chatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );
      final Map<String, dynamic> expectedJson = {
        'user1Id': user1Id,
        'user2Id': user2Id,
        'user1LastTypingTimestamp': user1LastTypingTimestamp,
        'user2LastTypingTimestamp': user2LastTypingTimestamp,
      };

      final Map<String, dynamic> json = chatDto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'user1LastTypingDateTime is null, '
    'should not include user1LastTypingTimestamp in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'user2LastTypingTimestamp': user2LastTypingTimestamp,
      };

      final Map<String, dynamic> json = createChatJsonToUpdate(
        user2LastTypingDateTime: user2LastTypingDateTime,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'user2LastTypingDateTime is null, '
    'should not include user2LastTypingTimestamp in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'user1LastTypingTimestamp': user1LastTypingTimestamp,
      };

      final Map<String, dynamic> json = createChatJsonToUpdate(
        user1LastTypingDateTime: user1LastTypingDateTime,
      );

      expect(json, expectedJson);
    },
  );
}
