import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/chat.dart';
import 'package:runnoter/data/repository/chat/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {
  void mockGetChatById({Chat? chat, Stream<Chat?>? chatStream}) {
    when(
      () => getChatById(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => chatStream ?? Stream.value(chat));
  }

  void mockGetChatsContainingUser({
    required Stream<List<Chat>> chatsStream,
  }) {
    when(
      () => getChatsContainingUser(userId: any(named: 'userId')),
    ).thenAnswer((_) => chatsStream);
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
        user1LastTypingDateTime: any(named: 'user1LastTypingDateTime'),
        user2LastTypingDateTime: any(named: 'user2LastTypingDateTime'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteChat() {
    when(
      () => deleteChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value());
  }
}
