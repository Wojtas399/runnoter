import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/chat_mapper.dart';
import 'package:runnoter/domain/entity/chat.dart';

void main() {
  const String id = 'c1';
  const String user1Id = 'u1';
  const String user2Id = 'u2';
  const bool isUser1Typing = true;
  const bool isUser2Typing = false;

  test(
    'map chat from dto, '
    'should map chat dto model to domain chat model',
    () {
      const ChatDto chatDto = ChatDto(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        isUser1Typing: isUser1Typing,
        isUser2Typing: isUser2Typing,
      );
      final Chat expectedChat = Chat(
        id: id,
        user1Id: user1Id,
        user2Id: user2Id,
        isUser1Typing: isUser1Typing,
        isUser2Typing: isUser2Typing,
        user1LastTypingDateTime: DateTime(2023),
        user2LastTypingDateTime: DateTime(2023),
        //TODO: Implement last typing date times
      );

      final Chat chat = mapChatFromDto(chatDto);

      expect(chat, expectedChat);
    },
  );
}
