import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/chat.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {
  void mockGetChatById({Chat? chat, Stream<Chat?>? chatStream}) {
    when(
      () => getChatById(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => chatStream ?? Stream.value(chat));
  }

  void mockDoUsersHaveChat({required bool expected}) {
    when(
      () => doUsersHaveChat(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value(expected));
  }

  void mockCreateChatForUsers() {
    when(
      () => createChatForUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
