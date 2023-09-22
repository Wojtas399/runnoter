import 'package:firebase/model/chat_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'c1';
  const String user1Id = 'u1';
  const String user2Id = 'u2';
  const bool isUser1Typing = false;
  const bool isUser2Typing = true;

  test(
    'from json, '
    'should map json to dto',
    () {
      final Map<String, dynamic> json = {
        'user1Id': user1Id,
        'user2Id': user2Id,
        'isUser1Typing': isUser1Typing,
        'isUser2Typing': isUser2Typing,
      };
      const ChatDto expectedChatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        isUser1Typing: isUser1Typing,
        isUser2Typing: isUser2Typing,
      );

      final ChatDto chatDto = ChatDto.fromJson(chatId: id, json: json);

      expect(chatDto, expectedChatDto);
    },
  );

  test(
    'to json, '
    'should map dto to json',
    () {
      const ChatDto chatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        isUser1Typing: isUser1Typing,
        isUser2Typing: isUser2Typing,
      );
      final Map<String, dynamic> expectedJson = {
        'user1Id': user1Id,
        'user2Id': user2Id,
        'isUser1Typing': isUser1Typing,
        'isUser2Typing': isUser2Typing,
      };

      final Map<String, dynamic> json = chatDto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'isUser1Typing is null, '
    'should not include isUser1Typing in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'isUser2Typing': isUser2Typing,
      };

      final Map<String, dynamic> json = createChatJsonToUpdate(
        isUser2Typing: isUser2Typing,
      );

      expect(json, expectedJson);
    },
  );

  test(
    'create json to update, '
    'isUser2Typing is null, '
    'should not include isUser2Typing in json',
    () {
      final Map<String, dynamic> expectedJson = {
        'isUser1Typing': isUser1Typing,
      };

      final Map<String, dynamic> json = createChatJsonToUpdate(
        isUser1Typing: isUser1Typing,
      );

      expect(json, expectedJson);
    },
  );
}
