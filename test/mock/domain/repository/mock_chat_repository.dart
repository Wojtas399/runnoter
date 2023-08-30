import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/chat.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {
  void mockGetChatByUsers({
    Chat? chat,
    Stream<Chat?>? chatStream,
  }) {
    when(
      () => getChatByUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => chatStream ?? Stream.value(chat));
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
