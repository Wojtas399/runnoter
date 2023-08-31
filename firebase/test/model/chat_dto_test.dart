import 'package:firebase/model/chat_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'c1';
  const String user1Id = 'u1';
  const String user2Id = 'u2';

  test(
    'from json, '
    'should map json to dto',
    () {
      final Map<String, dynamic> json = {
        'user1Id': user1Id,
        'user2Id': user2Id,
      };
      const ChatDto expectedChatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
      );

      final ChatDto chatDto = ChatDto.fromJson(id: id, json: json);

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
      );
      final Map<String, dynamic> expectedJson = {
        'user1Id': user1Id,
        'user2Id': user2Id,
      };

      final Map<String, dynamic> json = chatDto.toJson();

      expect(json, expectedJson);
    },
  );
}
