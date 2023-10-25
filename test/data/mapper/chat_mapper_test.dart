import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/chat_mapper.dart';
import 'package:runnoter/data/model/chat.dart';

void main() {
  const String id = 'c1';
  const String user1Id = 'u1';
  const String user2Id = 'u2';
  final DateTime user1LastTypingDateTime = DateTime(2023, 1, 10);
  final DateTime user2LastTypingDateTime = DateTime(2023, 1, 05);

  test(
    'map chat from dto, '
    'should map chat dto model to domain chat model',
    () {
      final ChatDto chatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );
      final Chat expectedChat = Chat(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );

      final Chat chat = mapChatFromDto(chatDto);

      expect(chat, expectedChat);
    },
  );
}
