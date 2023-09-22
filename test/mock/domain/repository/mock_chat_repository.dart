import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/chat.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {
  void mockGetChatById({Chat? chat, Stream<Chat?>? chatStream}) {
    when(
      () => getChatById(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => chatStream ?? Stream.value(chat));
  }

  void mockFindChatIdForUsers({String? chatId}) {
    when(
      () => findChatIdByUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value(chatId));
  }

  void mockCreateChatForUsers({String? chatId}) {
    when(
      () => createChatForUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value(chatId));
  }

  void mockUpdateChat() {
    when(
      () => updateChat(
        chatId: any(named: 'chatId'),
        isUser1Typing: any(named: 'isUser1Typing'),
        isUser2Typing: any(named: 'isUser2Typing'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
